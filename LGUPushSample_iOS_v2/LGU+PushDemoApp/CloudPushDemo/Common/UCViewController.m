//
//  UCViewController.m
//  UpaxIphone
//
//  Created by DONG YOUNG CHAE on 11. 3. 22..
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "UCViewController.h"


@implementation UCViewController

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.modalPresentationStyle = UIModalPresentationFullScreen;
    }
    return self;
}

-(void)viewWillLayoutSubviews
{
    if(self.view.frame.size.width == [[UIScreen mainScreen] bounds].size.width && self.view.frame.size.height == [[UIScreen mainScreen] bounds].size.height)
    {
        CGRect safeFrame = [[UIScreen mainScreen] applicationFrame];
        if (@available(iOS 11.0, *)) {
            safeFrame = [UIApplication sharedApplication].keyWindow.safeAreaLayoutGuide.layoutFrame;
            self.view.frame = safeFrame;
        } else {
            self.view.frame = safeFrame;
        }
    }
}

-(CGRect)getSafeFrame
{
    CGRect safeFrame = [[UIScreen mainScreen] applicationFrame];

    if (@available(iOS 11.0, *)) {
        safeFrame = [UIApplication sharedApplication].keyWindow.safeAreaLayoutGuide.layoutFrame;
    }
    
    return safeFrame;
}

-(void)dealloc {
}

-(void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

@end
