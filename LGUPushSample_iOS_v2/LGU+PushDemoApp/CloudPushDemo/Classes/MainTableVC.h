//
//  MainTableVC.h
//  koreanair
//
//  Created by 정종현 on 2014. 2. 24..
//  Copyright (c) 2014년 정종현. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonHandler.h"
#import "MainTableVCCell.h"
#import "UCViewController.h"
#import <MPushLibrary/MPushLibrary.h>

@interface MainTableVC : UCViewController <UITableViewDataSource, UITableViewDelegate, SelectableTableCellDelegate>
{
    IBOutlet UIView *topView;
    IBOutlet UIView *bottomView;
    IBOutlet UITableView *tableview;
    IBOutlet UIButton *btnPush;
    IBOutlet UIButton *btnAllSelect;
    
    BOOL isEdit;
    BOOL isPush;
    BOOL isSelect;
    
    NSMutableArray *array;
    NSMutableArray *tableList;
    
    UIActivityIndicatorView *aSpinner;
    
}

@property (nonatomic, retain) IBOutlet UIView *topView;
@property (nonatomic, retain) IBOutlet UIView *bottomView;
@property (nonatomic, retain) IBOutlet UITableView *tableview;
@property (nonatomic, retain) IBOutlet UIButton *btnPush;
@property (nonatomic, retain) IBOutlet UIButton *btnAllSelect;
@property (readwrite) BOOL isSelect;
@property (nonatomic, retain) NSMutableArray *array;
@property (nonatomic, retain) NSMutableArray *tableList;

@property (nonatomic, retain) UIActivityIndicatorView *aSpinner;

@property (nonatomic, retain) IBOutlet UILabel *upmclable;
- (IBAction)onUPMCClick;

- (IBAction)onPreviewClick;
- (IBAction)onEditClick;
- (IBAction)onPushClick;
- (IBAction)onAllSelectClick;

- (IBAction)onDeleteClick;
- (IBAction)onCancelClick;

- (void)loadList;

- (void)buttonVisible:(BOOL)flag;

@end
