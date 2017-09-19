//
//  ViewController.m
//  RunTime
//
//  Created by qq on 2017/9/19.
//  Copyright © 2017年 fangxian. All rights reserved.
//

#import "ViewController.h"
#import <objc/runtime.h>

#import "AppDelegate+runtimeTest.h"
#import "TestTransmitView.h"

static const NSString *alertViewKey = @"alertViewKey";
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self method_exchangeImplementations];
    
    [self addMethodOne];
    
    
    [self TestTransmit];
    
}

//MARK: 交换方法
- (void)method_exchangeImplementations
{
    
    // 获取method1方法地址
    Method m1 = class_getInstanceMethod([self class], @selector(method1));
    
    // 获取method2方法地址
    Method m2 = class_getInstanceMethod([self class], @selector(method2));
    
    // 交换前   方法执行执行
    [self method1];
    [self method2];
    
    // 交换方法
    method_exchangeImplementations(m1, m2);
    
    // 交换后   方法执行执行
    [self method1];
    [self method2];
}

- (void)method1
{
    NSLog(@"%s", __func__);
}
- (void)method2
{
    NSLog(@"%s", __func__);
}


//MARK: 类\对象的关联对象  一：给分类添加属性
- (void)addMethodOne {
 
    [((AppDelegate*)[UIApplication sharedApplication].delegate) usingBlock:^(NSString *str){
        NSLog(@"str==%@",str);
    }];
    [((AppDelegate*)[UIApplication sharedApplication].delegate) test];
}

//MARK: 类\对象的关联对象  二：对象添加关联对象
- (void)addMethodTwo {
    UIAlertView *_alertView = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"This is deprecated?"
                                                        delegate:self
                                               cancelButtonTitle:@"Cancel"
                                               otherButtonTitles:@"Ok", nil];
    void (^block)(NSInteger) = ^(NSInteger buttonIndex){
        NSLog(@"buttonIndex==%ld,alertLeft",buttonIndex);
    };
    objc_setAssociatedObject(_alertView, (__bridge const void *)(alertViewKey), block, OBJC_ASSOCIATION_COPY);
    [_alertView show];
}

#pragma -mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    void (^block)(NSInteger) = objc_getAssociatedObject(alertView, (__bridge const void *)(alertViewKey));
    block(buttonIndex);
}

- (IBAction)alertLeft:(id)sender {
    [self addMethodTwo];
}
- (IBAction)alertRight:(id)sender {
    
    UIAlertView *_alertView = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"alertRight"
                                                        delegate:self
                                               cancelButtonTitle:@"Cancel"
                                               otherButtonTitles:@"Ok", nil];
    void (^block)(NSInteger) = ^(NSInteger buttonIndex){
        NSLog(@"buttonIndex==%ld,alertRight",buttonIndex);
    };
    objc_setAssociatedObject(_alertView, (__bridge const void *)(alertViewKey), block, OBJC_ASSOCIATION_COPY);
    [_alertView show];
}

//MARK: 动态添加方法
- (void)TestTransmit {
    
    TestTransmitView * view = [[TestTransmitView alloc] init];
    [view performSelector:@selector(show:) onThread:[NSThread currentThread] withObject:@"动态添加方法" waitUntilDone:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
