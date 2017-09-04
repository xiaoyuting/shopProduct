//
//  UIView+Additions.m
//  7. 事件响应传递
//
//  Created by HCW on 14-3-15.
//  Copyright (c) 2014年 HCW. All rights reserved.
//

#import "UIView+Additions.h"

@implementation UIView (Additions)

-(UIViewController *)viewController
{
    //下一个响应者
    UIResponder *next=[self nextResponder];
    
    do {
        if ([next isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)next;
        }
        
        next=[next nextResponder];
        
    } while (next!=nil);
    
    return nil;
}

@end
