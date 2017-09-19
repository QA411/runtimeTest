//
//  TestTransmitView.m
//  RunTime
//
//  Created by qq on 2017/9/19.
//  Copyright © 2017年 fangxian. All rights reserved.
//

#import "TestTransmitView.h"
#import <objc/message.h>

@implementation Delegate

-(void)show:(NSString *)str
{
    NSLog(@"转发给Delegate的方法");
}

@end

@implementation TestTransmitView

void dynamic_show(id self,SEL _cmd,id param1)
{
    NSLog(@"sssssssssssssssssssssssssssssssssssssssss实例方法 参数：%@",param1);
}

/**
 *  当调用了没有实现的方法没有实现就会调用
 *
 *  @param sel 没有实现方法
 *
 *  @return 如果方法被发现并添加return：Yes 否则NO
 */
+(BOOL)resolveInstanceMethod:(SEL)sel
{
    if (sel == @selector(show:)) {
        //        class_addMethod([self class],sel,(IMP)dynamic_show,"v@:@");
        return NO;
    }
    return [super resolveInstanceMethod:sel];
    
}

- (void)forwardInvocation:(NSInvocation *)anInvocation
{
    SEL sel = [anInvocation selector];
    
    Delegate * delegate = [[Delegate alloc] init];
    if ([delegate respondsToSelector:sel]) {
        [anInvocation invokeWithTarget:delegate];
    }
    else {
        [super forwardInvocation:anInvocation];
    }
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    return [Delegate instanceMethodSignatureForSelector:aSelector];
}


@end
