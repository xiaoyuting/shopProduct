//
//  AnnouncementCell.h
//  CommunityBuyer
//
//  Created by zy _cheng_mac on 16/1/21.
//  Copyright © 2016年 zdq. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AnnouncementCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *mRedPoint;//红点
@property (weak, nonatomic) IBOutlet UILabel *mTitle;//标题
@property (weak, nonatomic) IBOutlet UILabel *mContent;//内容
@property (weak, nonatomic) IBOutlet UILabel *mTime;//时间
@property (weak, nonatomic) IBOutlet UIButton *mCheckMore;//查看更多
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mTitleToLeadWidth;//标题到左边的距离  当红点隐藏时使用

@end
