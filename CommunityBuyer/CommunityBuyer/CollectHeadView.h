//
//  CollectHeadView.h
//  CommunityBuyer
//
//  Created by 周大钦 on 15/9/21.
//  Copyright © 2015年 zdq. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CollectHeadView : UIView
@property (weak, nonatomic) IBOutlet UIView *mBgView;
@property (weak, nonatomic) IBOutlet UIImageView *mBgImg;
@property (weak, nonatomic) IBOutlet UIButton *mLeft;
@property (weak, nonatomic) IBOutlet UIButton *mRight;

+ (CollectHeadView *)shareView;

@end
