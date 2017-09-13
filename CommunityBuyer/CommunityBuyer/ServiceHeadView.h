//
//  ServiceHeadView.h
//  CommunityBuyer
//
//  Created by 周大钦 on 15/9/23.
//  Copyright © 2015年 zdq. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ServiceHeadView : UIView
@property (weak, nonatomic) IBOutlet UIView *mTopView;
@property (weak, nonatomic) IBOutlet SImageView *mImg;
@property (weak, nonatomic) IBOutlet UILabel *mName;
@property (weak, nonatomic) IBOutlet UILabel *mTime;
@property (weak, nonatomic) IBOutlet UIButton *mButton;



+ (ServiceHeadView *)shareView;

@end
