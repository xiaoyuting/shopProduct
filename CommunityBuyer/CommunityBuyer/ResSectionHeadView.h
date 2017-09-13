//
//  ResSectionHeadView.h
//  CommunityBuyer
//
//  Created by 周大钦 on 15/11/23.
//  Copyright © 2015年 zdq. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ResSectionHeadView : UIView
@property (weak, nonatomic) IBOutlet UILabel *mText;

+ (ResSectionHeadView *)shareView;

@end
