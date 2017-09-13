//
//  RepairDetailVC.m
//  CommunityBuyer
//
//  Created by zy _cheng_mac on 16/1/21.
//  Copyright © 2016年 zdq. All rights reserved.
//

#import "RepairDetailVC.h"
#import "ShowImagesView.h"

@interface RepairDetailVC ()

@end

@implementation RepairDetailVC

- (void)viewDidLoad {
    self.hiddenTabBar = YES;
    [super viewDidLoad];
    self.mPageName = @"报修纪录";
    self.Title = self.mPageName;
    
    
    
    _mTitle.text=_mSRepair.mRepairType;
    
    _mTime.text=_mSRepair.mCreateTime;
    
    _mContent.text=_mSRepair.mContent;
    
    _mState.text=_mSRepair.mStatusStr;
    
    
    

    
    
}





- (void)viewDidLayoutSubviews{
    
    

    

}

- (void)viewWillLayoutSubviews{
    

}

- (void)viewWillDisappear:(BOOL)animated{
}

- (void)viewDidAppear:(BOOL)animated{
    if (_mSRepair.mImages.count>0) {
        
        [_mimgView showMoreImage:_mSRepair.mImages position:3 returnHeight:^(CGFloat height,UIView *view){
            
            _mimgViewHeight.constant=height;
            
            
        }];
        
        
    }else{
        
        _mimgViewHeight.constant=0;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
