//
//  WNFMDBManager.h
//  HDVendorKit
//
//  Created by seeu on 2022/4/7.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


@class FMResultSet;

@protocol WNDBManagerProtocol <NSObject>

@required
- (instancetype)initWithResultSet:(FMResultSet *)rs;

- (NSString *)nameOfTable;
- (NSString *)sqlForCreate;
- (NSString *)sqlForInsert;
- (NSString *)sqlForDelete;
- (NSString *)sqlForQuery;
- (NSString *)sqlForUpdate;



@end

@interface WNFMDBManager : NSObject

- (instancetype)init __attribute__((unavailable("Use - initWithPath: instead.")));

- (instancetype)initWithPath:(NSString *)path;

- (BOOL)insertObject:(id<WNDBManagerProtocol>)object;

- (NSArray<id> *)searchWithObject:(id<WNDBManagerProtocol>)object;

- (BOOL)deleteObject:(id<WNDBManagerProtocol>)object;

- (BOOL)updateWithObject:(id<WNDBManagerProtocol>)object;

@end

NS_ASSUME_NONNULL_END
