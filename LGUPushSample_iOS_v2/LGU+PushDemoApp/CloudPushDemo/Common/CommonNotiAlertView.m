//
//  CommonNotiAlertView.m
//  UpaxIphone
//
//  Created by DONG YOUNG CHAE on 11. 1. 21..
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CommonNotiAlertView.h"
#import "CommonHandler.h"

@implementation CommonNotiAlertView

@synthesize centerBack, topBack, bottomBack;
@synthesize title;
@synthesize imgView;
@synthesize titleView;
@synthesize txtView;
@synthesize wvContent;
@synthesize aSpinner;

- (id)initWithFrame:(CGRect)frame delegate:(id)parentObj state:(int)pstate{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code.
        loadUrl = [CommonHandler getInstance].gUrl;
        NSArray* nibViews =  [[NSBundle mainBundle] loadNibNamed:@"CommonNotiAlertView" owner:self options:nil];
        CommonNotiAlertView* listView = (CommonNotiAlertView*)[ nibViews objectAtIndex: 0];
        CGRect safeFrame = [UIScreen mainScreen].applicationFrame;
        if (@available(iOS 11.0, *)) {
            safeFrame = CGRectMake(0, 0, safeFrame.size.width, safeFrame.size.height - [UIApplication sharedApplication].keyWindow.safeAreaInsets.bottom);
        }
        listView.frame = safeFrame;
        
        self.topBack.clipsToBounds = YES;
//        self.bottomBack.clipsToBounds = YES;

        [self addSubview:listView];
    }
    
    wvContent.scrollView.bounces = NO;
    [wvContent setDelegate:self];
    
    size = (int)[[NSUserDefaults standardUserDefaults] integerForKey:@"TXTVIEWSIZE"];
    [self.txtView setFont:[UIFont systemFontOfSize:size]];

    return self;
}

- (void)dealloc {
//    [super dealloc];
}

#pragma mark -
#pragma mark event handlers
-(IBAction)onOKButtonClicked:(id)sender {
    [CommonHandler getInstance].gUrl = @"";
	[self removeFromSuperview];
}

-(IBAction)onPlusButtonClicked:(id)sender
{
    size++;
    //[self.titleView setFont:[UIFont boldSystemFontOfSize:size+1]];
    [self.txtView setFont:[UIFont systemFontOfSize:size]];
    [[NSUserDefaults standardUserDefaults] setInteger:size forKey:@"TXTVIEWSIZE"];
    
}
-(IBAction)onMinusButtonClicked:(id)sender
{
    size--;
    //[self.titleView setFont:[UIFont boldSystemFontOfSize:size+1]];
    [self.txtView setFont:[UIFont systemFontOfSize:size]];
    [[NSUserDefaults standardUserDefaults] setInteger:size forKey:@"TXTVIEWSIZE"];
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	
	switch(alertView.tag)
	{
		case 1:
            [CommonHandler getInstance].gUrl = @"";
            [self removeFromSuperview];
			break;
    }
}

-(void)setDetailView:(NSDictionary *)detailDic
{
    [self startIndi];
    NSLog(@"dantexx detailDic %@", detailDic);
    
    NSString *title = [detailDic objectForKey:@"alert"];
    NSString *body = [detailDic objectForKey:@"body"];
    NSString *ext = [detailDic objectForKey:@"ext"];
    
    [self.titleView setHidden:NO];
    [self.txtView setHidden:NO];
    [self.imgView setHidden:YES];
    [self.wvContent setHidden:YES];
    
    [self.titleView setText:title];
    [self.txtView setText:body];
    
    if(ext && [ext length] > 0)
    {
        NSData *extData = [ext dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *extDic = [NSJSONSerialization JSONObjectWithData:extData options:0 error:nil];
        
        NSString *imgUrl = [extDic objectForKey:@"imgUrl"];
        NSString *htmlUrl = [extDic objectForKey:@"htmlUrl"];
        
        if(imgUrl && htmlUrl)
        {
            imgUrl = [[[imgUrl stringByReplacingOccurrencesOfString:@"\n\r" withString:@""] stringByReplacingOccurrencesOfString:@"\n" withString:@""] stringByReplacingOccurrencesOfString:@"\r" withString:@""];
            imgUrl = [imgUrl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
            
            [self.imgView setHidden:NO];
            [self.imgView setHidden:NO];

            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:imgUrl]];
            UIImage *img = [UIImage imageWithData:data];
                                
            if(img.size.width > self.imgView.frame.size.width)
            {
                self.imgView.frame = CGRectMake(self.imgView.frame.origin.x, self.imgView.frame.origin.y, self.imgView.frame.size.width, img.size.height / img.size.width * self.imgView.frame.size.width);
            }
            else
            {
                self.imgView.frame = CGRectMake((self.scrollView.frame.size.width - img.size.width) / 2, self.imgView.frame.origin.y, img.size.width, img.size.height);
            }
            
            [self.imgView setImage:img];
                                
            self.titleView.frame = CGRectMake(self.titleView.frame.origin.x, 8 + self.imgView.frame.size.height, self.titleView.contentSize.width, self.titleView.contentSize.height);
            self.txtView.frame = CGRectMake(self.txtView.frame.origin.x, 23 + self.imgView.frame.size.height + self.titleView.frame.size.height , self.txtView.contentSize.width, self.txtView.contentSize.height);
            
            htmlUrl = [[[htmlUrl stringByReplacingOccurrencesOfString:@"\n\r" withString:@""] stringByReplacingOccurrencesOfString:@"\n" withString:@""] stringByReplacingOccurrencesOfString:@"\r" withString:@""];
            [self.wvContent setHidden:NO];
            
            NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:htmlUrl]];
            [self.wvContent loadRequest:request];
            
            self.wvContent.frame = CGRectMake(self.wvContent.frame.origin.x, 38 + self.titleView.contentSize.height + self.txtView.contentSize.height + self.imgView.frame.size.height, self.wvContent.scrollView.contentSize.width, self.wvContent.scrollView.contentSize.height);
            
            self.scrollView.contentSize = CGSizeMake(self.scrollView.contentSize.width , 38 + self.imgView.frame.size.height + self.titleView.contentSize.height + self.txtView.contentSize.height + self.wvContent.frame.size.height);
        }
        else if(imgUrl)
        {
            imgUrl = [[[imgUrl stringByReplacingOccurrencesOfString:@"\n\r" withString:@""] stringByReplacingOccurrencesOfString:@"\n" withString:@""] stringByReplacingOccurrencesOfString:@"\r" withString:@""];
            imgUrl = [imgUrl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];

            [self.imgView setHidden:NO];
            
            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:imgUrl]];
            UIImage *img = [UIImage imageWithData:data];
                                
            if(img.size.width > self.imgView.frame.size.width)
            {
                self.imgView.frame = CGRectMake(self.imgView.frame.origin.x, self.imgView.frame.origin.y, self.imgView.frame.size.width, img.size.height / img.size.width * self.imgView.frame.size.width);
            }
            else
            {
                self.imgView.frame = CGRectMake((self.scrollView.frame.size.width - img.size.width) / 2, self.imgView.frame.origin.y, img.size.width, img.size.height);
            }
            
            [self.imgView setImage:img];
                                
            self.titleView.frame = CGRectMake(self.titleView.frame.origin.x, 8 + self.imgView.frame.size.height, self.titleView.contentSize.width, self.titleView.contentSize.height);
            self.txtView.frame = CGRectMake(self.txtView.frame.origin.x, 23 + self.imgView.frame.size.height + self.titleView.frame.size.height , self.txtView.contentSize.width, self.txtView.contentSize.height);
                                    
            self.scrollView.contentSize = CGSizeMake(self.scrollView.contentSize.width , 38 + self.imgView.frame.size.height + self.titleView.contentSize.height + self.txtView.contentSize.height);
            
            [self endIndi];
        }
        else if(htmlUrl)
        {
            [self.wvContent setHidden:NO];
            self.titleView.frame = CGRectMake(self.titleView.frame.origin.x, 8, self.titleView.contentSize.width, self.titleView.contentSize.height);
            self.txtView.frame = CGRectMake(self.txtView.frame.origin.x, 23 + self.titleView.frame.size.height , self.txtView.contentSize.width, self.txtView.contentSize.height);
            
            htmlUrl = [[[htmlUrl stringByReplacingOccurrencesOfString:@"\n\r" withString:@""] stringByReplacingOccurrencesOfString:@"\n" withString:@""] stringByReplacingOccurrencesOfString:@"\r" withString:@""];

            NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:htmlUrl]];
            [self.wvContent loadRequest:request];
            
            self.wvContent.frame = CGRectMake(self.wvContent.frame.origin.x, 38 + self.titleView.contentSize.height + self.txtView.contentSize.height  , self.wvContent.scrollView.contentSize.width, self.wvContent.scrollView.contentSize.height);
            
            self.scrollView.contentSize = CGSizeMake(self.scrollView.contentSize.width , 38 + self.titleView.contentSize.height + self.txtView.contentSize.height + self.wvContent.frame.size.height);
        }
        else
        {
            [self.titleView setHidden:NO];
            [self.txtView setHidden:NO];
            [self.imgView setHidden:YES];
            [self.wvContent setHidden:YES];
            
            self.titleView.frame = CGRectMake(self.titleView.frame.origin.x, 8, self.titleView.contentSize.width, self.titleView.contentSize.height);
            self.txtView.frame = CGRectMake(self.txtView.frame.origin.x, 23 + self.titleView.frame.size.height , self.txtView.contentSize.width, self.txtView.contentSize.height);
            
            [self endIndi];
        }
    }
    else
    {
        [self.titleView setHidden:NO];
        [self.txtView setHidden:NO];
        [self.imgView setHidden:YES];
        [self.wvContent setHidden:YES];
        
        self.titleView.frame = CGRectMake(self.titleView.frame.origin.x, 8, self.titleView.contentSize.width, self.titleView.contentSize.height);
        self.txtView.frame = CGRectMake(self.txtView.frame.origin.x, 23 + self.titleView.frame.size.height , self.txtView.contentSize.width, self.txtView.contentSize.height);
        
        [self endIndi];
    }
}

-(void)setTitleText:(NSString *)titletext
{
    //self.title.text = titletext;
}

-(void)setContentText:(NSString *)strtext
{
}

#pragma mark -
#pragma mark webview delegates
-(BOOL)webView:(UIWebView *)localWebView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSLog(@"dantexx shouldStartLoadWithRequest %@", request);

    if(UIWebViewNavigationTypeLinkClicked == navigationType)
    {
        [[UIApplication sharedApplication] openURL:[request URL]];
        return NO;
    }
    return YES;
}

-(void)webViewDidFinishLoad:(UIWebView *)localWebView {
    NSLog(@"dantexx webViewDidFinishLoad");
    //self.wvContent.frame = CGRectMake(self.wvContent.frame.origin.x, 8, self.wvContent.scrollView.contentSize.width, self.wvContent.scrollView.contentSize.height);
    self.wvContent.frame = CGRectMake(self.wvContent.frame.origin.x, self.wvContent.frame.origin.y , self.wvContent.scrollView.contentSize.width, self.wvContent.scrollView.contentSize.height);
    
    if([self.imgView isHidden])
    {
        self.scrollView.contentSize = CGSizeMake(self.scrollView.contentSize.width , 38 + self.titleView.contentSize.height + self.txtView.contentSize.height + self.wvContent.frame.size.height);
    }
    else
    {
        self.scrollView.contentSize = CGSizeMake(self.scrollView.contentSize.width , 38 + self.titleView.contentSize.height + self.txtView.contentSize.height + self.wvContent.frame.size.height + self.imgView.frame.size.height);
    }

    [self endIndi];
    return;
}

-(void)webView:(UIWebView *)localWebView didFailLoadWithError:(NSError *)error {
     NSLog(@"dantexx didFailLoadWithError %@", error);
    [self endIndi];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"오류" message:error.localizedDescription delegate:self cancelButtonTitle:@"확인" otherButtonTitles:nil];
    [alert show];
    return;
}

-(void)startIndi
{
    [self.aSpinner stopAnimating];
    UIActivityIndicatorView *tempSpinner = [[UIActivityIndicatorView alloc]
                                            initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.aSpinner = tempSpinner;
    CGRect frame = aSpinner.frame;
    frame.origin.x = self.frame.size.width / 2 - aSpinner.frame.size.width / 2;
    frame.origin.y = self.frame.size.height / 2 - aSpinner.frame.size.height / 2;
    aSpinner.frame = frame;
    
    [self addSubview:self.aSpinner];
    [self.aSpinner startAnimating];
}

-(void)endIndi
{
    [self.aSpinner stopAnimating];
}

@end
