/*
 * CommonHandler.m
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
 *
 * Comment : 
 *	- 싱글톤 패턴의 클래스 이다(객체는 프로그램 실행 도중 한번만 생성된후 프로그램 종료시까지 유지된다.)
 *	- 프로그램 실행 전역적인 데이터 이용을 위한 클래스이다. 
 *  - 프로그램 시작후 객체가 한번만 생성되며 프로그램 종료시까지 유지된다.
 */

#import "CommonHandler.h"
#import "CommonFunctions.h"

static CommonHandler *m_Instance = nil;

@implementation CommonHandler

@synthesize gServiceVersion;
@synthesize gLastestServiceVersion;
@synthesize gForceDownServiceVersion;
@synthesize gAppDownUrl;
@synthesize gUserName;
@synthesize gUserPhone;
@synthesize gIsSaveUserName;
@synthesize gIsAuth;
@synthesize launchInfo;
@synthesize gUrl;
@synthesize gBadgeNum;

/* 
 Initialize
 */
- (id)init
{
	self = [super init];
    
    // Current Service Version (현재버전)
	gServiceVersion = [[NSString alloc] initWithString:[[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString*)kCFBundleVersionKey]];
	
	// Service
	gLastestServiceVersion = [[NSString alloc] initWithString:[[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString*)kCFBundleVersionKey]];
	
	// Force Down Service Version
	gForceDownServiceVersion = [[NSString alloc] initWithString:@""];
	
	// Application download url (어플리케이션 다운로드 URL)
	gAppDownUrl = [[NSString alloc] initWithString:@""];

    // User Name
	gUserName = [[NSString alloc] initWithString:@""];
	
	// User Phone
	gUserPhone = [[NSString alloc] initWithString:@""];
    
    // 회원 아이디 저장 여부
	gIsSaveUserName = YES;
    
    gIsAuth = NO;
    
    launchInfo = nil;
    
    gUrl = [[NSString alloc] initWithString:@""];
    
    gBadgeNum = 0;
    
	return self;
}

/*
 SingleTon
 */
+ (CommonHandler *) getInstance
{
	@synchronized(self) {
		if (m_Instance == nil)
		{
			m_Instance = [[CommonHandler alloc] init];
		}
	}
	return m_Instance;
}

- (void)dealloc
{
}

-(int)saveEnvironmentSetup:(BOOL)isSave
{
	// 경로 생성
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString* myPath = [documentsDirectory stringByAppendingPathComponent:@"setup.plist"];
		
	// 아이디 저장 여부
	NSNumber *isSaveName = [NSNumber numberWithInt:gIsSaveUserName];
	NSString *strSaveUserName = @"";
    NSNumber *isAuth = [NSNumber numberWithInt:gIsAuth];
    
    strSaveUserName = gUserName;
    
    NSMutableDictionary *properties = [NSDictionary dictionaryWithObjectsAndKeys:
								       isSaveName,@"IS_SAVE_USER_NAME",
									   strSaveUserName,@"USER_NAME",
                                       isAuth,@"IS_AUTH",
									   nil];
	
    if(isSave)
    {
        [CommonFunctions writePlist:properties toFile:myPath];
    }
    return [properties count];
}

@end
