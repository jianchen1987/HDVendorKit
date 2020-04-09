//
//  AFNetworking+Retry.h
//  HDVendorKit
//
//  Created by VanJay on 2019/3/28.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import <AFNetworking/AFHTTPSessionManager.h>
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef int (^RetryDelayCalcBlock)(int, int, int);

@interface AFHTTPSessionManager (Retry)

/**
 *   是否输出日志
 */
@property (nonatomic, assign) bool retryPolicyLogMessagesEnabled;

/**
 为 AFNetworking 增加设置重试次数、重试间隔和提供重试间隔步进的能力

 @param URLString 请求地址
 @param parameters 参数
 @param downloadProgress 下载进度
 @param success 成功回调
 @param failure 失败回调
 @param retryCount 重试次数
 @param retryInterval 重试间隔
 @param progressive 重试间隔是否步进递增
 @param fatalStatusCodes 不重试的错误码
 @return NSURLSessionDataTask
 */
- (NSURLSessionDataTask *)GET:(NSString *)URLString parameters:(NSDictionary *)parameters progress:(void (^)(NSProgress *))downloadProgress success:(void (^)(NSURLSessionDataTask *task, id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure retryCount:(NSInteger)retryCount retryInterval:(NSTimeInterval)retryInterval progressive:(bool)progressive fatalStatusCodes:(NSArray<NSNumber *> *)fatalStatusCodes;

/**
 为 AFNetworking 增加设置重试次数、重试间隔和提供重试间隔步进的能力
 
 @param URLString 请求地址
 @param parameters 参数
 @param success 成功回调
 @param failure 失败回调
 @param retryCount 重试次数
 @param retryInterval 重试间隔
 @param progressive 重试间隔是否步进递增
 @param fatalStatusCodes 不重试的错误码
 @return NSURLSessionDataTask
 */
- (NSURLSessionDataTask *)HEAD:(NSString *)URLString parameters:(NSDictionary *)parameters success:(void (^)(NSURLSessionDataTask *task))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure retryCount:(NSInteger)retryCount retryInterval:(NSTimeInterval)retryInterval progressive:(bool)progressive fatalStatusCodes:(NSArray<NSNumber *> *)fatalStatusCodes;

/**
 为 AFNetworking 增加设置重试次数、重试间隔和提供重试间隔步进的能力
 
 @param URLString 请求地址
 @param parameters 参数
 @param downloadProgress 下载进度
 @param success 成功回调
 @param failure 失败回调
 @param retryCount 重试次数
 @param retryInterval 重试间隔
 @param progressive 重试间隔是否步进递增
 @param fatalStatusCodes 不重试的错误码
 @return NSURLSessionDataTask
 */
- (NSURLSessionDataTask *)POST:(NSString *)URLString parameters:(NSDictionary *)parameters progress:(void (^)(NSProgress *))downloadProgress success:(void (^)(NSURLSessionDataTask *task, id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure retryCount:(NSInteger)retryCount retryInterval:(NSTimeInterval)retryInterval progressive:(bool)progressive fatalStatusCodes:(NSArray<NSNumber *> *)fatalStatusCodes;

/**
 为 AFNetworking 增加设置重试次数、重试间隔和提供重试间隔步进的能力
 
 @param URLString 请求地址
 @param parameters 参数
 @param downloadProgress 下载进度
 @param success 成功回调
 @param failure 失败回调
 @param retryCount 重试次数
 @param retryInterval 重试间隔
 @param progressive 重试间隔是否步进递增
 @param fatalStatusCodes 不重试的错误码
 @return NSURLSessionDataTask
 */
- (NSURLSessionDataTask *)POST:(NSString *)URLString parameters:(NSDictionary *)parameters constructingBodyWithBlock:(void (^)(id<AFMultipartFormData> formData))block progress:(void (^)(NSProgress *))downloadProgress success:(void (^)(NSURLSessionDataTask *task, id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure retryCount:(NSInteger)retryCount retryInterval:(NSTimeInterval)retryInterval progressive:(bool)progressive fatalStatusCodes:(NSArray<NSNumber *> *)fatalStatusCodes;

/**
 为 AFNetworking 增加设置重试次数、重试间隔和提供重试间隔步进的能力
 
 @param URLString 请求地址
 @param parameters 参数
 @param success 成功回调
 @param failure 失败回调
 @param retryCount 重试次数
 @param retryInterval 重试间隔
 @param progressive 重试间隔是否步进递增
 @param fatalStatusCodes 不重试的错误码
 @return NSURLSessionDataTask
 */
- (NSURLSessionDataTask *)PUT:(NSString *)URLString parameters:(NSDictionary *)parameters success:(void (^)(NSURLSessionDataTask *task, id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure retryCount:(NSInteger)retryCount retryInterval:(NSTimeInterval)retryInterval progressive:(bool)progressive fatalStatusCodes:(NSArray<NSNumber *> *)fatalStatusCodes;

/**
 为 AFNetworking 增加设置重试次数、重试间隔和提供重试间隔步进的能力
 
 @param URLString 请求地址
 @param parameters 参数
 @param success 成功回调
 @param failure 失败回调
 @param retryCount 重试次数
 @param retryInterval 重试间隔
 @param progressive 重试间隔是否步进递增
 @param fatalStatusCodes 不重试的错误码
 @return NSURLSessionDataTask
 */
- (NSURLSessionDataTask *)PATCH:(NSString *)URLString parameters:(NSDictionary *)parameters success:(void (^)(NSURLSessionDataTask *task, id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure retryCount:(NSInteger)retryCount retryInterval:(NSTimeInterval)retryInterval progressive:(bool)progressive fatalStatusCodes:(NSArray<NSNumber *> *)fatalStatusCodes;

/**
 为 AFNetworking 增加设置重试次数、重试间隔和提供重试间隔步进的能力
 
 @param URLString 请求地址
 @param parameters 参数
 @param success 成功回调
 @param failure 失败回调
 @param retryCount 重试次数
 @param retryInterval 重试间隔
 @param progressive 重试间隔是否步进递增
 @param fatalStatusCodes 不重试的错误码
 @return NSURLSessionDataTask
 */
- (NSURLSessionDataTask *)DELETE:(NSString *)URLString parameters:(NSDictionary *)parameters success:(void (^)(NSURLSessionDataTask *task, id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure retryCount:(NSInteger)retryCount retryInterval:(NSTimeInterval)retryInterval progressive:(bool)progressive fatalStatusCodes:(NSArray<NSNumber *> *)fatalStatusCodes;

/**
为 AFNetworking 增加设置重试次数、重试间隔和提供重试间隔步进的能力

@param request 请求
@param uploadProgressBlock 上传进度
@param downloadProgressBlock 下载进度
@param completionHandler 回调
@param retryCount 重试次数
@param retryInterval 重试间隔
@param progressive 重试间隔是否步进递增
@param fatalStatusCodes 不重试的错误码
@return NSURLSessionDataTask
*/
- (NSURLSessionDataTask *)dataTaskWithRequest:(NSURLRequest *)request
                               uploadProgress:(nullable void (^)(NSProgress *uploadProgress))uploadProgressBlock
                             downloadProgress:(nullable void (^)(NSProgress *_Nullable downloadProgress))downloadProgressBlock
                            completionHandler:(nullable void (^)(NSURLResponse *_Nonnull response, id _Nullable responseObject, NSError *_Nullable error))completionHandler
                                   retryCount:(NSInteger)retryCount
                                retryInterval:(NSTimeInterval)retryInterval
                                  progressive:(bool)progressive
                             fatalStatusCodes:(NSArray<NSNumber *> *_Nullable)fatalStatusCodes;

@end

NS_ASSUME_NONNULL_END
