//
//  LoginVC.h
//  koreanair
//
//  Created by 정종현 on 2014. 2. 24..
//  Copyright (c) 2014년 정종현. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MPushLibrary/MPushLibrary.h>
#import "UCViewController.h"

@interface LoginVC : UCViewController<UITextFieldDelegate, UIAlertViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource>
{
    IBOutlet UITextField *tfID;
    IBOutlet UITextField *tfName;
    IBOutlet UITextField *tfProject;
    IBOutlet UIButton *btnLogin;
    IBOutlet UIView *conView;
    IBOutlet UIPickerView *picker;

    UIActivityIndicatorView *aSpinner;
    
    NSMutableArray *pickerList;
}

@property (nonatomic, retain) IBOutlet UITextField *tfID;
@property (nonatomic, retain) IBOutlet UITextField *tfName;
@property (nonatomic, retain) IBOutlet UITextField *tfProject;
@property (nonatomic, retain) IBOutlet UIButton *btnLogin;
@property (nonatomic, retain) IBOutlet UIView *conView;
@property (nonatomic, retain) IBOutlet UIPickerView *picker;
@property (nonatomic, retain) UIActivityIndicatorView *aSpinner;

- (IBAction)onOrderLogin;

- (void)gotoMainTable;
- (void)pushRegist;


@end
