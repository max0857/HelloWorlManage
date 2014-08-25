//
//  ChuKongAdpter.h
//  handleKiller
//
//  Created by yankai.peng on 14-8-20.
//
//

#import "HWAdapter.h"

@interface ChuKongAdpter : HWAdapter


-(id) initialize:(NSDictionary *)config window:(UIWindow *)window viewController:(UIViewController *)viewController;

-(void) show;

-(void) queryScore;

-(void) expenseScore:(int)score;


@end
