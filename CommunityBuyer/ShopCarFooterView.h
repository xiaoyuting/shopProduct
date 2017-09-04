//
//  ShopCarFooterView.h
//  CommunityBuyer
//
//  Created by 周大钦 on 15/9/23.
//  Copyright © 2015年 zdq. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShopCarFooterView : UIView
@property (weak, nonatomic) IBOutlet DYMainLabel *mPrice;
@property (weak, nonatomic) IBOutlet UILabel *mYunFei;
@property (weak, nonatomic) IBOutlet UIButton *mJieSuan;

+ (ShopCarFooterView *)shareView;

@end
