//
//  ShopCarView.h
//  JiaZhengBuyer
//
//  Created by 周大钦 on 15/7/22.
//  Copyright (c) 2015年 zdq. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShopCarView : UIView
@property (weak, nonatomic) IBOutlet UILabel *mName;
@property (weak, nonatomic) IBOutlet UILabel *mPrice;
@property (weak, nonatomic) IBOutlet UIButton *mJianBt;
@property (weak, nonatomic) IBOutlet UILabel *mNum;
@property (weak, nonatomic) IBOutlet UIButton *mJiaBt;

+(ShopCarView *)shareView;

@end
