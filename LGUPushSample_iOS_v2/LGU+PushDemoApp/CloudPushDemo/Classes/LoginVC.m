//
//  LoginVC.m
//  koreanair
//
//  Created by 정종현 on 2014. 2. 24..
//  Copyright (c) 2014년 정종현. All rights reserved.
//

#import "LoginVC.h"
#import "CommonHandler.h"
#import "Controller.h"
#import "CommonFunctions.h"

@implementation LoginVC

@synthesize tfID, tfName, tfProject;
@synthesize btnLogin;
@synthesize aSpinner;
@synthesize conView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if([CommonHandler getInstance].gIsSaveUserName)
    {
        tfName.text = [CommonHandler getInstance].gUserName;
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    pickerList = [NSMutableArray array];
    [pickerList addObject:@"https://upmc.msghub.uplus.co.kr/upmc"];
    [pickerList addObject:@"https://upmc.msghub-qa.uplus.co.kr/upmc"];
    [pickerList addObject:@"https://upmc.msghub-dev.uplus.co.kr/upmc"];
    
    [[PushManager defaultManager].info changeHost:@"https://upmc.msghub.uplus.co.kr/upmc"];
    
    [self.picker setDelegate:self];
    [self.picker setDataSource:self];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}



#pragma mark - keyboard movements
- (void)keyboardWillShow:(NSNotification *)notification
{
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;

    [UIView animateWithDuration:0.3 animations:^{
        CGRect f = self.conView.frame;
        f.origin.y = -keyboardSize.height;
        self.conView.frame = f;
    }];
}

-(void)keyboardWillHide:(NSNotification *)notification
{
    [UIView animateWithDuration:0.3 animations:^{
        CGRect f = self.conView.frame;
        f.origin.y = 0.0f;
        self.conView.frame = f;
    }];
}
//
// 화면이 나타나기 전에 호출된다.
//
- (void)viewWillAppear:(BOOL)animated {
    if([CommonHandler getInstance].gIsSaveUserName)
    {
        tfName.text = [CommonHandler getInstance].gUserName;
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	
	switch(alertView.tag)
	{
		case 1:
			[tfID becomeFirstResponder];
			break;
		case 2:
			[tfName becomeFirstResponder];
			break;
        case 77:
        {
            if(buttonIndex==0)
            {
                [self pushRegist];
            }
        }
            break;
    }
}

- (IBAction)onIDSave
{
}

- (IBAction)onOrderLogin
{
    [tfID resignFirstResponder];
    [tfName resignFirstResponder];
    [tfProject resignFirstResponder];
    
    NSString *yourID = tfID.text;
    NSString *yourName = tfName.text;
    NSString *projectid = tfProject.text;
    
    if([yourID length] == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"오류" message:@"아이디를 입력하세요" delegate:self cancelButtonTitle:@"확인" otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    if([yourName length] == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"오류" message:@"이름을 입력하세요" delegate:self cancelButtonTitle:@"확인" otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    if([projectid length] > 0)
    {
        [[PushManager defaultManager].info changeProjectID:projectid];

    }
        
    [self startIndi];
    [[PushManager defaultManager].info resetPushServiceLastDate];
    
    [[PushManager defaultManager] registerServiceAndUser:self clientUID:yourID clientName:yourName completionHandler:^(BOOL success) {
        if(success)
        {
            [CommonFunctions deleteAllDataInTable:@"PushItems"];
            
            [CommonHandler getInstance].gIsAuth = YES;
            [[CommonHandler getInstance] saveEnvironmentSetup:YES];
            
            [self endIndi];
            
            [self gotoMainTable];
            [[NSUserDefaults standardUserDefaults] setInteger:16 forKey:@"TXTVIEWSIZE"];
            [[Controller getInstance] setViewController:[Controller getInstance].naviMainController serviceVC:VC_MAIN_TABLE animated:NO];
        }
        else
        {
            [self endIndi];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"오류" message:@"유저 등록에 실패하였습니다." delegate:self cancelButtonTitle:@"확인" otherButtonTitles:nil];
            [alert show];
            return;
        }
    }];
}

- (void)gotoMainTable
{
    tfID.text = @"";
    tfName.text = @"";
}

#pragma mark -
#pragma mark Implement delegate
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// 델리게이트 구현
- (void)textFieldDidBeginEditing:(UITextField *)textField {
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
	return YES;
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

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [pickerList count];
}

-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *lable = (UILabel *)view;
    if(lable == nil)
    {
        lable = [[UILabel alloc] init];
        lable.font = [UIFont systemFontOfSize:16];
    }
    
    [lable setText:[pickerList objectAtIndex:row]];
    
    return lable;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 45;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    [[PushManager defaultManager].info changeHost:[pickerList objectAtIndex:row]];
}

@end
