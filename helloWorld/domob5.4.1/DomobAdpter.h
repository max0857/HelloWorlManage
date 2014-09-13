//
//  DomobAdpter.h
//  handleKiller
//
//  Created by yankai.peng on 14-9-13.
//
//

#import "HWAdapter.h"

@interface DomobAdpter : HWAdapter

-(id) initialize:(NSDictionary *)config window:(UIWindow *)window viewController:(UIViewController *)viewController;

-(void) show;

-(void) queryScore;

-(void) expenseScore:(int)score;

@end
