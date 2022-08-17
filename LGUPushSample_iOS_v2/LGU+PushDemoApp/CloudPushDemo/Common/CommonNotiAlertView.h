//
//  CommonNotiAlertView.h
//  UpaxIphone
//
//  Created by DONG YOUNG CHAE on 11. 1. 21..
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommonNotiAlertView : UIView <UIWebViewDelegate,UIAlertViewDelegate> {
    NSString *loadUrl;
    
    UIView *topBack;
    UIView *centerBack;
    UIView *bottomBack;
    
    UILabel *title;
    UIScrollView *scrollView;
    UIImageView *imgView;
    UIWebView *wvContent;
    UITextView *titleView;
    UITextView *txtView;
    
    UIActivityIndicatorView *aSpinner;
    
    NSDictionary *backup;
    
    int size;
}
@property (nonatomic, retain) IBOutlet UIView *topBack;
@property (nonatomic, retain) IBOutlet UIView *centerBack;
@property (nonatomic, retain) IBOutlet UIView *bottomBack;

@property (nonatomic, retain) IBOutlet UILabel *title;
@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;
@property (nonatomic, retain) IBOutlet UIImageView *imgView;
@property (nonatomic, retain) IBOutlet UIWebView *wvContent;
@property (nonatomic, retain) IBOutlet UITextView *titleView;
@property (nonatomic, retain) IBOutlet UITextView *txtView;

@property (nonatomic, retain) UIActivityIndicatorView *aSpinner;

-(IBAction)onOKButtonClicked:(id)sender;

-(IBAction)onPlusButtonClicked:(id)sender;
-(IBAction)onMinusButtonClicked:(id)sender;


-(id)initWithFrame:(CGRect)frame delegate:(id)parentObj state:(int)pstate;

-(void)filecheck;
-(void)saveFile:(NSData *)file;
-(void)setTitleText:(NSString *)titletext;
-(void)setContentText:(NSString *)strtext;
-(void)setDetailView:(NSDictionary *)detailDic;
@end
