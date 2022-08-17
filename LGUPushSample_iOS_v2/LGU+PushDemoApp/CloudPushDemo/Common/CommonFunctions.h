/*
 * CommonFunctions.h
 * 
 * author 류경민(Brain Ryu)
 * version v 1.0.0
 * since : 2010.12.24
 * Date : 2010.12.24
 * email : kmryu@uracle.co.kr
 * Company: URACLE
 * 
 * Copyright (c) URACLE, Inc. 
 * 166 Samseong-dong, Gangnam-gu, Seoul, 135-090, Korea, All Rights Reserved.
 *
 * Comment : 공통 함수 클래스 
 */


#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface CommonFunctions : NSObject {
}

+(CommonFunctions *) getInstance;

+ (BOOL)writePlist:(id)plist toFile:(NSString *)path;
+ (id)readPlist:(NSString *)path;
+ (NSString *)removeSpecialCharacterInString:(NSString*)orgStr specialCharacter:(char)sc;

+ (BOOL) isExistDatabase:(NSString *)dbName;
+ (sqlite3 *)openDatabaseWithName:(NSString *)dbName;
+ (void)closeDatabase:(sqlite3 *)database;
+ (BOOL)deleteAllDataInTable:(NSString *)tableName;
+ (void)createDataInTable:(NSString *)dbName;
+ (BOOL)updateItemsDB:(NSString *)tableName array:(NSDictionary *)wordDic new:(NSString *)fnew;
+ (BOOL)updateItemsDB:(NSString *)tableName uniquekey:(NSString *)key new:(NSString *)fnew;
+ (NSMutableArray *)getPushItems:(NSString *)tableName;
+ (BOOL)deleteDataInTable:(NSString *)tableName key:(NSString *)uniquekey;

@end
