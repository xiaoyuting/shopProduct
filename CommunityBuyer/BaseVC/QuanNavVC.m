//
//  QuanNavVC.m
//  CommunityBuyer
//
//  Created by zzl on 16/1/5.
//  Copyright © 2016年 zdq. All rights reserved.
//

#import "QuanNavVC.h"
#import "QuanVC.h"

@interface QuanNavVC ()

@end

@implementation QuanNavVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSMutableArray* t = NSMutableArray.new;
    [t addObject: [[QuanVC alloc]initWithNibName:@"QuanVC" bundle:nil]];
    [self setViewControllers:t];
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
