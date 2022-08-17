/*
 * CommonFunctions.m
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

#import "CommonFunctions.h"

@implementation CommonFunctions : NSObject

static CommonFunctions *m_func_Instance = nil;

-(id)init {
	if ( (self = [super init]) )
    {
	}
	return self;
}

-(void)dealloc {
	//[super dealloc];
}
/*
 SingleTon
 */
+(CommonFunctions *) getInstance {
	@synchronized(self) {
		if (m_func_Instance == nil) {
			m_func_Instance = [[CommonFunctions alloc] init];
		}
	}
	return m_func_Instance;
}

+ (BOOL)writePlist:(id)plist toFile:(NSString *)path
{
    NSString *error;
    NSData *pData = [NSPropertyListSerialization
					 dataFromPropertyList:plist
					 format:NSPropertyListBinaryFormat_v1_0 errorDescription:&error];
    if (!pData) {
        return NO;
    }
    return [pData writeToFile:path atomically:YES];
}

+ (id)readPlist:(NSString *)path {
    NSData *retData;
    NSString *error;
    id retPlist;
	
    NSPropertyListFormat format;
	
    retData = [NSData dataWithContentsOfFile:path];
	
    if (!retData) {
        return nil;
    }
    retPlist = [NSPropertyListSerialization
				propertyListFromData:retData
				mutabilityOption:NSPropertyListImmutable
				format:&format
				errorDescription:&error];
	
    if (!retPlist){
    }
    return retPlist;
}

//
// 특정 문자 제거
//
+ (NSString *)removeSpecialCharacterInString:(NSString*)orgStr specialCharacter:(char)sc
{
	NSMutableString *retStr = [NSMutableString stringWithFormat:@"%@", orgStr];
	
	for( int i = [orgStr length]-1; i > 0; i-- )
	{
		if ([orgStr characterAtIndex:i] == sc)
		{
			NSRange range = { i, 1 };
			[retStr deleteCharactersInRange:range];
		}
	}
	return retStr;
}


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//	데이터베이스 관련 함수 들

//
//	데이터베이스 유무 확인
//
+ (BOOL) isExistDatabase:(NSString *)dbName
{
	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
	NSString *filePath = [documentsDirectory stringByAppendingPathComponent:dbName];
	
	return [fileManager fileExistsAtPath:filePath];
}

//
//	데이터베이스 열기
//
+ (sqlite3 *)openDatabaseWithName:(NSString *)dbName
{
	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
	
	NSString *filePath = [documentsDirectory stringByAppendingPathComponent:dbName];
	
	// 이미 DB가 존재하지 않는 경우 새로 생성
	if ([fileManager fileExistsAtPath:filePath] == NO)
	{
		[CommonFunctions createDataInTable:dbName];
        
		sqlite3 *database;
		if (sqlite3_open([filePath UTF8String], &database) != SQLITE_OK) {
			sqlite3_close(database);
			[self closeDatabase:database];
			return nil;
		}
		return database;
	}
	
	sqlite3 *database;
	if (sqlite3_open([filePath UTF8String], &database) != SQLITE_OK) {
		sqlite3_close(database);
		return nil;
	}
	
	return database;
}

//
//	데이터베이스 닫기
//
+ (void)closeDatabase:(sqlite3 *)database
{
	sqlite3_close(database);
}

//
// 테이블 데이터 클리어
//
+ (BOOL)deleteAllDataInTable:(NSString *)tableName
{
	sqlite3 *database = [self openDatabaseWithName:@"items.db"];
	
	sqlite3_stmt *statement;
	
	NSString *sql = [NSString stringWithFormat:@"DELETE FROM %@", tableName];
	//	char *sql = [preSql UTF8String];
	
	int ret = sqlite3_prepare_v2(database, [sql UTF8String], -1, &statement, NULL);
	if (ret == SQLITE_OK) {
		
		sqlite3_bind_text(statement, 1, [tableName UTF8String],  -1, SQLITE_TRANSIENT);
		
		if (sqlite3_step(statement) != SQLITE_DONE) {
			[self closeDatabase:database];
			return NO;
		}
	}
	
	sqlite3_finalize(statement);
	
	[self closeDatabase:database];
	
	return YES;
	
}

+ (BOOL)deleteDataInTable:(NSString *)tableName key:(NSString *)seqno
{
  	sqlite3 *database = [self openDatabaseWithName:@"items.db"];
	
	sqlite3_stmt *statement;
	
	NSString *sql = [NSString stringWithFormat:@"DELETE FROM %@ WHERE seqno = '%@'", tableName, seqno];
	
	int ret = sqlite3_prepare_v2(database, [sql UTF8String], -1, &statement, NULL);
	if (ret == SQLITE_OK) {
		
		sqlite3_bind_text(statement, 1, [tableName UTF8String],  -1, SQLITE_TRANSIENT);
		
		if (sqlite3_step(statement) != SQLITE_DONE) {
			[self closeDatabase:database];
			return NO;
		}
	}
	
	sqlite3_finalize(statement);
	
	[self closeDatabase:database];
	
	return YES;
}

//
//	종목 마스터 테이블 생성
//
+ (void)createDataInTable:(NSString *)dbName
{
	NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
	NSString *filePath = [documentsDirectory stringByAppendingPathComponent:dbName];
	   
	sqlite3 *database;
	if (sqlite3_open([filePath UTF8String], &database) != SQLITE_OK) {
		sqlite3_close(database);
		[self closeDatabase:database];
	}
	
    char *sql = "CREATE TABLE PushItems (seqno VARCHAR PRIMARY KEY  NOT NULL , alert VARCHAR NOT NULL , body VARCHAR NOT NULL , ext, senddate VARCHAR  NOT NULL , new VARCHAR NOT NULL)";
	if (sqlite3_exec(database, sql, nil,nil,nil) != SQLITE_OK) {
		sqlite3_close(database);
		[self closeDatabase:database];
	}
}

+(BOOL)updateItemsDB:(NSString *)tableName array:(NSDictionary *)wordDic new:(NSString *)fnew
{
    NSString *seqno = @"";
    NSString *title = @"";
    NSString *ext = @"";
    NSString *body = @"";
    
    //TODO 정확한 방어코드 필요
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *currentday = [NSDate date];
    NSString *dateString = [dateFormat stringFromDate:currentday];

    NSDictionary *apsInfo = [wordDic valueForKey:@"aps"];
    id object = [apsInfo objectForKey:@"alert"];
    if([object isKindOfClass:[NSDictionary class]])
    {
        title = [(NSDictionary *)object objectForKey:@"title"] ? [(NSDictionary *)object objectForKey:@"title"] : @"알림";
        body = [(NSDictionary *)object objectForKey:@"body"] ? [(NSDictionary *)object objectForKey:@"body"] : @"";
    }
    else if([object isKindOfClass:[NSString class]])
    {
        title = @"알림";
        body = (NSString *)object;
    }
    
    NSDictionary *mps = [wordDic valueForKey:@"mps"];

    seqno = [mps valueForKey:@"seqno"];
    ext = [mps valueForKey:@"ext"] ? [mps valueForKey:@"ext"] : @"";
    
    NSString *isNew = fnew;
    
    sqlite3 *database = [self openDatabaseWithName:@"items.db"];
	
	sqlite3_stmt *statement;
    
	NSString *sql = [NSString stringWithFormat:@"INSERT INTO PushItems(seqno, alert, body, ext, senddate, new) VALUES('%@', '%@', '%@','%@','%@','%@');",seqno,title,body,ext,dateString,isNew];
    
	int ret = sqlite3_prepare_v2(database, [sql UTF8String], -1, &statement, NULL);
	if (ret == SQLITE_OK) {
		
		sqlite3_bind_text(statement, 1, [tableName UTF8String],  -1, SQLITE_TRANSIENT);
		
		if (sqlite3_step(statement) != SQLITE_DONE) {
			[self closeDatabase:database];
			return NO;
		}
	}
	
	sqlite3_finalize(statement);
	
	[self closeDatabase:database];
	
	return YES;
}

+(BOOL)updateItemsDB:(NSString *)tableName uniquekey:(NSString *)key new:(NSString *)fnew
{
    sqlite3 *database = [self openDatabaseWithName:@"items.db"];
	
	sqlite3_stmt *statement;
    
	NSString *sql = [NSString stringWithFormat:@"UPDATE PushItems SET new = '%@' WHERE seqno = '%@';",fnew, key];
    
	int ret = sqlite3_prepare_v2(database, [sql UTF8String], -1, &statement, NULL);
	if (ret == SQLITE_OK) {
		
		sqlite3_bind_text(statement, 1, [tableName UTF8String],  -1, SQLITE_TRANSIENT);
		
		if (sqlite3_step(statement) != SQLITE_DONE) {
			[self closeDatabase:database];
			return NO;
		}
	}
	
	sqlite3_finalize(statement);
	
	[self closeDatabase:database];
	
	return YES;
}

+ (NSMutableArray *)getPushItems:(NSString *)tableName
{
    sqlite3 *database = [self openDatabaseWithName:@"items.db"];
	NSMutableArray *itemsInfo = [NSMutableArray array];
	
	NSString *sql;
	
    sql = [NSString stringWithFormat:@"SELECT seqno, alert, body, ext, senddate, new FROM %@ ORDER BY senddate DESC", tableName];
    
	sqlite3_stmt *statement = NULL;
	
	if ( sqlite3_prepare_v2(database, [sql UTF8String], -1, &statement, NULL) == SQLITE_OK ) {
				
		while ( sqlite3_step(statement) == SQLITE_ROW ) {
			
			NSString *seqno = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
			NSString *title = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
            NSString *body = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
			NSString *ext = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
            NSString *senddate = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 4)];
            NSString *new = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 5)];
			         
            [itemsInfo addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:seqno, @"seqno",title, @"alert", body, @"body", ext, @"ext", senddate, @"senddate", new, @"new",nil]];            
		}
	}
	
	sqlite3_finalize(statement);
	[self closeDatabase:database];
	return itemsInfo;
}
@end


