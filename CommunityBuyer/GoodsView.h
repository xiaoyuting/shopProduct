//
//  GoodsView.h
//  PaoTuiBuyer
//
//  Created by 周大钦 on 15/8/13.
//  Copyright (c) 2015年 zdq. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GoodsView : UIView

@property (weak, nonatomic) IBOutlet UIImageView *mImg;
@property (weak, nonatomic) IBOutlet UILabel *mName;
@property (weak, nonatomic) IBOutlet UILabel *mNum;
@property (weak, nonatomic) IBOutlet UILabel *mPrice;

@property (weak, nonatomic) IBOutlet UIView *mLine;

@property (weak, nonatomic) IBOutlet UILabel *mServiceTime;
@property (weak, nonatomic) IBOutlet UILabel *mServiceName;
@property (weak, nonatomic) IBOutlet UILabel *mPhone;

+ (GoodsView *)shareView;

+ (GoodsView *)shareViewTwo;
@end
