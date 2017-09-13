//
//  NavC.m
//  XiCheBuyer
//
//  Created by 周大钦 on 15/6/19.
//  Copyright (c) 2015年 zdq. All rights reserved.
//

#import "NavC.h"
#import "MainVC.h"
#import "OrderVC.h"
#import "OwnVC.h"
#import "ShopCarVC.h"

@interface NavC ()

@end

@implementation NavC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

- (int)indexOfTab{
    
    if ([self.viewControllers.firstObject isKindOfClass:[MainVC class]]) {
        return 0;
    }else if ([self.viewControllers.firstObject isKindOfClass:[ShopCarVC class]]){
        
        return 1;
    }
    else if ([self.viewControllers.firstObject isKindOfClass:[OrderVC class]]){
    
        return 2;
    }
    return 3;
    
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
