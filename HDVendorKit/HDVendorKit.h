//
//  HDVendorKit.h
//  HDVendorKit
//
//  Created by VanJay on 2020/2/26.
//  Copyright © 2020 VanJay. All rights reserved.
//  This file is generated automatically.

#ifndef HDVendorKit_h
#define HDVendorKit_h

#import <UIKit/UIKit.h>

/// 版本号
static NSString * const HDVendorKit_VERSION = @"0.1.4";

#if __has_include("KVOController.h")
#import "KVOController.h"
#endif

#if __has_include("FBKVOController.h")
#import "FBKVOController.h"
#endif

#if __has_include("FBKVOController+HDVendorKit.h")
#import "FBKVOController+HDVendorKit.h"
#endif

#if __has_include("NSObject+FBKVOController.h")
#import "NSObject+FBKVOController.h"
#endif

#if __has_include("HDWebImageManager.h")
#import "HDWebImageManager.h"
#endif

#if __has_include("ObjcAssociatedObjectHelpers.h")
#import "ObjcAssociatedObjectHelpers.h"
#endif

#if __has_include("HDWeakTimer.h")
#import "HDWeakTimer.h"
#endif

#if __has_include("OTPGenerator.h")
#import "OTPGenerator.h"
#endif

#if __has_include("MF_Base32Additions.h")
#import "MF_Base32Additions.h"
#endif

#if __has_include("TOTPGenerator.h")
#import "TOTPGenerator.h"
#endif

#if __has_include("AFHTTPSessionManager+Retry.h")
#import "AFHTTPSessionManager+Retry.h"
#endif

#endif /* HDVendorKit_h */