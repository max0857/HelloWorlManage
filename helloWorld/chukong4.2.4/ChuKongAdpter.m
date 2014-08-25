//
//  ChuKongAdpter.m
//  handleKiller
//
//  Created by yankai.peng on 14-8-20.
//
//

#import "ChuKongAdpter.h"
#import "ChanceAd.h"
#import "CSAppZone.h"


@interface ChuKongAdpter()

@property(nonatomic,assign) UIViewController *viewController;

@end

@implementation ChuKongAdpter


-(id) initialize:(NSDictionary *)config window:(UIWindow *)window viewController:(UIViewController *)viewController{
    
    if((self=[super initialize:config window:window viewController:viewController])){
        
        self.platformName=@"ChuKong";
        self.isDidFinishInitialize=NO;
        self.viewController=viewController;
        NSString *appKey=[config objectForKey:@"AppID"];
        
        /*容错*/
        if(appKey==nil || [appKey isEqualToString:@""]){
            
            NSLog(@"MiAdpter:appkey必须配置");
            return self;
        }
        
        ////////
        
        BOOL isAppStore=[((NSNumber *)[config objectForKey:@"InAppStore"]) boolValue];
        
#ifdef DEBUG
        
        isAppStore=NO;//在调试状态下，不要内部打开appStore。 未上线的应用在内置应用中只能显示，不能下载
#endif
        
        [ChanceAd startSession:appKey];
        [[CSAppZone sharedAppZone] loadAppZone:[CSADRequest request]];
        self.isDidFinishInitialize=YES;
    }
    return self;
}

-(void) show{
    
    [[CSAppZone sharedAppZone] showAppZoneOnRootView:self.viewController.view withScale:0.9f];

}

-(void) queryScore{
    
    /**
     触控积分查询后即清0，所以这边无需自己进行消费
     */
    
    [[CSAppZone sharedAppZone] queryRewardCoin:^(NSArray *taskCoins, CSRequestError *error) {
        
        if(error==nil && taskCoins!=nil && [taskCoins count]!=0){
            
            for(NSDictionary *dic in taskCoins){
                
                NSNumber *coinsNum = [dic objectForKey:@"coins"];
                if(coinsNum!=nil){
                    
                    [self expenseScore:[coinsNum intValue]];
                }
            }
            
        }
        
    }];
    
}

-(void) expenseScore:(int)score{
    
    
    [super expenseScore:score];
}

-(void) pointsGottedListen{
    
    [self queryScore];
}

-(void) dealloc{
    
    [super dealloc];
    
}

@end
