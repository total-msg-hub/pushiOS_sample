//
//  IntroVC.m
//  koreanair
//
//  Created by 정종현 on 2014. 2. 24..
//  Copyright (c) 2014년 정종현. All rights reserved.
//

#import "IntroVC.h"
#import "Controller.h"
#import "PushReceiver.h"
#import "CommonFunctions.h"

@implementation IntroVC

@synthesize lblVersion;
@synthesize currentVersion;

- (void)viewDidLoad
{
    [[PushManager defaultManager] initilaizeWithDelegate:[[PushReceiver alloc] init]];
    commHandle = [CommonHandler getInstance];
    
    currentVersion = [[NSString alloc] initWithString:[[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString*)kCFBundleVersionKey]];
    lblVersion.text = [NSString stringWithFormat:@"Ver %@", currentVersion];

    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

//
// 화면이 나타나기 전에 호출된다.
//
- (void)viewWillAppear:(BOOL)animated {
    [self performSelector:@selector(initFoundationProperties) withObject:nil afterDelay:1.0];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	
}

-(void)initFoundationProperties
{
    @try
	{
		////////////////////////////////////////////////////////////////////////////////////////////////////////////
		// 프로퍼티(설정값 로딩/생성) 처리
		{
			// 경로 생성
			NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
			NSString *documentsDirectory = [paths objectAtIndex:0];
			NSString* myPath = [documentsDirectory stringByAppendingPathComponent:@"setup.plist"];
			
			// 파일로 읽어오기.
            NSMutableDictionary *properties = (NSMutableDictionary*)[CommonFunctions readPlist:myPath];
			
			// 파일이 없다면 만들자.
			if (properties == nil || [properties count] == 0)
			{
                
				// Making new environment setup file
				[commHandle saveEnvironmentSetup:(BOOL)YES];
                
			}
			else
			{
                int orgSaveDataCnt = [commHandle saveEnvironmentSetup:(BOOL)NO];
                
				// 사용자 아이디 저장 여부
				commHandle.gIsSaveUserName = [[properties objectForKey:@"IS_SAVE_USER_NAME"] intValue];
				if (commHandle.gIsSaveUserName)
				{
                    if([properties objectForKey:@"USER_NAME"] != nil)
                        commHandle.gUserName = [properties objectForKey:@"USER_NAME"];
				}
				else
				{
					commHandle.gUserName = @"";
				}
                
                commHandle.gIsAuth = [[properties objectForKey:@"IS_AUTH"] intValue];
                
                if(orgSaveDataCnt != [properties count])
                {
                    [commHandle saveEnvironmentSetup:(BOOL)YES];
                }
			}
		}
	}
	@catch (NSException *exception)
	{
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString* myPath = [documentsDirectory stringByAppendingPathComponent:@"setup.plist"];
        [[NSFileManager defaultManager] removeItemAtPath:myPath error:nil];
		return;
	}

    if(![CommonHandler getInstance].gIsAuth)
    {
        [[Controller getInstance] setViewController:[Controller getInstance].naviMainController serviceVC:VC_MAIN_LOGIN animated:NO];
    }
    else
    {
        [[Controller getInstance] setViewController:[Controller getInstance].naviMainController serviceVC:VC_MAIN_LOGIN animated:NO];
        [[Controller getInstance] setViewController:[Controller getInstance].naviMainController serviceVC:VC_MAIN_TABLE animated:NO];
    }
    
    [PushManager defaultManager].enabled = YES;
}

//인디게이터 시작
-(void)startActiveIndicator
{
}

//인디게이터 종료
-(void)stopActiveIndicator
{
}

@end
