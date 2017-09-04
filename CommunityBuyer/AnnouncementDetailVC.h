//
//  AnnouncementDetailVC.h
//  CommunityBuyer
//
//  Created by zy _cheng_mac on 16/1/21.
//  Copyright © 2016年 zdq. All rights reserved.
//

#import "BaseVC.h"

@interface AnnouncementDetailVC : BaseVC
@property (weak, nonatomic) IBOutlet UILabel *mTitle;//标题
@property (weak, nonatomic) IBOutlet UILabel *mTime;//时间
@property (weak, nonatomic) IBOutlet UILabel *mContent;//内容
@property (nonatomic,strong) SArticle* mSArticle;
@end
