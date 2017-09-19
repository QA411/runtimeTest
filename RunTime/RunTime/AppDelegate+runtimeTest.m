//
//  AppDelegate+runtimeTest.m
//  RunTime
//
//  Created by qq on 2017/9/19.
//  Copyright © 2017年 fangxian. All rights reserved.
//

#import "AppDelegate+runtimeTest.h"
#import <objc/runtime.h>

static const NSString *blockKey = @"keyBlock";

@implementation AppDelegate (runtimeTest)

- (void)setBlock:(block)block {
    objc_setAssociatedObject(self, &blockKey, block, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (block)block {
    return objc_getAssociatedObject(self, &blockKey);
}

- (void)usingBlock:(block)block {
    self.block = [block copy];
}

- (void)test {
   self.block(@"绑定Block成功");
}

@end
