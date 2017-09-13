//
//  TieDetailVC.h
//  CommunityBuyer
//
//  Created by zzl on 16/1/8.
//  Copyright © 2016年 zdq. All rights reserved.
//

#import "BaseVC.h"

@class ZWImageWaperView;
@class IQTextView;
@interface TieDetailVC : BaseVC


@property (nonatomic,strong)    SForumPosts*    mtagPost;

@property (weak, nonatomic) IBOutlet UITableView *mtabview;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *minputconsth;
@property (weak, nonatomic) IBOutlet IQTextView *minputreback;


@end
