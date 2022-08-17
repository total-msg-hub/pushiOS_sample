//
//  MainTableVC.m
//  koreanair
//
//  Created by 정종현 on 2014. 2. 24..
//  Copyright (c) 2014년 정종현. All rights reserved.
//

#import "MainTableVC.h"
#import "MainTableVCCell.h"
#import "CommonNotiAlertView.h"
#import "CommonFunctions.h"
#import "Controller.h"

@implementation MainTableVC

@synthesize topView;
@synthesize bottomView;
@synthesize tableview;
@synthesize btnPush, btnAllSelect;
@synthesize array;
@synthesize tableList;
@synthesize isSelect;
@synthesize aSpinner;

- (void)viewDidLoad
{
    isEdit = NO;
    isSelect = NO;
    self.tableList = [NSMutableArray array];
    self.array = [NSMutableArray array];
    
    [self loadList];
    
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refreshList)
                                                 name:@"NOTIFICATIONREFRESH" object:nil];
    
    [self.upmclable setText:[PushManager defaultManager].info.host];
}

//
// 화면이 나타나기 전에 호출된다.
//
- (void)viewWillAppear:(BOOL)animated
{
    [self.upmclable setText:[PushManager defaultManager].info.host];
}

-(void)viewDidUnload
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)refreshList
{
    [self loadList];
}

- (void)loadList
{
    self.tableList = [CommonFunctions getPushItems:@"PushItems"];
        
    [array removeAllObjects];
    for (int i = 0; i < [self.tableList count]; i++) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setObject:@"0" forKey:@"selected"];
        [array addObject:dict];
        
//        if([[[tableList objectAtIndex:i] objectForKey:@"new"] isEqualToString:@"Y"])
//        {
//            [CommonHandler getInstance].gBadgeNum++;
//        }
    }

    [self.tableview reloadData];
}

-(void)setIsSelect:(BOOL)value {
    isSelect = value;
    if (isSelect) {
        [btnAllSelect setImage:[UIImage imageNamed:@"check_on.png"] forState:UIControlStateNormal];
        //[self buttonVisible:YES];
    } else {
        [btnAllSelect setImage:[UIImage imageNamed:@"check_off.png"] forState:UIControlStateNormal];
        //[self buttonVisible:NO];
    }
    for (int i = 0; i < [array count]; i++) {
        NSMutableDictionary *dict = (NSMutableDictionary *)[array objectAtIndex:i];
        if (isSelect) {
            [dict setObject:@"1" forKey:@"selected"];
        } else {
            [dict setObject:@"0" forKey:@"selected"];
        }
    }
    [tableview reloadData];
}

-(BOOL)isSelect {
	return isSelect;
}

- (IBAction)onPreviewClick
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"안내" message:@"로그아웃하시면 푸시 메세지를 받을수없습니다.!!" delegate:self cancelButtonTitle:@"예" otherButtonTitles:@"아니요",nil];
    alert.tag = 99;
    [alert show];
}
- (IBAction)onEditClick
{
}

- (IBAction)onPushClick
{
}

- (IBAction)onAllSelectClick
{
    self.isSelect = !isSelect;
}

-(IBAction)onDeleteClick
{
    int deleteCount = 0;
    for (int i = 0; i < [array count]; i++) {
        NSString *selected = [[array objectAtIndex:i] objectForKey:@"selected"];
        if ([selected isEqualToString:@"0"]) {
            continue;
        }
        deleteCount++;
    }
    if (deleteCount == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"안내" message:@"삭제할 메시지를 선택해주세요" delegate:self cancelButtonTitle:@"확인" otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"안내" message:@"선택한 메시지를 삭제하시겠습니까?" delegate:self cancelButtonTitle:@"예" otherButtonTitles:@"아니요",nil];
    alert.tag = 88;
    [alert show];
}

-(void)processDelete
{
    int deleteCount = 0;
    for (int i = 0; i < [array count]; i++) {
        NSString *selected = [[array objectAtIndex:i] objectForKey:@"selected"];
        if ([selected isEqualToString:@"0"]) {
            continue;
        }
        deleteCount++;
    }
    if (deleteCount == 0) {
        return;
    }
    for (int i = [array count]; i > 0; i--) {
        NSString *selected = [[array objectAtIndex:i-1] objectForKey:@"selected"];
        if ([selected isEqualToString:@"0"]) {
            continue;
        }
        [CommonFunctions deleteDataInTable:@"PushItems" key:[[tableList objectAtIndex:i-1] objectForKey:@"seqno"]];
    }
    
    [self loadList];
    self.isSelect = NO;
    [tableview reloadData];
}

-(IBAction)onCancelClick{
    self.isSelect = NO;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    switch(alertView.tag)
    {
        case 99:
        {
            if(buttonIndex==0)
            {
                [self startIndi];
                [[PushManager defaultManager] unregisterUser:self completionHandler:^(BOOL success)
                {
                    if(success == YES)
                    {
                        [self endIndi];
                        [CommonHandler getInstance].gIsAuth = NO;
                        [[CommonHandler getInstance] saveEnvironmentSetup:YES];
                        
                        [[Controller getInstance] setPreviousViewController:NO];
                    }
                    else
                    {
                        [self endIndi];
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"오류" message:@"유저 삭제에 실패하였습니다." delegate:self cancelButtonTitle:@"확인" otherButtonTitles:nil];
                        [alert show];
                    }
                }];
            }
        }
            break;
        case 88:
        {
            if(buttonIndex==0)
            {
                [self processDelete];
            }
        }
            break;
    }
}

#pragma mark -
#pragma mark Table Delegation Methods
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 68;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [self.tableList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"MainTableVCCell";
    
    MainTableVCCell *cell = (MainTableVCCell *)[tableview dequeueReusableCellWithIdentifier:cellIdentifier];
	
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"MainTableVCCell" owner:self options:nil];
        for (id obj in nib) {
            if ([obj isKindOfClass:[MainTableVCCell class]]) {
                cell = (MainTableVCCell *)obj;
			}
		}
    }
    NSUInteger row = [indexPath row];
	
	[[[cell subviews] objectAtIndex:0] setBackgroundColor:((row % 2 == 0) ? [UIColor whiteColor] : [UIColor colorWithRed:250.0/255.0 green:250.0/255.0 blue:250.0/255.0 alpha:1.0])];
    
	NSString *selected = [[self.array objectAtIndex:indexPath.row] objectForKey:@"selected"];

    
    cell.lblTitle.text = [[self.tableList objectAtIndex:indexPath.row] objectForKey:@"alert"];
    cell.lblBody.text = [[self.tableList objectAtIndex:indexPath.row] objectForKey:@"body"];
    NSString *date = [[self.tableList objectAtIndex:indexPath.row] objectForKey:@"senddate"];
    if([date length] > 10)
    {
        cell.lblTime.text = [NSString stringWithFormat:@"%@\n%@", [date substringWithRange:NSMakeRange(0, 10)], [date substringWithRange:NSMakeRange(10, [date length] - 10)]];
    }
    cell.row = row;
    cell.isSelected = ([selected isEqualToString:@"0"] ? NO : YES);
    if([[[tableList objectAtIndex:indexPath.row] objectForKey:@"new"] isEqualToString:@"Y"])
    {
        cell.lblNew.hidden = NO;
        cell.imgNew.hidden = NO;
    }
    else
    {
        cell.lblNew.hidden = YES;
        cell.imgNew.hidden = YES;

    }
    cell.delegate = self;

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    id  appDelegate = [UIApplication sharedApplication].delegate;
    
    CommonNotiAlertView *commonNotiPopView = [[CommonNotiAlertView alloc] initWithFrame:[self getSafeFrame] delegate:self state:3000];

    [[appDelegate window] addSubview:commonNotiPopView];

    [commonNotiPopView setTitleText:[[tableList objectAtIndex:indexPath.row] objectForKey:@"alert"]];
    [commonNotiPopView setDetailView:[tableList objectAtIndex:indexPath.row]];
    

    if([[[tableList objectAtIndex:indexPath.row] objectForKey:@"new"] isEqualToString:@"Y"])
    {
        if([CommonFunctions updateItemsDB:@"PushItems" uniquekey:[[tableList objectAtIndex:indexPath.row] objectForKey:@"seqno"] new:@"N"])
        {
            [[tableList objectAtIndex:indexPath.row] setObject:@"N" forKey:@"new"];
            [tableview reloadData];
        }
    }
}

-(void)didSelected:(int)row withValue:(BOOL)selected {
	if (row >= 0 && row < [array count]) {
		NSMutableDictionary *dict = (NSMutableDictionary *)[array objectAtIndex:row];
		if (selected) {
			[dict setObject:@"1" forKey:@"selected"];
		} else {
			[dict setObject:@"0" forKey:@"selected"];
		}
        
        int deleteCount = 0;
        for (int i = 0; i < [array count]; i++) {
            NSString *selected = [[array objectAtIndex:i] objectForKey:@"selected"];
            if ([selected isEqualToString:@"0"]) {
                continue;
            }
            deleteCount++;
        }
        if (deleteCount == 0) {
            //[self buttonVisible:NO];
        }
        else
        {
            //[self buttonVisible:YES];
        }
	}
}

- (void)buttonVisible:(BOOL)flag
{
    if(flag)
    {
        if(isEdit)
            return;
        isEdit = YES;
        CGRect temp2 = bottomView.frame;
        CGRect temp3 = tableview.frame;
        temp2.origin.y -= 150;
        temp3.size.height -= 150;
        bottomView.frame = temp2;
        tableview.frame = temp3;
    }
    else
    {
        if(!isEdit)
            return;
        isEdit = NO;
        CGRect temp2 = bottomView.frame;
        CGRect temp3 = tableview.frame;
        temp2.origin.y += 150;
        temp3.size.height += 150;
        bottomView.frame = temp2;
        tableview.frame = temp3;
    }
}

-(void)startIndi
{
    [self.aSpinner stopAnimating];
    UIActivityIndicatorView *tempSpinner = [[UIActivityIndicatorView alloc]
                                            initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.aSpinner = tempSpinner;
    CGRect frame = aSpinner.frame;
    frame.origin.x = self.view.frame.size.width / 2 - aSpinner.frame.size.width / 2;
    frame.origin.y = self.view.frame.size.height / 2 - aSpinner.frame.size.height / 2;
    aSpinner.frame = frame;
    
    [self.view addSubview:self.aSpinner];
    [self.aSpinner startAnimating];
}

-(void)endIndi
{
    [self.aSpinner stopAnimating];
}

- (IBAction)onUPMCClick
{
    [CommonHandler getInstance].gIsAuth = NO;
    [[CommonHandler getInstance] saveEnvironmentSetup:YES];
    
    [[Controller getInstance] setPreviousViewController:NO];
}

@end
