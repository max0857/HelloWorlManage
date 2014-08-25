//
//  MiAdpter.m
//  handleKiller
//
//  Created by yankai.peng on 14-8-19.
//
//

#import "MiAdpter.h"

#import "YouMiWall.h"

#import "youmiconfuse.h"


@interface MiAdpter ()

/**
 获得积分的监听器
 */
-(void) pointsGottedListen;

@end


@implementation MiAdpter


-(id) initialize:(NSDictionary *)config window:(UIWindow *)window viewController:(UIViewController *)viewController{
    
    if((self=[super initialize:config window:window viewController:viewController])){
        
        self.platformName=@"Mi";
        self.isDidFinishInitialize=NO;
        NSString *appKey=[config objectForKey:@"AppID"];
        NSString *appSecret=[config objectForKey:@"appSecret"];
        
        /*容错*/
        if(appKey==nil || [appKey isEqualToString:@""]){
            
            NSLog(@"MiAdpter:appkey必须配置");
            return self;
        }
        
        if(appSecret==nil || [appSecret isEqualToString:@""]){
            NSLog(@"MiAdpter:appSecret必须配置");
            return self;
        }
        ////////
        
        BOOL isAppStore=[((NSNumber *)[config objectForKey:@"InAppStore"]) boolValue];
        
#ifdef DEBUG
      
        isAppStore=NO;//在调试状态下，不要内部打开appStore。 未上线的应用在内置应用中只能显示，不能下载
#endif
        
        [YouMiConfig setUseInAppStore:isAppStore];//是否应用内打开app store
        [YouMiConfig launchWithAppID:appKey appSecret:appSecret];
        [YouMiConfig setFullScreenWindow:window];
        [YouMiWall enable];//启用积分墙
        [YouMiPointsManager enable];//积分托管系统开启
        
        
        //增加获得积分的监听者
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pointsGottedListen) name:kYouMiPointsManagerRecivedPointsNotification object:nil];
        
        self.isDidFinishInitialize=YES;
    }
    return self;
}

-(void) show{
    
    [YouMiWall showOffers:YES didShowBlock:^{
        
        self.isShowing=YES;
        
    } didDismissBlock:^{
        self.isShowing=NO;
    }];
}

-(void) queryScore{
    
    int *point=[YouMiPointsManager pointsRemained];
    [self expenseScore:*point];//获得积分后马上消费，实际上是统一交由manage处理.
    free(point);
}

-(void) expenseScore:(int)score{
    
    
    [YouMiPointsManager spendPoints:score];
    [super expenseScore:score];
}

-(void) pointsGottedListen{
    
    [self queryScore];
}

-(void) dealloc{
    
    [super dealloc];
    
}

@end
