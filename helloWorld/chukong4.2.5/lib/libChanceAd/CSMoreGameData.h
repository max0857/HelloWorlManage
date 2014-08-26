//
//  CSMoreGameData.h
//  PBADSDK
//
//  Created by pixar on 14-6-4.
//  Copyright (c) 2014年 CocoaChina. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CSMoreGameItem : NSObject
@property (nonatomic, readonly) NSString *iconUrl;
@property (nonatomic, readonly) NSString *pageName;
@property (nonatomic, readonly) NSString *title;
@property (nonatomic, readonly) NSString *content;
@end


// 精品推荐列表出错
typedef void (^CSMoreGameListFailure)(NSError *error);
// 精品推荐列表成功
typedef void (^CSMoreGameListSuccess)(NSArray *moreGameList);

@protocol CSMoreGameDataDelegate;


@interface CSMoreGameData : NSObject

@property (nonatomic, assign) id <CSMoreGameDataDelegate> delegate;

// 精品推荐列表出错的block
@property (nonatomic, copy) CSMoreGameListFailure listFailure;
// 精品推荐列表成功的block
@property (nonatomic, copy) CSMoreGameListSuccess listSuccess;

+ (CSMoreGameData *)sharedInstance;

// 获取精品推荐列表
- (void)getMoreGameList;

// 点击并打开精品推荐（这个接口一定要调用，不需要再调用[[UIApplication sharedApplication] openURL:XXX];）
- (void)clickAndOpenMoreGameItem:(CSMoreGameItem *)moreGameItem;

@end

@protocol CSMoreGameDataDelegate <NSObject>

// 精品推荐列表获取失败
- (void)pbMoreGameData:(CSMoreGameData *)moreGameData moreGameListError:(NSError *)error;

// 精品推荐列表获取成功，moreGameList中的元素为CSMoreGameItem类型
- (void)pbMoreGameData:(CSMoreGameData *)moreGameData moreGameList:(NSArray *)moreGameList;

@end
