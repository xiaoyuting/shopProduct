//
//  myYouHuiJuan.h
//  CommunityBuyer
//
//  Created by zzl on 15/12/28.
//  Copyright © 2015年 zdq. All rights reserved.
//

#import "BaseVC.h"

@class SPromotion;

@interface myYouHuiJuan : BaseVC

@property (weak, nonatomic) IBOutlet UIView *mtopheader;

@property (weak, nonatomic) IBOutlet UITableView *mtable;

@property (weak, nonatomic) IBOutlet UITextField *minputcode;

@property (weak, nonatomic) IBOutlet UILabel *mallcount;

@property (nonatomic,assign)    BOOL        mselect;//选择优惠卷的时候
@property (nonatomic,assign) int    mSellerId;//选择优惠卷的时候
@property (nonatomic,assign) float    mMoney;//选择优惠卷的时候

@property (nonatomic,strong)    void(^mitblock)(SPromotion* selectobj);

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mtaboffsettop;



@end
