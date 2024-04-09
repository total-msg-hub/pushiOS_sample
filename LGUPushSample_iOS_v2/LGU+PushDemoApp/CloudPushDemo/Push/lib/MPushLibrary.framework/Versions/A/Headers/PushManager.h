//
//  PushManager.h
//

#import <UIKit/UIKit.h>
#import <UserNotifications/UserNotifications.h>

@interface NSString (PushManager)
- (NSComparisonResult)versionCompare:(NSString *)version;
@end

typedef NS_ENUM(NSInteger, PushManagerBadgeOption){
    PushManagerBadgeOptionKeep = -1,
    PushManagerBadgeOptionReset = 0,
    PushManagerBadgeOptionUpdate,
    PushManagerBadgeOptionForce
};

#define NSNotificationNameDidRegisterForRemoteNotifications                     @"NSNotificationNameDidRegisterForRemoteNotifications"
#define NSNotificationNameDidFailToRegisterForRemoteNotificationsWithError      @"NSNotificationNameDidFailToRegisterForRemoteNotificationsWithError"
#define NSNotificationNameDidReceiveRemoteNotification                          @"NSNotificationNameDidReceiveRemoteNotification"
#define KEY_CUSTOM_RECEIVER_SERVER_URL                                          @"KEY_CUSTOM_RECEIVER_SERVER_URL"
#define PushNotice(frm, ...) { NSLog(frm, ##__VA_ARGS__); }
#define PushDebug(frm, ...)  \
if ( [[[PushManager defaultManager] info] useLog] ) {\
    NSLog(frm, ##__VA_ARGS__); \
}

@class PushManager, PushManagerInfo, PushManagerConfig, PushNotificationCenter;

@protocol PushManagerApplicationDelegate <NSObject>

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions NS_AVAILABLE_IOS(3_0);
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken NS_AVAILABLE_IOS(3_0);
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error NS_AVAILABLE_IOS(3_0);
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification NS_AVAILABLE_IOS(4_0);
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo NS_AVAILABLE_IOS(3_0);

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult result))completionHandler NS_AVAILABLE_IOS(7_0);
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings NS_AVAILABLE_IOS(8_0);

- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler API_AVAILABLE(macos(10.14), ios(10.0), watchos(3.0), tvos(10.0));
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^)(void))completionHandler API_AVAILABLE(macos(10.14), ios(10.0), watchos(3.0));


@end

typedef void (^PushManagerInterfaceCompletionHandler) (BOOL success);
typedef void (^PushManagerInterfaceCompletionHandlerWithBody) (BOOL success, NSDictionary *body);
typedef void (^PushManagerInterfaceCompletionHandlerWithError) (BOOL success, NSError *error);

@protocol PushManagerDelegate <NSObject>

- (void)manager:(PushManager *)manager didReceiveUserNotification:(NSDictionary *)userInfo status:(NSString *)status messageUID:(NSString *)messageUID;

@optional

// "(manager:didReceiveRemoteNotification:status:) is deprecated. Use (manager:didReceiveUserNotification:status:messageUID:) instead"

- (void)manager:(PushManager *)manager didLoadPushInfo:(PushManagerInfo *)pushInfo;
- (void)manager:(PushManager *)manager didReceiveRemoteNotification:(NSDictionary *)userInfo status:(NSString *)status;

- (void)managerDidRegisterForRemoteNotifications:(PushManager *)manager userInfo:(NSDictionary *)userInfo;
- (void)manager:(PushManager *)manager didFailToRegisterForRemoteNotificationsWithError:(NSError *)error;

- (void)manager:(PushManager *)manager userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler;

@end

@interface PushManager : NSObject <PushManagerApplicationDelegate>

@property (nonatomic, readwrite) BOOL enabled;
@property (nonatomic, readonly, getter=isRegisteredService) BOOL registeredService;
@property (nonatomic, readonly) id<PushManagerDelegate> delegate;
@property (nonatomic, readonly) PushManagerInfo *info;
@property (nonatomic, readonly) PushNotificationCenter *notificationCenter;
@property (nonatomic, readonly) NSString *customHost;
@property (nonatomic, readonly) NSMutableArray *purchaseArray;

+ (PushManager *)defaultManager;

+ (void)setBundlePath:(NSString *)path;
+ (NSString *)getBundlePath;

- (void)initialize;
- (void)initilaizeWithDelegate:(id<PushManagerDelegate>)delegate;

- (void)setUserNotificationDelegate;

// - (void)securityIndexes:(NSString *)securityIndexes; // Deprecated since PushLibrary 4.2.1, Manifest.xml 에서 security-indexes 값 정의하여 적용

- (void)registerService:(nullable id)activity completionHandler:(PushManagerInterfaceCompletionHandler)handler;
- (void)registerService:(nullable id)activity token:(NSString *)token completionHandler:(PushManagerInterfaceCompletionHandler)handler;

- (void)unregisterService:(nullable id)activity completionHandler:(PushManagerInterfaceCompletionHandler)handler;

- (void)registerUser:(nullable id)activity clientUID:(NSString *)clientUID clientName:(NSString *)clientName completionHandler:(PushManagerInterfaceCompletionHandler)handler;
- (void)registerUser:(nullable id)activity clientUID:(NSString *)clientUID clientName:(NSString *)clientName phoneNumber:(NSString *)phoneNumber completionHandler:(PushManagerInterfaceCompletionHandler)handler;

- (void)unregisterUser:(nullable id)activity completionHandler:(PushManagerInterfaceCompletionHandler)handler;

- (void)registerServiceAndUser:(nullable id)activity clientUID:(NSString *)clientUID clientName:(NSString *)clientName completionHandler:(PushManagerInterfaceCompletionHandler)handler;
- (void)registerServiceAndUser:(nullable id)activity clientUID:(NSString *)clientUID clientName:(NSString *)clientName completionHandlerWithBody:(PushManagerInterfaceCompletionHandlerWithBody)handler;
- (void)registerServiceAndUser:(nullable id)activity clientUID:(NSString *)clientUID clientName:(NSString *)clientName phoneNumber:(NSString *)phoneNumber completionHandler:(PushManagerInterfaceCompletionHandler)handler;

- (void)getRegisteredService:(nullable id)activity completionHandler:(PushManagerInterfaceCompletionHandlerWithError)handler;

- (void)registerGroup:(nullable id)activity groupSequenceNumber:(NSString *)groupSequenceNumber completionHandler:(PushManagerInterfaceCompletionHandler)handler;
- (void)unregisterGroup:(nullable id)activity groupSequenceNumber:(NSString *)groupSequenceNumber completionHandler:(PushManagerInterfaceCompletionHandler)handler;

- (void)read:(nullable id)activity messageUniqueKey:(NSString *)messageUniqueKey seqNo:(NSString *)seqNo completionHandler:(PushManagerInterfaceCompletionHandler)handler; // Deprecated in 3.6
- (void)read:(nullable id)activity notification:(NSDictionary *)notification completionHandler:(PushManagerInterfaceCompletionHandler)handler;
- (void)read:(nullable id)activity notification:(NSDictionary *)notification badgeOption:(PushManagerBadgeOption)badgeOption completionHandler:(PushManagerInterfaceCompletionHandler)handler; // Available since 4.0
- (void)read:(nullable id)activity notification:(NSDictionary *)notification badgeOption:(PushManagerBadgeOption)badgeOption badge:(NSNumber *)badge completionHandler:(PushManagerInterfaceCompletionHandler)handler; // Available since 4.0
- (void)update:(nullable id)activity badge:(NSNumber *)badge completionHandler:(PushManagerInterfaceCompletionHandler)handler; // Available since 4.0

- (void)feedback:(nullable id)activity messageUniqueKey:(NSString *)messageUniqueKey seqNo:(NSString *)seqNo completionHandler:(PushManagerInterfaceCompletionHandler)handler; // Deprecated in 3.6
- (void)feedback:(nullable id)activity notification:(NSDictionary *)notification completionHandler:(PushManagerInterfaceCompletionHandler)handler;
- (void)send:(nullable id)activity clientUID:(NSString *)clientUID
	message:(NSString *)message badgeNo:(NSNumber *)badgeNo serviceCode:(NSString *)serviceCode ext:(NSString *)ext completionHandler:(PushManagerInterfaceCompletionHandler)handler; // Available since 4.0
- (void)send:(nullable id)activity clientUID:(NSString *)clientUID
	message:(NSString *)message serviceCode:(NSString *)serviceCode ext:(NSString *)ext completionHandler:(PushManagerInterfaceCompletionHandler)handler; // Available since 3.6
- (void)send:(nullable id)activity message:(NSString *)message serviceCode:(NSString *)serviceCode ext:(NSString *)ext completionHandler:(PushManagerInterfaceCompletionHandler)handler;

- (void)send:(nullable id)activity clientUID:(NSString *)clientUID
     message:(NSString *)message serviceCode:(NSString *)serviceCode reserveDate:(NSString *)reserveDate ext:(NSString *)ext completionHandler:(PushManagerInterfaceCompletionHandlerWithBody)handler; // 예약발송
- (void)feedback:(nullable id)activity notification:(NSDictionary *)notification clientUID:(NSString *)clientUID psID:(NSString *)psID completionHandler:(PushManagerInterfaceCompletionHandler)handler;
- (void)feedbackEx:(NSDictionary *)notification clientUID:(NSString *)clientUID psID:(NSString *)psID completionHandler:(PushManagerInterfaceCompletionHandler)handler;

- (void)updateSession:(nullable id)activity cuid:(NSString *)cuid completionHandler:(PushManagerInterfaceCompletionHandlerWithBody)handler;
- (void)updateSession:(nullable id)activity option:(NSDictionary *)option completionHandler:(PushManagerInterfaceCompletionHandlerWithBody)handler;

- (void)updatePurchase:(nullable id)activity id:(NSString *)id cuid:(NSString *)cuid completionHandler:(PushManagerInterfaceCompletionHandlerWithBody)handler;
- (void)updatePurchase:(nullable id)activity option:(NSDictionary *)option completionHandler:(PushManagerInterfaceCompletionHandlerWithBody)handler;

- (void)setManifestFile:(NSString *)fileName;
- (void)removeManifestFile;

@end
