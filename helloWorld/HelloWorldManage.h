//
//  HelloWorldTools.h
//  handleKiller
//
//  Created by yankai.peng on 14-8-19.
//
//

#import <Foundation/Foundation.h>

@class HelloWorldManage;
typedef enum{
    
    PlatformMi=0,
    PlatformDian
    
} PlatformType ;

static HelloWorldManage *__hw_instance=nil;

@interface HelloWorldManage : NSObject

/**
 获得单件类
 应该在程序开始时在didFinishLaunchingWithOptions中调用：
 注因为部分平台的关系，应在[window makeKeyAndVisible];之后调用
 */
+(HelloWorldManage *) defaultManage;

/**
 设置审核开关，YES为打开
 使用本类的第一行代码必须调用此方法
 */
+(void) setReviewFlag:(BOOL) flag;

-(id) init;

/**
 此方法不应该外部调用
 */
-(void) work;

/**
 加载数据
 注：未完成数据加载前，任何操作是无效的。
 */
-(void) loadConfigData;


/**
 通过反射机制从配置中创建特定平台适配器
 初始化各平台
 */
-(void)initializePlatform;

/**
 在没有完成初始化的情况下，可使用此方法重新初始化
 
 本方法会忽略审核开关， 一旦调用即说明审核开关为关闭状态
 本方法也是针对于审核开关本是关闭，但程序开始时未拿到在线参数，默认为为开启了，那么广告墙不初始化。
 当拿到在线参数后，确认开关为关闭状态可以调用此方法重新初始化广告墙
 
 */
-(void) reWork;

/**
 查询积分
 */
-(int) queryScore;

/**
 消费积分
 */
-(void) expenseScore:(int)score;

/**
 增加积分
 */
-(void) addScore:(int) score;

/**
 显示积分墙，指定一个平台
 */
-(void) show:(NSString *) platName;

/**
 随即显示已配置的积分墙,根据配置几率
 */
-(void) show;

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



#pragma mark 定义property开始

@property(nonatomic,assign) BOOL isDidFinishLoadConfig;
@property(nonatomic,retain) NSDictionary* configData;

///各平台初始化后存放实例的数组
@property(nonatomic,retain) NSMutableArray *platformsArr;

@property(nonatomic,assign) BOOL reviewFalg;


@end
