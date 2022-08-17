/*
 * CommonHandler.h
 * 
 * author 류경민(Brain Ryu)
 * version v 1.0.0
 * since : 2010.06.20
 * Date : 2010.07.04
 * email : ryeuf@nate.com
 * Company: URACLE
 * 
 * Copyright (c) URACLE, Inc. 2F Sunglim B/D. 201
 * Yeongdeungpo-Dong, Yeongdeungpo-gu, Seoul 150-037, All Rights Reserved.
 */


#import <Foundation/Foundation.h>

#define ISLog YES

@interface CommonHandler : NSObject { 

    // Service Version
	NSString *gServiceVersion;
    
	// Lastest Service Version (최신버전)
	NSString *gLastestServiceVersion;
	
	// Force Down Service Version (강제 다운로드 버전)
	NSString *gForceDownServiceVersion;
	
	// Application download url (어플리케이션 다운로드 URL)
	NSString *gAppDownUrl;
    
    // User Name
	NSString *gUserName;
	
	// User Phone
	NSString *gUserPhone;
    
    // 아이디 저장 여부
	BOOL gIsSaveUserName;
    
    BOOL gIsAuth;
    
    NSDictionary *launchInfo;
    
    NSString *gUrl;
    
    int badgeNum;
}

@property(nonatomic, retain) NSString *gServiceVersion;
@property(nonatomic, retain) NSString *gLastestServiceVersion;
@property(nonatomic, retain) NSString *gForceDownServiceVersion;
@property(nonatomic, retain) NSString *gAppDownUrl;
@property(nonatomic, retain) NSString *gUserName;
@property(nonatomic, retain) NSString *gUserPhone;

@property(nonatomic, assign) BOOL gIsSaveUserName;		// 회원 아이디 저장 여부
@property(nonatomic, assign) BOOL gIsAuth;

@property (nonatomic, retain) NSDictionary *launchInfo;

@property(nonatomic, retain) NSString *gUrl;

@property(nonatomic, assign) int gBadgeNum;

-(id)init;
-(void)dealloc;
+(CommonHandler *) getInstance;

// 환경 설정 저장
-(int)saveEnvironmentSetup:(BOOL)isSave;

@end
