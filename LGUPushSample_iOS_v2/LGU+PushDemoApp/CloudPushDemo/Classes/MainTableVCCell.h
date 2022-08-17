//
//  MainTableVCCell.h
//  UpaxIphone
//
//  Created by DONG YOUNG CHAE on 11. 1. 23..
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SelectableTableCellDelegate;

@interface MainTableVCCell : UITableViewCell {
    id <SelectableTableCellDelegate> selectableTableDelegate;
    
	UILabel *lblTitle;
    UILabel *lblBody;
	UILabel *lblTime;
    IBOutlet UIButton *imgCheck;
	UILabel *lblNew;
	UIImageView *imgNew;
    
    BOOL isSelected;
    int row;
}
@property (nonatomic, assign) id <SelectableTableCellDelegate> delegate;
@property (nonatomic, retain) IBOutlet UILabel *lblTitle;
@property (nonatomic, retain) IBOutlet UILabel *lblBody;
@property (nonatomic, retain) IBOutlet UILabel *lblTime;
@property (nonatomic, retain) IBOutlet UIButton *imgCheck;
@property (nonatomic, retain) IBOutlet UILabel *lblNew;
@property (nonatomic, retain) IBOutlet UIImageView *imgNew;

@property (readwrite) BOOL isSelected;
@property (readwrite) int row;

-(IBAction)onSelectButtonClicked:(id)sender;

@end

@protocol SelectableTableCellDelegate

-(void)didSelected:(int)row withValue:(BOOL)selected;

@end
