//
//  DianAdpter.m
//  handleKiller
//
//  Created by yankai.peng on 14-8-19.
//
//

#import "DianAdpter.h"
#import "OfferWall.h"

@interface DianAdpter ()<OfferWallDelegate>


@property(nonatomic,assign) UIViewController *viewController;
@property(nonatomic,copy) NSString *appKey;
///查询到的积分
@property(nonatomic,assign) int nowScore;

@end

@implementation DianAdpter

-(id)initialize:(NSDictionary *)config window:(UIWindow *)window viewController:(UIViewController *)viewController{
    
    
    if((self=[super initialize:config window:window viewController:viewController])){
        
        self.nowScore=0;
        self.platformName=@"Dian";
        self.isDidFinishInitialize=NO;
        self.viewController=viewController;
        NSString *appKey=[config objectForKey:@"AppID"];
        
        /*容错*/
        if(appKey==nil || [appKey isEqualToString:@""]){
            
            NSLog(@"MiAdpter:appkey必须配置");
            return self;
        }
        
        ////////
        
        self.appKey=appKey;
        
        BOOL isAppStore=[((NSNumber *)[config objectForKey:@"InAppStore"]) boolValue];
        
#ifdef DEBUG
        
        isAppStore=NO;//在调试状态下，不要内部打开appStore。 未上线的应用在内置应用中只能显示，不能下载
#endif
        
        
        [OfferWall initWithOfferWallDelegate:self];
//        [self queryScore];
        self.isDidFinishInitialize=YES;
        
        
    }
    
    return self;
}


-(void) show{
    
    [OfferWall showOfferWall:self.viewController];
    
}

-(void) queryScore{
    
    [OfferWall getRemainPoint];
}

-(void) expenseScore:(int)score{
    
    
    [super expenseScore:score];
}




-(void) dealloc{
    
    [super dealloc];
    
    [self setAppKey:nil];
    _appKey=nil;
}


#pragma mark  delegate

/*
 用于消费积分结果的回调
 */
-(void)didReceiveSpendScoreResult:(BOOL)isSuccess{
    
    
    if(isSuccess){
        [self expenseScore:self.nowScore];
        self.nowScore=0;
    }
    
}

/*
 用于获取剩余积分结果的回调
 */
-(void)didReceiveGetScoreResult:(int)point{
    
    if(point!=-1){
        
        self.nowScore=point;
        [OfferWall spendPoint:point];
    }
    
}

-(NSString *)applicationKey
{
    return self.appKey;
    
}

@end
