//
//  AnnouncementDetailVC.m
//  CommunityBuyer
//
//  Created by zy _cheng_mac on 16/1/21.
//  Copyright © 2016年 zdq. All rights reserved.
//

#import "AnnouncementDetailVC.h"

@interface AnnouncementDetailVC ()

@end

@implementation AnnouncementDetailVC

- (void)viewDidLoad {
    self.hiddenTabBar = YES;
    [super viewDidLoad];
    self.mPageName = @"社区公告详情";
    self.Title = self.mPageName;
    
    
    _mTitle.text=_mSArticle.mTitle;
    _mTime.text=_mSArticle.mCreateTime;
    _mContent.text=_mSArticle.mContent;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
