//
//  AnAdpter.m
//  handleKiller
//
//  Created by yankai.peng on 14-8-22.
//
//

#import "AnAdpter.h"
#import "ZKcmoneZKcmtwo.h"

@interface AnAdpter ()

@property(nonatomic,copy) NSString *appKey;
@property(nonatomic,assign) UIViewController *viewController;
@property(nonatomic,assign) int curScore;

@end

@implementation AnAdpter


-(id) initialize:(NSDictionary *)config window:(UIWindow *)window viewController:(UIViewController *)viewController{
    
    
    if((self=[super initialize:config window:window viewController:viewController])){
     
        self.platformName=@"An";
        self.isDidFinishInitialize=NO;
        self.viewController=viewController;
        self.curScore=0;
        NSString *appKey=[config objectForKey:@"AppID"];
        
        /*容错*/
        if(appKey==nil || [appKey isEqualToString:@""]){
            
            NSLog(@"AnAdpter:appkey必须配置");
            return self;
        }
        
        self.appKey=appKey;
        
        ////////
        
        // 注册积分消费响应事件消息
        ZKcmoneOWRegisterResponseEvent(ZKCMONE_ZKCM_TWO_CONSUMEPTS_PT, self, @selector(ZKcmoneOWConsumepoint));
        // 注册积分墙刷新最新积分响应事件消息，使用分数的时候，开发者应该先刷新积分接口获得服务器的最新积分，再利用此分数进行相关操作
        ZKcmoneOWRegisterResponseEvent(ZKCMONE_ZKCM_TWO_REFRESH_PT, self, @selector(ZKcmoneOWRefreshPoint));
        
        
        self.isDidFinishInitialize=YES;
        
        
    }
    
    return self;
    
}


-(void) show{
    
    // 初始化并登录积分墙
    ZKcmoneOWPresentZKcmtwo(self.appKey, self.viewController);
    
}

-(void) queryScore{
    
    ZKcmoneOWRefreshPoint();
    
}

-(void) expenseScore:(int)score{
    
    [super expenseScore:score];
    
}

-(void) dealloc{
    
    ZKcmoneOWUnregisterResponseEvents(ZKCMONE_ZKCM_TWO_REFRESH_PT|ZKCMONE_ZKCM_TWO_CONSUMEPTS_PT);
    
    [self setAppKey:nil];
    _appKey=nil;
    
    [super dealloc];
    
}


#pragma mark zkcmone callback

//消费积分响应的代理方法，开发者每次消费积分之后，需要在收到此响应之后才表示完成一次消费
-(void)ZKcmoneOWConsumepoint{
    
    NSInteger errCode = ZKcmoneOWFetchLatestErrorCode();
    if(errCode == ZKCMONE_ZKCM_TWO_ERRORCODE_SUCCESS)
    {
        [self expenseScore:self.curScore];
        self.curScore=0;
        
    }
    
}

//刷新积分响应的代理方法
-(void)ZKcmoneOWRefreshPoint{
    
    NSInteger errCode = ZKcmoneOWFetchLatestErrorCode();
    if(errCode == ZKCMONE_ZKCM_TWO_ERRORCODE_SUCCESS)
    {
        int pRemainPoints;
        //当刷新到最新积分之后，利用此函数获得当前积分。
        ZKcmoneOWGetCurrentPoints(&pRemainPoints);
        ZKcmoneOWConsumePoints(pRemainPoints);//马上消费
        self.curScore=pRemainPoints;
    }
    
}

@end
