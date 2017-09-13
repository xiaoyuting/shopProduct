//
//  PayView.h
//  CommunityBuyer
//
//  Created by 周大钦 on 15/11/23.
//  Copyright © 2015年 zdq. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PayView : BaseVC

@property (nonatomic,strong) SOrderObj *mTagOrder;

@property (weak, nonatomic) IBOutlet UIView *mPayView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mPayViewHeight;
@property (weak, nonatomic) IBOutlet UIButton *mPayBT;
- (IBAction)mGoPayClick:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *mshopname;
@property (weak, nonatomic) IBOutlet UILabel *mmoney;
@property (nonatomic,copy)NSString    * type;


@end
