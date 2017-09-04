//
//  AnnouncementVC.h
//  CommunityBuyer
//
//  Created by zy _cheng_mac on 16/1/21.
//  Copyright © 2016年 zdq. All rights reserved.
//

#import "BaseVC.h"

@interface AnnouncementVC : BaseVC
@property (weak, nonatomic) IBOutlet UITableView *mAnnounTable;


@property (nonatomic,assign)    int msellerid;
@end
