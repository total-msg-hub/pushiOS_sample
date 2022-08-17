//
//  MainTableVCCell.m
//  UpaxIphone
//
//  Created by DONG YOUNG CHAE on 11. 1. 23..
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MainTableVCCell.h"


@implementation MainTableVCCell

@synthesize delegate;
@synthesize lblTitle;
@synthesize lblTime;
@synthesize imgCheck;
@synthesize row;
@synthesize imageView;
@synthesize lblNew;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code.
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state.
}

- (void)dealloc {
}

-(void)setIsSelected:(BOOL)value {
	isSelected = value;
	if (isSelected) {
		[imgCheck setImage:[UIImage imageNamed:@"check_on.png"] forState:UIControlStateNormal];
	} else {
		[imgCheck setImage:[UIImage imageNamed:@"check_off.png"] forState:UIControlStateNormal];
	}
	[delegate didSelected:row withValue:isSelected];
}

-(BOOL)isSelected {
	return isSelected;
}

-(IBAction)onSelectButtonClicked:(id)sender {
	self.isSelected = !isSelected;
}



@end
