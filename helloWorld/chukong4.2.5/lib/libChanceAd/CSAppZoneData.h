//
//  CSAppZoneData.h
//  PBADSDK
//
//  Created by CocoaChina_yangjh on 14-5-7.
//  Copyright (c) 2014年 CocoaChina. All rights reserved.
//

#import <Foundation/Foundation.h>

// 积分墙项
@interface CSAppZoneItem : NSObject
@property (nonatomic, readonly) NSString *appID;
@property (nonatomic, readonly) NSString *coins;
@property (nonatomic, readonly) NSString *unit;
@property (nonatomic, readonly) NSString *iconUrl;
@property (nonatomic, readonly) NSString *title;
@property (nonatomic, readonly) NSString *content;
@property (nonatomic, readonly) NSString *taskSummary;
@end
// 积分墙任务项
@interface CSAppZoneTaskItem : NSObject
@property (nonatomic, readonly) NSString *coins;
@property (nonatomic, readonly) NSString *unit;
@property (nonatomic, readonly) NSDate *dateEnd;
@property (nonatomic, readonly) unsigned int taskStatus; // 0：未领取；1：任务进行中；2：任务已完成
@property (nonatomic, readonly) NSString *taskName;
@property (nonatomic, readonly) NSString *taskContent;
@end
// 积分墙项详情
@interface CSAppZoneItemDetail : NSObject
@property (nonatomic, readonly) CSAppZoneItem *itemInfo;
@property (nonatomic, readonly) NSArray *taskList; // 列表中的元素为CSAppZoneTaskItem类型
@end


// 积分墙列表出错
typedef void (^CSAppZoneListFailure)(NSError *error);
// 积分墙列表成功
typedef void (^CSAppZoneListSuccess)(NSArray *appZoneList);
// 积分墙项详情失败
typedef void (^CSAppZoneItemDetailFailure)(CSAppZoneItem *appZoneItem, NSError *error);
// 积分墙项详情成功
typedef void (^CSAppZoneItemDetailSuccess)(CSAppZoneItemDetail *appZoneItemDetail);


@protocol CSAppZoneDataDelegate;

@interface CSAppZoneData : NSObject

@property (nonatomic, assign) id <CSAppZoneDataDelegate> delegate;

// 积分墙列表出错的block
@property (nonatomic, copy) CSAppZoneListFailure listFailure;
// 积分墙列表成功的block
@property (nonatomic, copy) CSAppZoneListSuccess listSuccess;
// 积分墙项详情失败的block
@property (nonatomic, copy) CSAppZoneItemDetailFailure itemDetailFailure;
// 积分墙项详情成功的block
@property (nonatomic, copy) CSAppZoneItemDetailSuccess itemDetailSuccess;

+ (CSAppZoneData *)sharedInstance;

// 获取积分墙列表
- (void)getAppZoneList;

// 获取积分墙项详情
- (void)getAppZoneItemDetailOf:(CSAppZoneItem *)appZoneItem;

// 领取任务并打开广告（这个接口一定要调用，不需要开发者再调用[[UIApplication sharedApplication] openURL:XXX];）
- (void)clickAndOpenAppZoneTaskItem:(CSAppZoneTaskItem *)taskItem;

@end


@protocol CSAppZoneDataDelegate <NSObject>

// 积分墙列表获取失败
- (void)pbAppZoneData:(CSAppZoneData *)appZoneData appZoneListError:(NSError *)error;

// 积分墙列表获取成功，appZoneList中的元素为CSAppZoneItem类型
- (void)pbAppZoneData:(CSAppZoneData *)appZoneData appZoneList:(NSArray *)appZoneList;

// 积分墙项详情获取失败
- (void)pbAppZoneData:(CSAppZoneData *)appZoneData appZoneDetailError:(NSError *)error
                   with:(CSAppZoneItem *)appZoneItem;

// 积分墙项详情获取成功
- (void)pbAppZoneData:(CSAppZoneData *)appZoneData
        appZoneDetail:(CSAppZoneItemDetail *)appZoneItemDetail;

@end
