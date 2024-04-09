//
//  PushNotificationServiceExtension.h
//  MPushLibrary.Framework
//
//  Created by dantexx on 2022/03/23.
//  Copyright © 2022 UracleLab. All rights reserved.
//

#import <UserNotifications/UserNotifications.h>

API_AVAILABLE(ios(10.0))
@interface PushNotificationServiceExtension : UNNotificationServiceExtension

// https 이미지 url에서 attachment를 취득
- (void)requestAttachmentImage:(NSString *)strUrl withAttachmentHandler:(void (^)(NSError *error, UNNotificationAttachment* attachment))attachmentHandler;
- (BOOL)isMPush:(NSDictionary *)userInfo;
- (NSString *)getImageURLFromMPush:(NSDictionary *)userInfo;

@property (nonatomic, strong) void (^contentHandler)(UNNotificationContent * _Nonnull contentToDeliver );
@property (nonatomic, strong) UNMutableNotificationContent *bestAttemptContent;

@end


