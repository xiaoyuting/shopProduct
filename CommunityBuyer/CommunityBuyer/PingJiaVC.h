//
//  PingJiaVC.h
//  PaoTuiBuyer
//
//  Created by 周大钦 on 15/8/13.
//  Copyright (c) 2015年 zdq. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IQTextView.h"

@interface PingJiaVC : BaseVC

@property (nonatomic,assign) int    mGoodsId;
//@property (nonatomic,strong) SOrderInfo *mtagOrder;

@property (weak, nonatomic) IBOutlet UIButton *mBt1;
@property (weak, nonatomic) IBOutlet UIButton *mBt2;
@property (weak, nonatomic) IBOutlet UIButton *mBt3;
@property (weak, nonatomic) IBOutlet UIButton *mBt4;
@property (weak, nonatomic) IBOutlet UIButton *mBt5;

@property (nonatomic,strong) void(^itblock)(BOOL Pingjia);


@property (weak, nonatomic) IBOutlet IQTextView *mTextView;
@property (weak, nonatomic) IBOutlet UIButton *mCommitBT;
- (IBAction)CommitClick:(id)sender;
- (IBAction)mStarClick:(id)sender;

@end
