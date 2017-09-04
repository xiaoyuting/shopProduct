//
//  PayStateVC.h
//  CommunityBuyer
//
//  Created by 周大钦 on 15/9/22.
//  Copyright © 2015年 zdq. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PayStateVC : BaseVC

@property (nonatomic,assign) BOOL mIsOK;

@property (nonatomic,strong) NSString *mPayType;
@property (nonatomic,strong) SOrderObj *mTOrder;
@property (weak, nonatomic) IBOutlet UILabel *mToplb;
@property (weak, nonatomic) IBOutlet UIImageView *mImg;
@property (weak, nonatomic) IBOutlet UILabel *mlab1;
@property (weak, nonatomic) IBOutlet UIButton *mBT;
@property (weak, nonatomic) IBOutlet UILabel *mlab2;
- (IBAction)goGuang:(id)sender;

@end
