//
//  WNFMDBManager.m
//  HDVendorKit
//
//  Created by seeu on 2022/4/7.
//

#import "WNFMDBManager.h"
#import <FMDB/FMDB.h>

@interface WNFMDBManager ()

///< 数据库实例
@property (nonatomic, strong) FMDatabase *dataBase;

@end

@implementation WNFMDBManager

- (instancetype)initWithPath:(NSString *)path {
    self = [super init];
    if(self) {
        self.dataBase = [[FMDatabase alloc] initWithPath:path];
        self.dataBase.crashOnErrors = NO;
        self.dataBase.logsErrors = YES;
    }
    return self;
}


#pragma mark - public methods
- (BOOL)insertObject:(id<WNDBManagerProtocol>)object {
    if([self isExitTableForObject:object]) {
        return [self.dataBase executeUpdate:[object sqlForInsert]];
    }
    
    return NO;
}

- (NSArray<id> *)searchWithObject:(id<WNDBManagerProtocol>)object {
    if([self isExitTableForObject:object]) {
        NSMutableArray<id> *result = [[NSMutableArray alloc] initWithCapacity:3];
        FMResultSet *rs = [self.dataBase executeQuery:[object sqlForQuery]];
        while([rs next]) {
            id<WNDBManagerProtocol> newObject = [object.class new];
            [newObject initWithResultSet:rs];
            if(newObject) {
                [result addObject:newObject];
            }
        }
        return result;
    }
    
    return @[];
}

- (BOOL)deleteObject:(id<WNDBManagerProtocol>)object {
    if([self isExitTableForObject:object]) {
        return [self.dataBase executeUpdate:[object sqlForDelete]];
    }
    
    return NO;
}

- (BOOL)updateWithObject:(id<WNDBManagerProtocol>)object {
    if([self isExitTableForObject:object]) {
        return [self.dataBase executeUpdate:[object sqlForUpdate]];
    }
    
    return NO;
}


#pragma mark - private methods
- (BOOL)isExitTableForObject:(id<WNDBManagerProtocol>)object {
    if([self.dataBase open]) {
        NSString *tableName = [object nameOfTable];
        BOOL success = [self.dataBase executeQuery:[NSString stringWithFormat:@"select * from %@ where 1=1", tableName]];
        if(!success) {
            NSString *createTable = [object sqlForCreate];
            success = [self.dataBase executeUpdate:createTable];
        }
        return success;
    }
    return NO;
}


@end
