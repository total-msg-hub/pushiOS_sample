//
//  Controller.h
//  PUSHSample
//
//  Created by 정종현 on 2016. 8. 16..
//  Copyright © 2016년 정종현. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "AppDelegate.h"

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// 화면 구분 정의

// 메인(Main) : 0x0100
#define VC_MAIN_INTRO				0x0100		// 인트로
#define VC_MAIN_LOGIN				0x0101		// 로그인
#define VC_MAIN_TABLE				0x0102		// 로그인

@interface Controller : NSObject {
    AppDelegate * appDelegate;
	// 메인 네비게이션 컨트롤러
	UINavigationController *naviMainController;
	UINavigationController *naviCurrentController;
	// 현재 화면 레퍼런스
	long currentScreenTag;
    
    id currentDelegate;
}

@property (nonatomic, retain) UINavigationController *naviMainController;
@property (nonatomic, retain) UINavigationController *naviCurrentController;
@property (readwrite) long currentScreenTag;
@property (nonatomic, retain) id currentDelegate;

- (id)init;
- (void)dealloc;
+ (Controller *) getInstance;

- (AppDelegate *)getAppDelegate;
- (void)setAppDelegate:(AppDelegate *)AppDelegate;

- (void)setPreviousViewController:(BOOL)isAni;
- (void)setViewController:(id)parentObj serviceVC:(NSInteger)serviceVcTag animated:(BOOL)isAni;	// 이전 화면 전환
- (BOOL)findingVCInNavigationVC:(UINavigationController *)naviVC vcTag:(int)tag animated:(BOOL)isAni;
- (long)getCurrentScreenTag;
- (void)setCurrentScreenTag:(long)currentTag;
- (void)setCurrentDelegate:(id)currentdel;
@end
