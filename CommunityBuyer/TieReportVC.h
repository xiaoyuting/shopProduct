//
//  TieReportVC.h
//  CommunityBuyer
//
//  Created by zzl on 16/1/26.
//  Copyright © 2016年 zdq. All rights reserved.
//

#import "BaseVC.h"

@class IQTextView;
@interface TieReportVC : BaseVC
@property (weak, nonatomic) IBOutlet IQTextView *mcontenbt;

@property (nonatomic,strong) SForumPosts*   mtagPost;
@end
