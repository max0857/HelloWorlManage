//
//  AnAdpter.h
//  handleKiller
//
//  Created by yankai.peng on 14-8-22.
//
//

#import "HWAdapter.h"

@interface AnAdpter : HWAdapter


-(id) initialize:(NSDictionary *)config window:(UIWindow *)window viewController:(UIViewController *)viewController;

-(void) show;

-(void) queryScore;

-(void) expenseScore:(int)score;

@end
