//
//  UIView+SuperView.h
//  TakeOutIOSApp
//
//  Created by ljg on 14-10-10.
//
//

#import <UIKit/UIKit.h>

@interface UIView (SuperView)
- (UIView *)findSuperViewWithClass:(Class)superViewClass;

@end
