//
//  AppDelegate.h
//  XiCheBuyer
//
//  Created by 周大钦 on 15/6/18.
//  Copyright (c) 2015年 zdq. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (assign,nonatomic) int selectIndex;





+(AppDelegate *)shareAppDelegate;

-(void)dealPush:(NSDictionary*)userinof bopenwith:(BOOL)bopenwith;

@end

