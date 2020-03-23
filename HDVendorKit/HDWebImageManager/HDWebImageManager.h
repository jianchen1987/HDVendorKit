//
//  HDWebImageManager.h
//  HDVendorKit
//
//  Created by VanJay on 2019/4/29.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import <HDKitCore/HDKitCore.h>
#import <SDWebImage/SDWebImage.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HDWebImageManager : NSObject

/**
 *  异步获取图片
 *
 *  @param url         图片url
 *  @param placeholder 占位图片
 *  @param imageView   图片显示控件 必须是强引用
 */
+ (void)setImageWithURL:(nullable NSString *)url placeholderImage:(nullable UIImage *)placeholder imageView:(nullable UIImageView *)imageView;

/**
 *  异步获取图片
 *
 *  @param url 图片url
 *  @param size 图片大小
 *  @param placeholder 占位图片
 *  @param imageView   图片显示控件 必须是强引用
 */
+ (void)setImageWithURL:(nullable NSString *)url size:(CGSize)size placeholderImage:(nullable UIImage *)placeholder imageView:(nullable UIImageView *)imageView;

/**
 *  异步获取图片 返回下载成功的图片
 *
 *  @param url 图片url
 *  @param placeholder 占位图片
 *  @param imageView 图片显示控件 必须是强引用
 *  @param completedBlock 下载完成的block回调
 */
+ (void)setImageWithURL:(nullable NSString *)url placeholderImage:(nullable UIImage *)placeholder imageView:(nullable UIImageView *)imageView completed:(nullable SDExternalCompletionBlock)completedBlock;

/**
 *  异步获取图片 带进度
 *
 *  @param url 图片url
 *  @param placeholder 占位图片
 *  @param imageView 图片显示控件 必须是强引用
 *  @param progressBlock  下载进度回调
 *  @param completedBlock 下载完成的block回调
 */
+ (void)setImageWithURL:(nullable NSString *)url placeholderImage:(nullable UIImage *)placeholder imageView:(nullable UIImageView *)imageView progress:(nullable SDWebImageDownloaderProgressBlock)progressBlock completed:(nullable SDExternalCompletionBlock)completedBlock;

/**
 *  异步获取GIF图片
 *
 *  @param url 图片url
 *  @param placeholder 占位图片
 *  @param imageView   图片显示控件 必须是强引用
 */
+ (void)setGIFImageWithURL:(nullable NSString *)url placeholderImage:(nullable UIImage *)placeholder imageView:(nullable SDAnimatedImageView *)imageView;

/**
 *  异步获取GIF图片
 *
 *  @param url 图片url
 *  @param size 图片大小
 *  @param placeholder 占位图片
 *  @param imageView   图片显示控件 必须是强引用
 */
+ (void)setGIFImageWithURL:(nullable NSString *)url size:(CGSize)size placeholderImage:(nullable UIImage *)placeholder imageView:(nullable SDAnimatedImageView *)imageView;

/**
 *  异步获取GIF图片 返回下载成功的图片
 *
 *  @param url 图片url
 *  @param placeholder 占位图片
 *  @param imageView 图片显示控件 必须是强引用
 *  @param completedBlock 下载完成的block回调
 */
+ (void)setGIFImageWithURL:(nullable NSString *)url placeholderImage:(nullable UIImage *)placeholder imageView:(nullable SDAnimatedImageView *)imageView completed:(nullable SDExternalCompletionBlock)completedBlock;

/**
 *  异步获取GIF图片 带进度
 *
 *  @param url 图片url
 *  @param placeholder 占位图片
 *  @param imageView 图片显示控件 必须是强引用
 *  @param progressBlock  下载进度回调
 *  @param completedBlock 下载完成的block回调
 */
+ (void)setGIFImageWithURL:(nullable NSString *)url placeholderImage:(nullable UIImage *)placeholder imageView:(nullable SDAnimatedImageView *)imageView progress:(nullable SDWebImageDownloaderProgressBlock)progressBlock completed:(nullable SDExternalCompletionBlock)completedBlock;

/**
 *  异步下载图片 带进度
 *
 *  @param url 图片url
 *  @param progressBlock 下载进度回调
 *  @param completedBlock 下载完成的block回调
 */
+ (void)downloadImageWithURL:(nullable NSString *)url progress:(nullable SDWebImageDownloaderProgressBlock)progressBlock completed:(nullable SDWebImageDownloaderCompletedBlock)completedBlock;

/**
 *  解决内存警告
 */
+ (void)clearWebImageCache;
@end

NS_ASSUME_NONNULL_END
