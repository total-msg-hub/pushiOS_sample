//
//  Controller.m
//  PUSHSample
//
//  Created by 정종현 on 2016. 8. 16..
//  Copyright © 2016년 정종현. All rights reserved.
//

#import "Controller.h"

#import "IntroVC.h"
#import "LoginVC.h"
#import "MainTableVC.h"

static Controller *m_Instance = nil;

@implementation Controller

@synthesize naviMainController;
@synthesize currentScreenTag;
@synthesize currentDelegate;
@synthesize naviCurrentController;

// Initialize
- (id)init
{
	return self;
}

// SingleTon
+ (Controller *) getInstance
{
	@synchronized(self) {
		if (m_Instance == nil)
		{
			m_Instance = [[Controller alloc] init];
		}
	}
	return m_Instance;
}

//
// Set AppDelegate
//
- (void)setAppDelegate:(AppDelegate *)AppDelegate
{
    appDelegate = AppDelegate;
}

//
// Get AppDelegate
//
- (AppDelegate *)getAppDelegate
{
    return appDelegate;
}


//
// Change viewController within NavigationController
//
//	parentObj : 호출 객체 레퍼런스
//	serviceVC : 서비스 정의
//	animated : 애니메이션 여부
//
- (void)setViewController:(id)parentObj serviceVC:(NSInteger)serviceVcTag animated:(BOOL)isAni 
{
	currentScreenTag = serviceVcTag;
    
	// Check whether the view controller aleady created
	if ([self findingVCInNavigationVC:parentObj vcTag:serviceVcTag animated:isAni] == NO)
	{
		switch (serviceVcTag)
		{
			case VC_MAIN_INTRO:	// 인트로
			{
				// 메인 네비게이션 컨트롤러 최초 생성 
				IntroVC *vc = [[IntroVC alloc] initWithNibName:@"IntroVC" bundle:nil];
                currentDelegate = vc;
				naviMainController = [[UINavigationController alloc] initWithRootViewController:vc];
				[naviMainController setNavigationBarHidden:YES];
				
                if([[[[UIApplication sharedApplication] delegate] window] respondsToSelector:@selector(setRootViewController:)])
                {
                    [[[[UIApplication sharedApplication] delegate] window] setRootViewController:naviMainController];
                }
                else
                {
                    [[[[UIApplication sharedApplication] delegate] window] addSubview:naviMainController.view];
                }
                
				[[[[UIApplication sharedApplication] delegate] window] makeKeyAndVisible];
			}
				break;

            case VC_MAIN_LOGIN:	// 로그인
            {
                LoginVC *vc = [[LoginVC alloc] initWithNibName:@"LoginVC" bundle:nil];
                vc.view.tag = VC_MAIN_LOGIN;
                currentDelegate = vc;
                [parentObj pushViewController:vc animated:isAni];
            }
                break;
                
            case VC_MAIN_TABLE:	// 로그인
            {
                MainTableVC *vc = [[MainTableVC alloc] initWithNibName:@"MainTableVC" bundle:nil];
                vc.view.tag = VC_MAIN_TABLE;
                currentDelegate = vc;
                [parentObj pushViewController:vc animated:isAni];
            }
                break;

			default:
				break;
		}
        if([[[UIDevice currentDevice]systemVersion] floatValue] < 5.0) {
            if ([parentObj isKindOfClass:[UINavigationController class]]) 
                [parentObj viewWillAppear:NO];
        }
	}
}


- (BOOL)findingVCInNavigationVC:(UINavigationController *)naviVC vcTag:(int)tag animated:(BOOL)isAni
{
	BOOL isFound = NO;
	@synchronized(self)
	{
		
		switch(tag)
		{
			case VC_MAIN_INTRO:
				return isFound;
				break;
		}
		
		int vcCount = [[naviVC viewControllers] count];
		for (int i = 0; i < vcCount; i++)
		{
			if ([[[naviVC viewControllers] objectAtIndex:i] isKindOfClass:[IntroVC class]]) {
				continue;
			}
		}
		
		for (int i = 0; i < vcCount; i++)
		{
            if ([[[naviVC viewControllers] objectAtIndex:i] isKindOfClass:[IntroVC class]]) {
            	continue;
            }
			if ([[[naviVC viewControllers] objectAtIndex:i] view].tag == tag)
			{
                NSMutableArray *copyArray = [[NSMutableArray alloc] initWithArray:[naviVC viewControllers]];
                currentDelegate = [[naviVC viewControllers] objectAtIndex:i];
                [[[naviVC viewControllers] objectAtIndex:vcCount-1] viewWillDisappear:NO];
                [copyArray removeObjectAtIndex:i];
                [copyArray addObject:(id)[[naviVC viewControllers] objectAtIndex:i]];                         
                [naviVC setViewControllers:copyArray animated:isAni];
                int vcCount = [[naviVC viewControllers] count];
                for (int i = 0; i < vcCount; i++)
                {
                    if ([[[naviVC viewControllers] objectAtIndex:i] isKindOfClass:[IntroVC class]]) {
                        continue;
                    }
                    
                }
                
				isFound = YES;
				break;
			}
		}
	}
    naviCurrentController =(UINavigationController *)naviVC;
	return isFound;
}

//
// 현재 화면 레퍼런스를 얻는다.
//
- (long)getCurrentScreenTag
{
	return currentScreenTag;
}

- (void)setCurrentScreenTag:(long)currentTag
{
	currentScreenTag = currentTag;
}

-(void)setCurrentDelegate:(id)currentdel
{
    currentDelegate = currentdel;
}

//
//	Back to the previous viewcontroller
//
- (void)setPreviousViewController:(BOOL)isAni
{
	//[naviMainController popViewControllerAnimated:isAni];
	NSArray *arr = [naviCurrentController viewControllers];
//    //    	for (int i =0; i<[arr count]; i++) {
//    //    		if ([[[naviCurrentController viewControllers] objectAtIndex:i] isKindOfClass:[MainIntroVC class]]) {
//    //    			continue;
//    //    		}
//    //    		UPAX_LOG(@"---------- B ViewController[arr count][%d]--currentScreenTag[%x]--------", [arr count] ,currentScreenTag);
//    //    		UPAX_LOG(@"->TAG[%d][%x]",i,[[[naviCurrentController viewControllers] objectAtIndex:i] view].tag);
//    //    	}
    
    int preControlleridx = [arr count]-2;
    
    
    NSMutableArray *copyArray = [[NSMutableArray alloc] initWithArray:[naviMainController viewControllers]];
    [[[naviCurrentController viewControllers] objectAtIndex:[arr count]-1] viewWillDisappear:NO];
    [copyArray removeObjectAtIndex:preControlleridx];
    [copyArray removeObjectAtIndex:[copyArray count]-1];
    [copyArray insertObject:(id)[[naviCurrentController viewControllers] objectAtIndex:preControlleridx+1] atIndex:(NSUInteger)1];
    [copyArray addObject:(id)[[naviCurrentController viewControllers] objectAtIndex:preControlleridx]];   
    [naviCurrentController setViewControllers:copyArray animated:isAni];
    
    currentDelegate = [[naviCurrentController viewControllers] objectAtIndex:[[naviCurrentController viewControllers] count]-1];
	currentScreenTag = [[[naviCurrentController viewControllers] objectAtIndex:[[naviCurrentController viewControllers] count]-1] view].tag;
    
}

- (void)dealloc
{
}

-(void)onShowTabViewNotification:(NSNotification *)notification {
	NSString *flag = (NSString *)[notification object];
	if ([flag isEqualToString:@"HIDDEN"]) {
		[[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:NO];
		[naviMainController setWantsFullScreenLayout:YES];
		[naviMainController.view setNeedsLayout];
		[naviMainController.topViewController setWantsFullScreenLayout:YES];
		[naviMainController.topViewController.view setNeedsLayout];
	} else {
		[[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:NO];
		[naviMainController setWantsFullScreenLayout:NO];
		[naviMainController.view setNeedsLayout];
		[naviMainController.topViewController setWantsFullScreenLayout:NO];
		[naviMainController.topViewController.view setNeedsLayout];
	}
}

@end
