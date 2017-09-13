//
//  feedBackViewController.h
//  com.yizan.vso2o.business
//
//  Created by 密码为空！ on 15/4/24.
//  Copyright (c) 2015年 zy. All rights reserved.
//

#import "BaseVC.h"
#import "IQTextView.h"
@interface feedBackViewController : BaseVC<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *tijiaoBtn;
@property (weak, nonatomic) IBOutlet IQTextView *textView;

@end
