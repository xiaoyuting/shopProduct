//
//  NavC.h
//  XiCheBuyer
//
//  Created by 周大钦 on 15/6/19.
//  Copyright (c) 2015年 zdq. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NavC : UINavigationController

@property (nonatomic,strong) UITabBarController *TabBar;

- (int)indexOfTab;

@end
