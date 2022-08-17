//
//  PushReceiver.m
//
//

#import "PushReceiver.h"
#import "CommonFunctions.h"

typedef void(^PushReceiverExtLoadHandler)(BOOL success, NSString *richData, NSError *error);

@interface PushReceiver () <PushManagerDelegate>

@end

@implementation PushReceiver

- (void)dealloc {
    NSLog( @"PushReceiver - dealloc" );
}

- (id)init {
    self = [super init];
    if (self) {
        NSLog( @"PushReceiver - init" );

        [PushManager defaultManager].enabled = NO;
        //[[PushManager defaultManager].info changeMode:@"DEV"];

        // 직접 호스트 변경
//        [[PushManager defaultManager].info changeHost:@"http://lab.morpheus.kr:8085/upmc/"];
    }
    return self;
}

- (void)manager:(PushManager *)manager didLoadPushInfo:(PushManagerInfo *)pushInfo {
    NSLog( @"PushReceiver - manager didLoadPushInfo: %@", pushInfo );
}

- (void)managerDidRegisterForRemoteNotifications:(PushManager *)manager userInfo:(NSDictionary *)userInfo {
    NSLog( @"PushReceiver - managerDidRegisterForRemoteNotifications userInfo: %@", userInfo );
}

- (void)manager:(PushManager *)manager didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog( @"PushReceiver - didFailToRegisterForRemoteNotificationsWithError error: %@", error );
}

- (void)manager:(PushManager *)manager didReceiveUserNotification:(NSDictionary *)userInfo status:(NSString *)status messageUID:(NSString *)messageUID {
    NSLog( @"PushReceiver - didReceiveUserNotification: %@ status: %@ messageUID:%@", userInfo, status, messageUID );
    
    NSString *extHTML = [[userInfo objectForKey:@"mps"] objectForKey:@"ext"];

    NSLog( @"PushReceiver - extHTML :%@", extHTML );
    
    if ( extHTML != nil && ([extHTML hasSuffix:@"_msp.html"] || [extHTML hasSuffix:@"_ext.html"]) ) {
        [self loadExtData:extHTML handler:^(BOOL success, NSString *richData, NSError *error) {
            NSLog( @"PushReceiver - richData : %@", richData );
        
            NSMutableDictionary *notification = [NSMutableDictionary dictionaryWithDictionary:userInfo];
            NSMutableDictionary *mspData = [NSMutableDictionary dictionaryWithDictionary:[notification objectForKey:@"mps"]];
            [mspData setObject:richData forKey:@"ext"];
            [notification setObject:mspData forKey:@"mps"];
            
            //NSLog( @"notification: %@", notification );
            
            [self onReceiveNotification:[NSDictionary dictionaryWithDictionary:notification] status:status messageUID:messageUID];
        }];
    }
    else {
        //NSLog( @"notification: %@", userInfo );

        [self onReceiveNotification:userInfo status:status messageUID:messageUID];
    }
}

- (void)loadExtData:(NSString *)extHTML handler:(PushReceiverExtLoadHandler)handler {

    NSURL *url = [NSURL URLWithString:extHTML];
    
    if (!url) {
        handler(NO, extHTML, nil);
        return;
    }

    [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:extHTML]]
                            queue:[NSOperationQueue mainQueue]
                            completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        if ( connectionError != nil ) {
            dispatch_async(dispatch_get_main_queue(), ^{
                handler(NO, extHTML, connectionError);
            });
            return;
        }
        
        NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse *)response;
            
        if ( httpResponse.statusCode != 200 ) {
            dispatch_async(dispatch_get_main_queue(), ^{
                handler(NO, extHTML, nil);
            });
            return;
        }
        
        NSString *result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSString *richData = [NSString stringWithString:result];
        
        richData = [richData stringByRemovingPercentEncoding];
        
        #if ! __has_feature(objc_arc)
        [result release];
        #endif
        
        dispatch_async(dispatch_get_main_queue(), ^{
            handler(YES, richData, nil);
        });
    }];
}

- (void)onReceiveNotification:(NSDictionary *)payload status:(NSString *)status messageUID:(NSString *)messageUID {
    NSString *pushType = @"APNS";

    NSDictionary *apsInfo = [payload objectForKey:@"aps"];
    NSString *message = [apsInfo objectForKey:@"alert"];

    NSDictionary *notificationInfo = @{@"status":status, @"payload":payload, @"type":pushType, @"messageUID": messageUID};

    NSLog( @"PushReceiver - notificationInfo: %@", notificationInfo );

    [[PushManager defaultManager] read:nil notification:payload badgeOption:PushManagerBadgeOptionKeep completionHandler:^(BOOL success){}];
    
    [CommonFunctions updateItemsDB:@"PushItems" array:payload new:@"Y"];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NOTIFICATIONREFRESH" object:@""];
}


@end
