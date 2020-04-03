//
//  AFNetworking+Retry.m
//  HDVendorKit
//
//  Created by VanJay on 2019/3/28.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

// clang-format off
#if __has_include(<ObjcAssociatedObjectHelpers/ObjcAssociatedObjectHelpers.h>)
#import <ObjcAssociatedObjectHelpers/ObjcAssociatedObjectHelpers.h>
#else
#import "ObjcAssociatedObjectHelpers.h"
#endif
// clang-format on

#import "AFHTTPSessionManager+Retry.h"
#import <objc/message.h>

@interface AFHTTPSessionManager ()
@property (nonatomic, strong) id tasksDict;
@property (nonatomic, copy) id retryDelayCalcBlock;
@end

@implementation AFHTTPSessionManager (Retry)

SYNTHESIZE_ASC_OBJ(__tasksDict, setTasksDict);
SYNTHESIZE_ASC_OBJ(__retryDelayCalcBlock, setRetryDelayCalcBlock);
SYNTHESIZE_ASC_PRIMITIVE(__retryPolicyLogMessagesEnabled, setRetryPolicyLogMessagesEnabled, bool);

- (void)logMessage:(NSString *)message, ... {
    if (!self.__retryPolicyLogMessagesEnabled) {
        return;
    }
#ifdef DEBUG
    va_list args;
    va_start(args, message);
    va_end(args);
    NSLog([NSString stringWithFormat:@"Retry: %@", message], args);
#endif
}

- (void)createTasksDict {
    [self setTasksDict:[[NSDictionary alloc] init]];
}

- (void)createDelayRetryCalcBlock {
    RetryDelayCalcBlock block = ^int(int totalRetries, int currentRetry, int delayInSecondsSpecified) {
        return delayInSecondsSpecified;
    };
    [self setRetryDelayCalcBlock:block];
}

- (id)retryDelayCalcBlock {
    if (!self.__retryDelayCalcBlock) {
        [self createDelayRetryCalcBlock];
    }
    return self.__retryDelayCalcBlock;
}

- (id)tasksDict {
    if (!self.__tasksDict) {
        [self createTasksDict];
    }
    return self.__tasksDict;
}

- (bool)retryPolicyLogMessagesEnabled {
    if (!self.__retryPolicyLogMessagesEnabled) {
        [self setRetryPolicyLogMessagesEnabled:false];
    }
    return self.__retryPolicyLogMessagesEnabled;
}

- (BOOL)isErrorFatal:(NSError *)error {
    switch (error.code) {
        case kCFHostErrorHostNotFound:
        case kCFHostErrorUnknown:  // 查询kCFGetAddrInfoFailureKey以获取getaddrinfo返回的值; 在netdb.h中查找
        // HTTP 错误
        case kCFErrorHTTPAuthenticationTypeUnsupported:
        case kCFErrorHTTPBadCredentials:
        case kCFErrorHTTPParseFailure:
        case kCFErrorHTTPRedirectionLoopDetected:
        case kCFErrorHTTPBadURL:
        case kCFErrorHTTPBadProxyCredentials:
        case kCFErrorPACFileError:
        case kCFErrorPACFileAuth:
        case kCFStreamErrorHTTPSProxyFailureUnexpectedResponseToCONNECTMethod:
        // CFURLConnection和CFURLProtocol的错误代码
        case kCFURLErrorUnknown:
        case kCFURLErrorCancelled:
        case kCFURLErrorBadURL:
        case kCFURLErrorUnsupportedURL:
        case kCFURLErrorHTTPTooManyRedirects:
        case kCFURLErrorBadServerResponse:
        case kCFURLErrorUserCancelledAuthentication:
        case kCFURLErrorUserAuthenticationRequired:
        case kCFURLErrorZeroByteResource:
        case kCFURLErrorCannotDecodeRawData:
        case kCFURLErrorCannotDecodeContentData:
        case kCFURLErrorCannotParseResponse:
        case kCFURLErrorInternationalRoamingOff:
        case kCFURLErrorCallIsActive:
        case kCFURLErrorDataNotAllowed:
        case kCFURLErrorRequestBodyStreamExhausted:
        case kCFURLErrorFileDoesNotExist:
        case kCFURLErrorFileIsDirectory:
        case kCFURLErrorNoPermissionsToReadFile:
        case kCFURLErrorDataLengthExceedsMaximum:
        // SSL 错误
        case kCFURLErrorServerCertificateHasBadDate:
        case kCFURLErrorServerCertificateUntrusted:
        case kCFURLErrorServerCertificateHasUnknownRoot:
        case kCFURLErrorServerCertificateNotYetValid:
        case kCFURLErrorClientCertificateRejected:
        case kCFURLErrorClientCertificateRequired:
        case kCFURLErrorCannotLoadFromNetwork:
        // Cookie 错误
        case kCFHTTPCookieCannotParseCookieFile:
        // CFNetServices
        case kCFNetServiceErrorUnknown:
        case kCFNetServiceErrorCollision:
        case kCFNetServiceErrorNotFound:
        case kCFNetServiceErrorInProgress:
        case kCFNetServiceErrorBadArgument:
        case kCFNetServiceErrorCancel:
        case kCFNetServiceErrorInvalid:
        // 特例
        case 101:  // 空地址
        case 102:  // 忽略“帧加载中断”错误
            return YES;

        default:
            break;
    }

    return NO;
}

/**
 重试

 @param error 错误码（非状态码）
 */
- (BOOL)isErrorShouldRetry:(NSError *)error {
    switch (error.code) {
        case kCFURLErrorTimedOut:               // -1001
        case kCFURLErrorNetworkConnectionLost:  // 1005
        case kCFURLErrorBadServerResponse:      // -1011
            return YES;

        default:
            break;
    }
    return NO;
}

/**
 切换线路
 
 @param error 错误码（非状态码）
 */
- (BOOL)isErrorShouldSwitchServerLine:(NSError *)error {
    switch (error.code) {
        case kCFURLErrorCannotFindHost:            // -1003
        case kCFURLErrorCannotConnectToHost:       // -1004
        case kCFURLErrorSecureConnectionFailed:    // -1200
        case kCFURLErrorUnsupportedURL:            // -1002
        case kCFErrorHTTPSProxyConnectionFailure:  // 310
            return YES;

        default:
            break;
    }
    return NO;
}

- (NSURLSessionDataTask *)requestUrlWithRetryRemaining:(NSInteger)retryRemaining maxRetry:(NSInteger)maxRetry retryInterval:(NSTimeInterval)retryInterval progressive:(bool)progressive fatalStatusCodes:(NSArray<NSNumber *> *)fatalStatusCodes originalRequestCreator:(NSURLSessionDataTask * (^)(void (^)(NSURLSessionDataTask *, NSError *)))taskCreator originalFailure:(void (^)(NSURLSessionDataTask *task, NSError *))failure {
    // 失败了才会来到 block
    void (^retryBlock)(NSURLSessionDataTask *, NSError *) = ^(NSURLSessionDataTask *task, NSError *error) {
        // 这个判断用来判断错误码是否该重试，有了切服机制，这个就该注释
        /**
        if ([self isErrorFatal:error]) {
            [self logMessage:[NSString stringWithFormat:@"请求失败，收到严重错误，请查看屏蔽列表，原因：%@", error.localizedDescription]];
            failure(task, error);
            return;
        }
        */

        NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
        [self logMessage:[NSString stringWithFormat:@"网络请求失败， response 状态码：%zd，错误码 ：%zd, 当前请求地址：%@", response.statusCode, error.code, task.currentRequest.URL.absoluteString]];

        /*
         NSInteger errorCode = error.code;
         
        // 切换线路或重试的前提都是业务层允许重试，即传来的最大重试次数 > 0
        if (maxRetry > 0 && [self isErrorShouldSwitchServerLine:error]) {
            [self logMessage:[NSString stringWithFormat:@"请求得到错误码 %zd ，在切换线路的 statusCode 数组中，将停止重试，原因：%@，业务层允许重试并且错误码在直接切服之列，开始切换服务器", errorCode, error.localizedDescription]];
            
            [[HDReservedLineManager sharedInsance] switchToReservedLineSwitchCompletion:^(BOOL isSuccess) {
                if (isSuccess) {
                    [self logMessage:[NSString stringWithFormat:@"当前接口允许重试，线路切换成功，原该接口允许 %zd 次重试, 将再发起 %zd 次重试", maxRetry, maxRetry]];

                    NSInteger internalRetryRemaining = retryRemaining;
                    if (internalRetryRemaining == 0) {
                        internalRetryRemaining = maxRetry + 1;
                    }

                    [self requestUrlWithRetryRemaining:internalRetryRemaining - 1 maxRetry:maxRetry retryInterval:retryInterval progressive:progressive fatalStatusCodes:fatalStatusCodes originalRequestCreator:taskCreator originalFailure:failure];
                } else {
                    [self logMessage:@"当前接口允许重试，线路切换失败，直接回传错误"];

                    failure(task, error);
                }
            }];

            return;
        }
         */

        for (NSNumber *fatalStatusCode in fatalStatusCodes) {
            if (response.statusCode == fatalStatusCode.integerValue) {
                [self logMessage:[NSString stringWithFormat:@"请求得到状态码 %zd ，在指定不再尝试的 statusCode 数组中，将停止重试，原因：%@", fatalStatusCode.integerValue, error.localizedDescription]];
                failure(task, error);
                return;
            }
        }

        [self logMessage:[NSString stringWithFormat:@"请求失败，原因：%@，还剩 %zd 次", error.localizedDescription, retryRemaining]];
        if (retryRemaining > 0) {
            void (^addRetryOperation)(void) = ^{
                [self requestUrlWithRetryRemaining:retryRemaining - 1 maxRetry:maxRetry retryInterval:retryInterval progressive:progressive fatalStatusCodes:fatalStatusCodes originalRequestCreator:taskCreator originalFailure:failure];
            };
            if (retryInterval > 0.0) {
                dispatch_time_t delay;
                if (progressive) {
                    delay = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(retryInterval * pow(2, maxRetry - retryRemaining) * NSEC_PER_SEC));
                    [self logMessage:[NSString stringWithFormat:@"延迟下次重试在 %.f 后", retryInterval * pow(2, maxRetry - retryRemaining)]];
                } else {
                    delay = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(retryInterval * NSEC_PER_SEC));
                    [self logMessage:[NSString stringWithFormat:@"延迟下次重试在 %.f 后", retryInterval]];
                }

                dispatch_after(delay, dispatch_get_main_queue(), ^(void) {
                    addRetryOperation();
                });

            } else {
                addRetryOperation();
            }

        } else {
            if (maxRetry > 0) {
                [self logMessage:[NSString stringWithFormat:@"重试次数达当前请求最大 %zd 次，不再重试", maxRetry]];
            }
            failure(task, error);
            /*
            // 已经重试所有传入的次数并且允许重试并且是这些重试 code 才触发切换线路
            if (maxRetry > 0 && [self isErrorShouldRetry:error]) {
                [self logMessage:[NSString stringWithFormat:@"已经重试所有传入的次数 %zd 次，并且 code 允许重试，开始切换线路", maxRetry]];
                [[HDReservedLineManager sharedInsance] switchToReservedLineSwitchCompletion:^(BOOL isSuccess) {
                    if (isSuccess) {
                        [self logMessage:[NSString stringWithFormat:@"当前接口允许重试且已经重试所有传入的次数，收到线路切换成功的通知，原该接口允许 %zd 次重试, 将再发起 %zd 次重试", maxRetry, maxRetry]];
                        NSInteger internalRetryRemaining = retryRemaining;
                        if (internalRetryRemaining == 0) {
                            internalRetryRemaining = maxRetry + 1;
                        }

                        [self requestUrlWithRetryRemaining:internalRetryRemaining - 1 maxRetry:maxRetry retryInterval:retryInterval progressive:progressive fatalStatusCodes:fatalStatusCodes originalRequestCreator:taskCreator originalFailure:failure];

                    } else {
                        [self logMessage:@"当前接口允许重试且已经重试所有传入的次数，线路切换失败，直接回传错误"];
                        failure(task, error);
                    }
                }];
            } else {  // 已经重试所有传入的次数并且不允许重试
                failure(task, error);
            }
             */
        }
    };
    NSURLSessionDataTask *task = taskCreator(retryBlock);
    return task;
}

#pragma mark - Base
- (NSURLSessionDataTask *)GET:(NSString *)URLString parameters:(NSDictionary *)parameters progress:(void (^)(NSProgress *))downloadProgress success:(void (^)(NSURLSessionDataTask *task, id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure retryCount:(NSInteger)retryCount retryInterval:(NSTimeInterval)retryInterval progressive:(bool)progressive fatalStatusCodes:(NSArray<NSNumber *> *)fatalStatusCodes {
    NSURLSessionDataTask *task = [self requestUrlWithRetryRemaining:retryCount
                                                           maxRetry:retryCount
                                                      retryInterval:retryInterval
                                                        progressive:progressive
                                                   fatalStatusCodes:fatalStatusCodes
                                             originalRequestCreator:^NSURLSessionDataTask *(void (^retryBlock)(NSURLSessionDataTask *, NSError *)) {
                                                 // 重试会回到这里，如需更新 host 地址，可以在这里处理 URLString
                                                 return [self GET:URLString parameters:parameters progress:downloadProgress success:success failure:retryBlock];
                                             }
                                                    originalFailure:failure];
    return task;
}

- (NSURLSessionDataTask *)HEAD:(NSString *)URLString parameters:(NSDictionary *)parameters success:(void (^)(NSURLSessionDataTask *task))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure retryCount:(NSInteger)retryCount retryInterval:(NSTimeInterval)retryInterval progressive:(bool)progressive fatalStatusCodes:(NSArray<NSNumber *> *)fatalStatusCodes {
    NSURLSessionDataTask *task = [self requestUrlWithRetryRemaining:retryCount
                                                           maxRetry:retryCount
                                                      retryInterval:retryInterval
                                                        progressive:progressive
                                                   fatalStatusCodes:fatalStatusCodes
                                             originalRequestCreator:^NSURLSessionDataTask *(void (^retryBlock)(NSURLSessionDataTask *, NSError *)) {
                                                 // 重试会回到这里，如需更新 host 地址，可以在这里处理 URLString
                                                 return [self HEAD:URLString parameters:parameters success:success failure:retryBlock];
                                             }
                                                    originalFailure:failure];
    return task;
}

- (NSURLSessionDataTask *)POST:(NSString *)URLString parameters:(NSDictionary *)parameters progress:(void (^)(NSProgress *))downloadProgress success:(void (^)(NSURLSessionDataTask *task, id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure retryCount:(NSInteger)retryCount retryInterval:(NSTimeInterval)retryInterval progressive:(bool)progressive fatalStatusCodes:(NSArray<NSNumber *> *)fatalStatusCodes {

    NSURLSessionDataTask *task = [self requestUrlWithRetryRemaining:retryCount
                                                           maxRetry:retryCount
                                                      retryInterval:retryInterval
                                                        progressive:progressive
                                                   fatalStatusCodes:fatalStatusCodes
                                             originalRequestCreator:^NSURLSessionDataTask *(void (^retryBlock)(NSURLSessionDataTask *, NSError *)) {
                                                 // 重试会回到这里，如需更新 host 地址，可以在这里处理 URLString
                                                 return [self POST:URLString parameters:parameters progress:downloadProgress success:success failure:retryBlock];
                                             }
                                                    originalFailure:failure];
    return task;
}

- (NSURLSessionDataTask *)POST:(NSString *)URLString parameters:(NSDictionary *)parameters constructingBodyWithBlock:(void (^)(id<AFMultipartFormData> formData))block progress:(void (^)(NSProgress *))downloadProgress success:(void (^)(NSURLSessionDataTask *task, id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure retryCount:(NSInteger)retryCount retryInterval:(NSTimeInterval)retryInterval progressive:(bool)progressive fatalStatusCodes:(NSArray<NSNumber *> *)fatalStatusCodes {
    NSURLSessionDataTask *task = [self requestUrlWithRetryRemaining:retryCount
                                                           maxRetry:retryCount
                                                      retryInterval:retryInterval
                                                        progressive:progressive
                                                   fatalStatusCodes:fatalStatusCodes
                                             originalRequestCreator:^NSURLSessionDataTask *(void (^retryBlock)(NSURLSessionDataTask *, NSError *)) {
                                                 // 重试会回到这里，如需更新 host 地址，可以在这里处理 URLString
                                                 return [self POST:URLString parameters:parameters constructingBodyWithBlock:block progress:downloadProgress success:success failure:retryBlock];
                                             }
                                                    originalFailure:failure];
    return task;
}

- (NSURLSessionDataTask *)PUT:(NSString *)URLString parameters:(NSDictionary *)parameters success:(void (^)(NSURLSessionDataTask *task, id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure retryCount:(NSInteger)retryCount retryInterval:(NSTimeInterval)retryInterval progressive:(bool)progressive fatalStatusCodes:(NSArray<NSNumber *> *)fatalStatusCodes {
    NSURLSessionDataTask *task = [self requestUrlWithRetryRemaining:retryCount
                                                           maxRetry:retryCount
                                                      retryInterval:retryInterval
                                                        progressive:progressive
                                                   fatalStatusCodes:fatalStatusCodes
                                             originalRequestCreator:^NSURLSessionDataTask *(void (^retryBlock)(NSURLSessionDataTask *, NSError *)) {
                                                 // 重试会回到这里，如需更新 host 地址，可以在这里处理 URLString
                                                 return [self PUT:URLString parameters:parameters success:success failure:retryBlock];
                                             }
                                                    originalFailure:failure];
    return task;
}

- (NSURLSessionDataTask *)PATCH:(NSString *)URLString parameters:(NSDictionary *)parameters success:(void (^)(NSURLSessionDataTask *task, id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure retryCount:(NSInteger)retryCount retryInterval:(NSTimeInterval)retryInterval progressive:(bool)progressive fatalStatusCodes:(NSArray<NSNumber *> *)fatalStatusCodes {
    NSURLSessionDataTask *task = [self requestUrlWithRetryRemaining:retryCount
                                                           maxRetry:retryCount
                                                      retryInterval:retryInterval
                                                        progressive:progressive
                                                   fatalStatusCodes:fatalStatusCodes
                                             originalRequestCreator:^NSURLSessionDataTask *(void (^retryBlock)(NSURLSessionDataTask *, NSError *)) {
                                                 // 重试会回到这里，如需更新 host 地址，可以在这里处理 URLString
                                                 return [self PATCH:URLString parameters:parameters success:success failure:retryBlock];
                                             }
                                                    originalFailure:failure];
    return task;
}

- (NSURLSessionDataTask *)DELETE:(NSString *)URLString parameters:(NSDictionary *)parameters success:(void (^)(NSURLSessionDataTask *task, id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure retryCount:(NSInteger)retryCount retryInterval:(NSTimeInterval)retryInterval progressive:(bool)progressive fatalStatusCodes:(NSArray<NSNumber *> *)fatalStatusCodes {
    NSURLSessionDataTask *task = [self requestUrlWithRetryRemaining:retryCount
                                                           maxRetry:retryCount
                                                      retryInterval:retryInterval
                                                        progressive:progressive
                                                   fatalStatusCodes:fatalStatusCodes
                                             originalRequestCreator:^NSURLSessionDataTask *(void (^retryBlock)(NSURLSessionDataTask *, NSError *)) {
                                                 // 重试会回到这里，如需更新 host 地址，可以在这里处理 URLString
                                                 return [self DELETE:URLString parameters:parameters success:success failure:retryBlock];
                                             }
                                                    originalFailure:failure];
    return task;
}

- (NSURLSessionDataTask *)dataTaskWithRequest:(NSURLRequest *)request
                               uploadProgress:(nullable void (^)(NSProgress *uploadProgress))uploadProgressBlock
                             downloadProgress:(nullable void (^)(NSProgress *downloadProgress))downloadProgressBlock
                            completionHandler:(nullable void (^)(NSURLResponse *response, id _Nullable responseObject, NSError *_Nullable error))completionHandler
                                   retryCount:(NSInteger)retryCount
                                retryInterval:(NSTimeInterval)retryInterval
                                  progressive:(bool)progressive
                             fatalStatusCodes:(NSArray<NSNumber *> *)fatalStatusCodes {
    NSURLSessionDataTask *task = [self requestUrlWithRetryRemaining:retryCount
        maxRetry:retryCount
        retryInterval:retryInterval
        progressive:progressive
        fatalStatusCodes:fatalStatusCodes
        originalRequestCreator:^NSURLSessionDataTask *(void (^retryBlock)(NSURLSessionDataTask *, NSError *)) {
            // 重试会回到这里，如需更新 host 地址，可以在这里处理 URLString
            return [self dataTaskWithRequest:request uploadProgress:uploadProgressBlock downloadProgress:downloadProgressBlock completionHandler:completionHandler];
        }
        originalFailure:^(NSURLSessionDataTask *task, NSError *e) {
            if (completionHandler) {
                completionHandler(nil, nil, e);
            }
        }];
    return task;
}
@end
