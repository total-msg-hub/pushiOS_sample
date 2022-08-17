//
//  NotificationService.m
//  NotificationService
//
//  Created by 정종현 on 21/08/2020.
//  Copyright © 2020 정종현. All rights reserved.
//

#import "NotificationService.h"

@interface NotificationService ()

@property (nonatomic, strong) void (^contentHandler)(UNNotificationContent *contentToDeliver);
@property (nonatomic, strong) UNMutableNotificationContent *bestAttemptContent;

@end

@implementation NotificationService

- (void)didReceiveNotificationRequest:(UNNotificationRequest *)request withContentHandler:(void (^)(UNNotificationContent * _Nonnull))contentHandler {
    self.contentHandler = contentHandler;
    self.bestAttemptContent = [request.content mutableCopy];
    
    NSUserDefaults *userDefault = [[NSUserDefaults alloc] initWithSuiteName:@"group.com.uracle.push.demo.lgu"];
    NSMutableArray *array = [NSMutableArray array];
    if([userDefault arrayForKey:@"PUSH_MESSAGE_DATA_FOR_DB"])
    {
        array = [[NSMutableArray alloc] initWithArray:[userDefault arrayForKey:@"PUSH_MESSAGE_DATA_FOR_DB"]];
    }
    [array addObject:self.bestAttemptContent.userInfo];
    [userDefault setObject:array forKey:@"PUSH_MESSAGE_DATA_FOR_DB"];
        
    NSDictionary *mpsDic = [self.bestAttemptContent.userInfo objectForKey:@"mps"];
    NSString *extStr = [mpsDic objectForKey:@"ext"];
    NSData *extData = [extStr dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *extDic = [NSJSONSerialization JSONObjectWithData:extData options:0 error:nil];
    NSString *pushImgStr = [extDic objectForKey:@"pushImg"];
    if(pushImgStr)
    {
        NSURL *URL = [NSURL URLWithString:pushImgStr];
        NSURLSession *LPSession = [NSURLSession sessionWithConfiguration:
                                   [NSURLSessionConfiguration defaultSessionConfiguration]];
        [[LPSession downloadTaskWithURL:URL completionHandler: ^(NSURL *temporaryLocation, NSURLResponse *response, NSError *error) {
            if (error) {
                NSLog(@"Leanplum: Error with downloading rich push: %@",
                      [error localizedDescription]);
                self.contentHandler(self.bestAttemptContent);
                return;
            }
            
            NSString *fileType = [self determineType: [response MIMEType]];
            NSString *fileName = [[temporaryLocation.path lastPathComponent] stringByAppendingString:fileType];
            NSString *temporaryDirectory = [NSTemporaryDirectory() stringByAppendingPathComponent:fileName];
            [[NSFileManager defaultManager] moveItemAtPath:temporaryLocation.path toPath:temporaryDirectory error:&error];
            
            NSError *attachmentError = nil;
            UNNotificationAttachment *attachment =
            [UNNotificationAttachment attachmentWithIdentifier:@""
                                                           URL:[NSURL fileURLWithPath:temporaryDirectory]
                                                       options:nil
                                                         error:&attachmentError];
            if (attachmentError != NULL) {
                NSLog(@"Leanplum: Error with the rich push attachment: %@",
                      [attachmentError localizedDescription]);
                self.contentHandler(self.bestAttemptContent);
                return;
            }
            self.bestAttemptContent.attachments = @[attachment];
            self.contentHandler(self.bestAttemptContent);
            [[NSFileManager defaultManager] removeItemAtPath:temporaryDirectory error:&error];
        }] resume];
    }
    else
    {
        self.contentHandler(self.bestAttemptContent);
    }
}

- (NSString*)determineType:(NSString *) fileType {
    // Determines the file type of the attachment to append to NSURL.
    if ([fileType isEqualToString:@"image/jpeg"]){
        return @".jpg";
    }
    if ([fileType isEqualToString:@"image/gif"]) {
        return @".gif";
    }
    if ([fileType isEqualToString:@"image/png"]) {
        return @".png";
    } else {
        return @".tmp";
    }
}

- (void)serviceExtensionTimeWillExpire {
    // Called just before the extension will be terminated by the system.
    // Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used.
    self.contentHandler(self.bestAttemptContent);
}

@end
