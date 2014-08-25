//
//  HWadapter.h
//  handleKiller
//
//  Created by yankai.peng on 14-8-19.
//
//

#import <Foundation/Foundation.h>
#import "HelloWorldManage.h"

@interface HWAdapter : NSObject


/**
 初始化平台
 参数：config
 键          值
 AppID       应用ID
 appSecret   secret值
 
 注：某些平台可能没有Secret值。
 */
-(id) initialize:(NSDictionary *)  config window:(UIWindow *) window viewController:(UIViewController *)viewController;


/**
 查询积分
 */
-(void) queryScore;

/**
 消费积分
 */
-(void) expenseScore:(int)score;

/**
 显示
 */
-(void) show;

/**
 关闭、销毁
 */
-(void) dismiss;

/**
 根据随机因子确定能否显示
 */
-(BOOL) canShow:(int) randomKey;


/**
 生命周期：applicationWillResignActive
 */
-(void) applicationWillResignActive;

/**
 生命周期:applicationDidBecomeActive
 */
-(void) applicationDidBecomeActive;

/**
 生命周期:applicationDidEnterBackground
 */
-(void) applicationDidEnterBackground;

/**
 生命周期：applicationWillEnterForeground
 */
-(void) applicationWillEnterForeground;


#pragma mark property定义开始
/**
 是否正在显示积分墙
 */
@property(nonatomic,assign) BOOL isShowing;

/**
 是否正常完成了初始化
 */
@property(nonatomic,assign) BOOL isDidFinishInitialize;

/**
 平台名
 */
@property(nonatomic,copy) NSString *platformName;

/**
 该平台显示的几率,100%值为100
 */
@property(nonatomic,assign) int showProbability;

/**
 随机因子最小值
 */
@property(nonatomic,assign) int randomMin;

/**
 随机因子最大值
 */
@property(nonatomic,assign) int randomMax;

@end
