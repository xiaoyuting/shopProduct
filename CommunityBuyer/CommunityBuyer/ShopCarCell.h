//
//  ShopCarCell.h
//  CommunityBuyer
//
//  Created by 周大钦 on 15/9/22.
//  Copyright © 2015年 zdq. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShopCarCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *mChoseBT;
@property (weak, nonatomic) IBOutlet UIImageView *mImg;
@property (weak, nonatomic) IBOutlet UILabel *mGoodsName;
@property (weak, nonatomic) IBOutlet DYMainLabel *mPrice;
@property (weak, nonatomic) IBOutlet UIButton *mDelBT;
@property (weak, nonatomic) IBOutlet UILabel *mNum;
@property (weak, nonatomic) IBOutlet UIButton *mJianBT;
@property (weak, nonatomic) IBOutlet UIButton *mJiaBT;


@end
