//
//  AppDelegate+runtimeTest.h
//  RunTime
//
//  Created by qq on 2017/9/19.
//  Copyright © 2017年 fangxian. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate (runtimeTest)

typedef void(^block)();
- (void)usingBlock:(block)block;
- (void)test;
@end
