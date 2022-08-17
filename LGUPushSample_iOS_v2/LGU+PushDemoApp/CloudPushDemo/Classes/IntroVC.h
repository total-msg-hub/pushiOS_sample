//
//  IntroVC.h
//  koreanair
//
//  Created by 정종현 on 2014. 2. 24..
//  Copyright (c) 2014년 정종현. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonHandler.h"
#import "UCViewController.h"

@interface IntroVC : UCViewController
{
    CommonHandler *commHandle;
    
    UILabel *lblVersion;
    
    NSString *currentVersion;
}

@property (nonatomic, retain) IBOutlet UILabel *lblVersion;
@property (nonatomic, retain) NSString *currentVersion;

-(void)initFoundationProperties;
-(void)startActiveIndicator;
-(void)stopActiveIndicator;

@end
