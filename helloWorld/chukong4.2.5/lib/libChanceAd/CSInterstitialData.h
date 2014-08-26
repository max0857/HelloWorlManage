//
//  CSInterstitialData.h
//  PBADSDK
//
//  Created by CocoaChina_yangjh on 14-7-8.
//  Copyright (c) 2014年 CocoaChina. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CSInterstitialItem : NSObject
@property (nonatomic, readonly) CGSize interstitialSize; // 图片尺寸（仅供参考，以下载到的图片尺寸为准）
@property (nonatomic, readonly) NSString *imageUrlH; // 横屏时的图片
@property (nonatomic, readonly) NSString *imageUrlV; // 竖屏时的图片
@end


// 弹出广告出错
typedef void (^CSInterstitialFailure)(NSError *error);
// 弹出广告成功
typedef void (^CSInterstitialSuccess)(CSInterstitialItem *interstitialItem);

@protocol CSInterstitialDataDelegate;

@interface CSInterstitialData : NSObject

@property (nonatomic, assign) id <CSInterstitialDataDelegate> delegate;

// 弹出广告出错的block
@property (nonatomic, copy) CSInterstitialFailure dataFailure;
// 弹出广告成功的block
@property (nonatomic, copy) CSInterstitialSuccess dataSuccess;

+ (CSInterstitialData *)sharedInstance;

// 获取弹出广告
- (void)getInterstitialData;

// 弹出广告被展现
- (void)showInterstitialItem:(CSInterstitialItem *)interstitialItem;

// 弹出广告被点击并打开（这个接口一定要调用，不需要再调用[[UIApplication sharedApplication] openURL:XXX];）
- (void)clickInterstitialItem:(CSInterstitialItem *)interstitialItem;

@end

@protocol CSInterstitialDataDelegate <NSObject>

// 弹出广告获取失败
- (void)interstitialData:(CSInterstitialData *)interstitialData interstitialError:(NSError *)error;

// 弹出广告获取成功
- (void)interstitialData:(CSInterstitialData *)interstitialData interstitialItem:(CSInterstitialItem *)interstitialItem;

@end
