//
//  FBKVOController+HDVendorKit.m
//  HDVendorKit
//
//  Created by VanJay on 2019/4/29.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import "FBKVOController+HDVendorKit.h"

@implementation FBKVOController (HDVendorKit)
- (void)hd_observe:(id)object keyPath:(NSString *)keyPath block:(FBKVONotificationBlock)block {
    [self observe:object keyPath:keyPath options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew block:block];
}

- (void)hd_observe:(id)object keyPath:(NSString *)keyPath action:(SEL)action {
    [self observe:object keyPath:keyPath options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew action:action];
}
@end
