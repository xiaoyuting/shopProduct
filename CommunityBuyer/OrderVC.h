//
//  OrderVC.h
//  XiCheBuyer
//
//  Created by 周大钦 on 15/6/18.
//  Copyright (c) 2015年 zdq. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderVC : BaseVC

@property (weak, nonatomic) IBOutlet UIView *topView;

//+ (void)GoOrderDetailAnimation:(BOOL)isAnimation andOrder:(SOrderInfo *)order andBase:(BaseVC *)base;
@property (weak, nonatomic) IBOutlet UIButton *mLeftBT;
@property (weak, nonatomic) IBOutlet UIButton *mMiddleBT;

- (IBAction)TopClick:(id)sender;

@end
