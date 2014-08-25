//
//  HWadapter.m
//  handleKiller
//
//  Created by yankai.peng on 14-8-19.
//
//

#import "HWAdapter.h"
#import "HelloWorldManage.h"

@interface HWAdapter()


@end

@implementation HWAdapter

-(id) initialize:(NSDictionary *)config window:(UIWindow *)window viewController:(UIViewController *)viewController{
    
    if(self=[super init]){
        
        self.showProbability=[[config objectForKey:@"showProbability"] intValue];
        if(self.showProbability<0 || self.showProbability>100){
            NSLog(@"平台随机几率配置错误，请检查");
            self.showProbability=0;
        }
    }
    
    return self;
}

-(void) queryScore{
    
}

-(void) expenseScore:(int)score{
    
    ///这里的消费实际上就是交由manage统一管理
    [[HelloWorldManage defaultManage] addScore:score];
}

-(void) show{
    
}

-(void) dismiss{
    
}

-(BOOL) canShow:(int) randomKey{
    
    if(randomKey>=self.randomMin && randomKey<self.randomMax){
        return YES;
    }
    
    return NO;
    
}


-(void) applicationDidBecomeActive{
    
    
}

-(void) applicationDidEnterBackground{
    
    
}

-(void) applicationWillEnterForeground{
    

    
}

-(void) applicationWillResignActive{
    
}


-(void) dealloc{
    
    [super dealloc];
    [self setPlatformName:nil];
    _platformName=nil;
}


@end
