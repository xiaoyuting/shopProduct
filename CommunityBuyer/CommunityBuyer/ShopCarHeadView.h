//
//  ShopCarHeadView.h
//  CommunityBuyer
//
//  Created by 周大钦 on 15/9/23.
//  Copyright © 2015年 zdq. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShopCarHeadView : UIView
@property (weak, nonatomic) IBOutlet UIButton *mCheck;
@property (weak, nonatomic) IBOutlet UILabel *mName;
@property (weak, nonatomic) IBOutlet UIButton *mbt;

+ (ShopCarHeadView *)shareView;

@end
