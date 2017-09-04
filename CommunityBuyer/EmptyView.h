//
//  EmptyView.h
//  PaoTuiBuyer
//
//  Created by 周大钦 on 15/8/20.
//  Copyright (c) 2015年 zdq. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EmptyView : UIView

@property (weak, nonatomic) IBOutlet UIImageView *mImg;
@property (weak, nonatomic) IBOutlet UILabel *mLabel;
@property (weak, nonatomic) IBOutlet UIButton *mButton;


+ (EmptyView *)shareView;

+ (EmptyView *)shareView2;

@end
