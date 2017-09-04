//
//  messageDetailView.h
//  com.yizan.vso2o.business
//
//  Created by 密码为空！ on 15/4/17.
//  Copyright (c) 2015年 zy. All rights reserved.
//

#import "BaseVC.h"

@interface messageDetailView : BaseVC
@property (weak, nonatomic) IBOutlet UILabel *msgTitle;
@property (weak, nonatomic) IBOutlet UILabel *msgTimeLb;
@property (weak, nonatomic) IBOutlet UILabel *msgContentLb;

@property (weak, nonatomic) IBOutlet UIView *bottomLineView;
@property (strong,nonatomic) SMessageInfo *msgObj;
@end
