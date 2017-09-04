//
//  UIView+SuperView.m
//  TakeOutIOSApp
//
//  Created by ljg on 14-10-10.
//
//

#import "UIView+SuperView.h"

@implementation UIView (SuperView)
- (UIView *)findSuperViewWithClass:(Class)superViewClass {

    UIView *superView = self.superview;
    UIView *foundSuperView = nil;

    while (nil != superView && nil == foundSuperView) {
        if ([superView isKindOfClass:superViewClass]) {
            foundSuperView = superView;
        } else {
            superView = superView.superview;
        }
    }
    return foundSuperView;
}
@end
