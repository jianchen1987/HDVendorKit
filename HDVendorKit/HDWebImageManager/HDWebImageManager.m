//
//  HDWebImageManager.m
//  HDVendorKit
//
//  Created by VanJay on 2019/4/29.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import "HDWebImageManager.h"

static SDWebImageDownloader *_ImageDownloader = nil;
static dispatch_once_t onceToken;

@implementation HDWebImageManager
+ (void)setImageWithURL:(nullable NSString *)url placeholderImage:(nullable UIImage *)placeholder imageView:(nullable UIImageView *)imageView {
    [self setImageWithURL:url size:CGSizeZero placeholderImage:placeholder imageView:imageView completed:nil];
}

+ (void)setImageWithURL:(nullable NSString *)url size:(CGSize)size placeholderImage:(nullable UIImage *)placeholder imageView:(nullable UIImageView *)imageView {
    [self setImageWithURL:url size:size placeholderImage:placeholder imageView:imageView completed:nil];
}

+ (void)setImageWithURL:(nullable NSString *)url placeholderImage:(nullable UIImage *)placeholder imageView:(nullable UIImageView *)imageView completed:(nullable SDExternalCompletionBlock)completedBlock {
    [self setImageWithURL:url size:CGSizeZero placeholderImage:placeholder imageView:imageView progress:nil completed:completedBlock];
}

+ (void)setImageWithURL:(nullable NSString *)url size:(CGSize)size placeholderImage:(nullable UIImage *)placeholder imageView:(nullable UIImageView *)imageView completed:(nullable SDExternalCompletionBlock)completedBlock {
    [self setImageWithURL:url size:size placeholderImage:placeholder imageView:imageView progress:nil completed:completedBlock];
}

+ (void)setImageWithURL:(nullable NSString *)url placeholderImage:(nullable UIImage *)placeholder imageView:(nullable UIImageView *)imageView progress:(nullable SDWebImageDownloaderProgressBlock)progressBlock completed:(nullable SDExternalCompletionBlock)completedBlock {
    [self setImageWithURL:url size:CGSizeZero placeholderImage:placeholder imageView:imageView progress:progressBlock completed:completedBlock];
}

+ (void)setImageWithURL:(nullable NSString *)url size:(CGSize)size placeholderImage:(nullable UIImage *)placeholder imageView:(nullable UIImageView *)imageView progress:(nullable SDWebImageDownloaderProgressBlock)progressBlock completed:(nullable SDExternalCompletionBlock)completedBlock {
    if (HDIsStringEmpty(url)) {
        if (size.width > 0 && size.height > 0) {
            imageView.image = [placeholder hd_imageResizedWithScreenScaleInLimitedSize:size];
        } else {
            imageView.image = placeholder;
        }
        if (completedBlock) {
            completedBlock(nil, [NSError errorWithDomain:@"url为空" code:-1 userInfo:nil], SDImageCacheTypeNone, nil);
        }
        return;
    }
    
    
    dispatch_once(&onceToken,^{
        SDWebImageDownloaderConfig *config = [[SDWebImageDownloaderConfig alloc] init];
        config.maxConcurrentDownloads = 10;
        config.downloadTimeout = 30;
        _ImageDownloader = [[SDWebImageDownloader alloc] initWithConfig:config];
    });
    
    [imageView sd_setImageWithURL:[NSURL URLWithString:url]
                 placeholderImage:placeholder
                          options:SDWebImageRetryFailed | SDWebImageHighPriority | SDWebImageProgressiveLoad
                          context:@{SDWebImageContextImageLoader : _ImageDownloader}
                         progress:progressBlock
                        completed:^(UIImage *_Nullable image, NSError *_Nullable error, SDImageCacheType cacheType, NSURL *_Nullable imageURL) {
        
                            if (error || !image) {
                                if (size.width > 0 && size.height > 0) {
                                    imageView.image = [placeholder hd_imageResizedWithScreenScaleInLimitedSize:size];
                                } else {
                                    imageView.image = placeholder;
                                }
                                if (completedBlock) {
                                    completedBlock(image, error, cacheType, imageURL);
                                }
                                
                            } else {
                                
                                if (completedBlock) {
                                    if (size.width > 0 && size.height > 0) {
                                        completedBlock([image hd_imageResizedWithScreenScaleInLimitedSize:size], error, cacheType, imageURL);
                                    } else {
                                        completedBlock(image, error, cacheType, imageURL);
                                    }
                                } else {
                                    if (size.width > 0 && size.height > 0) {
                                        imageView.image = [image hd_imageResizedWithScreenScaleInLimitedSize:size];
                                    } else {
                                        imageView.image = image;
                                    }
                                }
                            }
                        }];
}

+ (void)setGIFImageWithURL:(nullable NSString *)url placeholderImage:(nullable UIImage *)placeholder imageView:(nullable SDAnimatedImageView *)imageView {

    [self setGIFImageWithURL:url size:CGSizeZero placeholderImage:placeholder imageView:imageView];
}

+ (void)setGIFImageWithURL:(nullable NSString *)url size:(CGSize)size placeholderImage:(nullable UIImage *)placeholder imageView:(nullable SDAnimatedImageView *)imageView {
    [self setGIFImageWithURL:url size:size placeholderImage:placeholder imageView:imageView progress:nil completed:nil];
}

+ (void)setGIFImageWithURL:(nullable NSString *)url placeholderImage:(nullable UIImage *)placeholder imageView:(nullable SDAnimatedImageView *)imageView completed:(nullable SDExternalCompletionBlock)completedBlock {
    [self setGIFImageWithURL:url size:CGSizeZero placeholderImage:placeholder imageView:imageView progress:nil completed:completedBlock];
}

+ (void)setGIFImageWithURL:(nullable NSString *)url placeholderImage:(nullable UIImage *)placeholder imageView:(nullable SDAnimatedImageView *)imageView progress:(nullable SDWebImageDownloaderProgressBlock)progressBlock completed:(nullable SDExternalCompletionBlock)completedBlock {
    [self setGIFImageWithURL:url size:CGSizeZero placeholderImage:placeholder imageView:imageView progress:progressBlock completed:completedBlock];
}

+ (void)setGIFImageWithURL:(nullable NSString *)url size:(CGSize)size placeholderImage:(nullable UIImage *)placeholder imageView:(nullable SDAnimatedImageView *)imageView progress:(nullable SDWebImageDownloaderProgressBlock)progressBlock completed:(nullable SDExternalCompletionBlock)completedBlock {
    if (size.width > 0 && size.height > 0) {
        placeholder = [placeholder hd_imageResizedWithScreenScaleInLimitedSize:size];
    }
    if (HDIsStringEmpty(url)) {
        imageView.image = placeholder;
        return;
    }
    
    dispatch_once(&onceToken,^{
        SDWebImageDownloaderConfig *config = [[SDWebImageDownloaderConfig alloc] init];
        config.maxConcurrentDownloads = 10;
        config.downloadTimeout = 30;
        _ImageDownloader = [[SDWebImageDownloader alloc] initWithConfig:config];
    });
    
    
    [imageView sd_setImageWithURL:[NSURL URLWithString:url]
                 placeholderImage:placeholder
                          options:SDWebImageRetryFailed | SDWebImageHighPriority
                          context:@{SDWebImageContextImageLoader : _ImageDownloader}
                         progress:progressBlock
                        completed:completedBlock];
}

+ (void)downloadImageWithURL:(nullable NSString *)url progress:(nullable SDWebImageDownloaderProgressBlock)progressBlock completed:(nullable SDWebImageDownloaderCompletedBlock)completedBlock {
    [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:url]
                                                          options:SDWebImageDownloaderUseNSURLCache
                                                         progress:progressBlock
                                                        completed:completedBlock];
}

+ (void)clearWebImageCache {
    // 赶紧清除所有的内存缓存
    [[SDImageCache sharedImageCache] clearMemory];

    // 赶紧停止正在进行的图片下载操作
    // 有可能导致图片终止下载，暂时注释
//    [[SDWebImageManager sharedManager] cancelAll];
}
@end
