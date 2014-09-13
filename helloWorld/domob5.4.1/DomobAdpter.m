//
//  DomobAdpter.m
//  handleKiller
//
//  Created by yankai.peng on 14-9-13.
//
//

#import "DomobAdpter.h"
#import "AssetZoneManager.h"


@interface DomobAdpter()<AssetZoneManagerDelegate>

@property(nonatomic,assign) UIViewController *viewController;

@property(nonatomic,retain) AssetZoneManager* manage;

@property(nonatomic,assign) int m_score;

@end

@implementation DomobAdpter


-(id) initialize:(NSDictionary *)config window:(UIWindow *)window viewController:(UIViewController *)viewController{
    
    if((self=[super initialize:config window:window viewController:viewController])){
        
        self.platformName=@"Domob";
        self.isDidFinishInitialize=NO;
        self.viewController=viewController;
        self.m_score=0;
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
        
        AssetZoneManager *t=[[AssetZoneManager alloc] initWithPublisherID:appKey];
        self.manage=t;
        [t release];
        
        t.delegate=self;
        

        self.isDidFinishInitialize=YES;
    }
    return self;
}

-(void) show{
    
    [self.manage presentAssetZoneWithViewController:self.viewController type:eAssetZoneTypeList];
    
}

-(void) queryScore{
    
    [self.manage checkOwnedPoint];
    
}

- (void)azManager:(AssetZoneManager *)manager receivedTotalPoint:(NSNumber *)totalPoint totalConsumedPoint:(NSNumber *)consumedPoint{
    
    int score=totalPoint.intValue-consumedPoint.intValue;
    self.m_score=score;
    [self.manage consumeWithPointNumber:score];
    
}

- (void)azManager:(AssetZoneManager *)manager
                consumedWithStatusCode:(AssetZoneConsumeStatus)statusCode
                totalPoint:(NSNumber *)totalPoint
                totalConsumedPoint:(NSNumber *)consumedPoint{
    
    if(statusCode==eAssetZoneConsumeSuccess){
        
        [self expenseScore:self.m_score];
        self.m_score=0;
    }
    
}

-(void) expenseScore:(int)score{
    
    
    [super expenseScore:score];
}


-(void) dealloc{
    
    self.manage.delegate=nil;
    [_manage release];
    _manage=nil;
    [super dealloc];
    
}


@end
