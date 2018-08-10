//
//  UIApplication+EventAutomator.m
//  TestCrashReport
//
//  Created by Administrator on 2017. 4. 7..
//  Copyright © 2017년 Administrator. All rights reserved.
//

#import "UIApplication+EventAutomator.h"
#import <objc/runtime.h>

@implementation UIApplication (EventAutomator)

//스위즐링
+ (void)load {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];

        SEL originalSelector = @selector(sendAction:to:from:forEvent:);
        SEL swizzledSelector = @selector(runtime_sendAction:to:from:forEvent:);

        Method originalMethod = class_getInstanceMethod(class, originalSelector);
        Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);

        method_exchangeImplementations(originalMethod, swizzledMethod);
    });
}

- (BOOL)runtime_sendAction:(SEL)action to:(id)target from:(id)sender forEvent:(UIEvent *)event {
    NSString *selectorName = NSStringFromSelector(action);
    
    if (![selectorName isEqualToString:@"_sendAction:withEvent:"]) {
        NSLog(@"%s 클래스의 %s 메소드 이벤트 발생.\n", class_getName([target class]), [selectorName UTF8String]);
    }
    
    return [self runtime_sendAction:action to:target from:sender forEvent:event];
}





@end
