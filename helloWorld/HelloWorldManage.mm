//
//  HelloWorldTools.m
//  handleKiller
//
//  Created by yankai.peng on 14-8-19.
//
//

#import "HelloWorldManage.h"
#import "MobClickCpp.h"
#import "HWAdapter.h"

@interface HelloWorldManage ()


/**
 用于给各平台配置随机因子的计数器
 */
@property(nonatomic,assign) int randomCount;
@end

@implementation HelloWorldManage


+(HelloWorldManage *)defaultManage:(bool)reViewSwitch window:(UIWindow *)window viewController:(UIViewController *)viewController{
    
    if(__hw_instance==nil){
        
        __hw_instance=[[HelloWorldManage alloc] init];
        __hw_instance.reviewFalg=reViewSwitch;
        __hw_instance.window=window;
        __hw_instance.viewController=viewController;
        
        assert(window!=nil);
        assert(viewController!=nil);
        
        [__hw_instance work];
    }
    
    return __hw_instance;
}

/**
 程序开始时
 */
+(HelloWorldManage *) defaultManage{
    
    ///需要在第一次使用是调用
    /*
     
     +(HelloWorldManage *)defaultManage:(bool)reViewSwitch window:(UIWindow *)window viewController:(UIViewController *)viewController
     
     */
    return __hw_instance;
}

-(id) init{
    
    if(self=[super init]){
        
        self.reviewFalg=true;
    }
    
    return self;
    
}

-(void) work{
    
    
    if(self.reviewFalg) return;
    
    self.randomCount=0;
    self.isDidFinishLoadConfig=NO;
    
    [self loadConfigData];
    
}

-(void) reWork{
    
    
    if(self.isDidFinishLoadConfig || self.reviewFalg==false) return;
    
    self.reviewFalg=false;
    
    [self work];
    
}

-(void) loadConfigData{

    
    /**
     
     本套聚合仅内部使用，故任依赖于UMeng，需使用UMeng在线参数。
     若使用本套聚合，仅针对项目对loadConfigData方法修改，能获得数据即可。
     
     若使用的是C++版本的mobclick那么需要将本类文件名后缀改为.mm以支持oc/c++混编
     
     **/
    
    
    string jsonString= MobClickCpp::getConfigParams("wallConfig");
    
    
    if(jsonString==""){//读取默认配置
        
        NSStringEncoding encoding=NSUTF8StringEncoding;
        NSString *path= [[[NSBundle mainBundle] resourcePath] stringByAppendingString:@"/HWdefaultConfig.txt"];
        NSString *str= [NSString stringWithContentsOfFile:path usedEncoding:&encoding  error:nil];
        
        
        if(str!=nil && [str length]!=0){
            
            jsonString=[str cStringUsingEncoding:NSUTF8StringEncoding];
        }
        
    }
    
    if(jsonString=="") return;
    
    
    NSString *tStr=[NSString stringWithUTF8String:jsonString.c_str()];
    NSData *tData=[tStr dataUsingEncoding:NSUTF8StringEncoding];
    
    NSError *err=nil;
    NSDictionary* config=[NSJSONSerialization JSONObjectWithData:tData options:NSJSONReadingAllowFragments error:&err];
    if(config!=nil && err==nil){
        self.configData=config;
        self.isDidFinishLoadConfig=YES;
        [self initializePlatform];
        NSLog(@"%@",config);
    }else{
        
        NSLog(@"loadConfigData:数据格式错误!");
    }
   
}

-(void) initializePlatform{
    
    
    if(self.reviewFalg) return;
    
    
    ///初始化数组
    NSMutableArray *tArr=[[NSMutableArray alloc] init];
    self.platformsArr=tArr;
    [tArr release];
    
    NSArray *platformArr=[self.configData objectForKey:@"platforms"];
    for(NSDictionary *platformConfig in platformArr){
        
        NSString *name=[((NSString *)[platformConfig objectForKey:@"platformName"]) stringByAppendingString:@"Adpter"];
        Class classForName=NSClassFromString(name);
        
        HWAdapter *platAdpter=[[classForName alloc] initialize:platformConfig window:self.window viewController:self.viewController];
        
        if(platAdpter==nil){
            
            NSLog(@"%@ 找不到此类",name);
            continue;
        }
        
        /**
         根据配置打开原理是：根据配置的几率值得到一个类30-60的这样一个区间，最大100最小0，其区间的差就是百分之多少。 show时得到一个key，若key在某个平台
         random区间，则表明随机选中。 各平台区间不交叉。
         */
        platAdpter.randomMin=self.randomCount;
        self.randomCount+=platAdpter.showProbability;
        platAdpter.randomMax=self.randomCount;
        
        ////////
        [self.platformsArr addObject:platAdpter];
        [platAdpter release];
        
    }
    
}

-(void) addScore:(int)score{
    
    int t=[[NSUserDefaults standardUserDefaults] integerForKey:@"HWSCORERECODE"];
    t+=score;
    [[NSUserDefaults standardUserDefaults] setInteger:t forKey:@"HWSCORERECODE"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(int) queryScore{
    
    if(self.reviewFalg) return 0;
    
    for(HWAdapter *adpter in self.platformsArr){//让所以平台查询积分
        [adpter queryScore];
    }
    
    int t=[[NSUserDefaults standardUserDefaults] integerForKey:@"HWSCORERECODE"];
    return t;
}

-(void) expenseScore:(int)score{
    int t=[[NSUserDefaults standardUserDefaults] integerForKey:@"HWSCORERECODE"];
    t-=score;
    [[NSUserDefaults standardUserDefaults] setInteger:t forKey:@"HWSCORERECODE"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

-(void) show:(NSString *)platName{
    
    if(self.reviewFalg) return;
    
    
    for(HWAdapter *adpter in self.platformsArr){//遍历所以已经初始化的平台，找到想要打开的。
        
        
        if([adpter.platformName isEqualToString:platName]){
            
            [adpter show];
            NSLog(@"now show:%@",platName);
            return;
        }
    }
    
    NSLog(@"想要显示的平台并没有初始化");
}

-(void) show{
    
    if(self.reviewFalg) return;
    
    int key=arc4random()%100;
    for(HWAdapter *adpter in self.platformsArr){//遍历所以已经初始化的平台，找到想要打开的。
        
        if([adpter canShow:key]){
            
            [adpter show];
            NSLog(@"now show:%@",adpter.platformName);
            return;
        }
    }
    NSLog(@"并没有初始化任何平台");
}

-(void) applicationDidBecomeActive{
    
    if(self.reviewFalg) return;
    
    for(HWAdapter *adpter in self.platformsArr){
        
        [adpter applicationDidBecomeActive];
    }
    
}

-(void) applicationDidEnterBackground{
    
    if(self.reviewFalg) return;
    
    for(HWAdapter *adpter in self.platformsArr){
        
        [adpter applicationDidEnterBackground];
    }
    
}

-(void) applicationWillEnterForeground{
    
    if(self.reviewFalg) return;
    
    for(HWAdapter *adpter in self.platformsArr){
        
        [adpter applicationWillEnterForeground];
    }
    
}

-(void) applicationWillResignActive{
    
    if(self.reviewFalg) return;
    
    for(HWAdapter *adpter in self.platformsArr){
        
        [adpter applicationWillResignActive];
    }
}


-(void) dealloc{
    
    [super dealloc];
    [self setConfigData:nil];
    _configData=nil;
    [self setPlatformsArr:nil];
    _platformsArr=nil;
    
}

@end
