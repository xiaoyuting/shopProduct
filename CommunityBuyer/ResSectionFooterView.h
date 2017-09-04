//
//  ResSectionFooterView.h
//  CommunityBuyer
//
//  Created by 周大钦 on 15/11/23.
//  Copyright © 2015年 zdq. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ResSectionFooterView : UIView
@property (weak, nonatomic) IBOutlet UIButton *mNum;
@property (weak, nonatomic) IBOutlet UIImageView *mJiantou;

+ (ResSectionFooterView *)shareView;

@end
