//
//  TabBarC.m
//  XiCheBuyer
//
//  Created by 周大钦 on 15/6/19.
//  Copyright (c) 2015年 zdq. All rights reserved.
//

#import "TabBarC.h"
#import "AppDelegate.h"

@interface TabBarC ()

@end

@implementation TabBarC


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    self.tabBar.tintColor = M_CO;
//    self.tabBar.tintColor = [UIColor redColor];
   
    UITabBarItem *item1 = [self.tabBar.items objectAtIndex:0];
    item1.selectedImage = [UIImage imageNamed:@"item1-1"];
    
    UITabBarItem *item2 = [self.tabBar.items objectAtIndex:1];
    item2.selectedImage = [UIImage imageNamed:@"item2-1"];
    
    
    UITabBarItem *item3 = [self.tabBar.items objectAtIndex:2];
    item3.selectedImage = [UIImage imageNamed:@"item5-1"];//生活圈
//    item3.selectedImage = [UIImage imageNamed:@"item3-1"];//订单
    
    UITabBarItem *item4 = [self.tabBar.items objectAtIndex:3];
    item4.selectedImage = [UIImage imageNamed:@"item4-1"];
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
