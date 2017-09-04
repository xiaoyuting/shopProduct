//
//  CmmVC.h
//  CommunityBuyer
//
//  Created by zzl on 15/10/10.
//  Copyright © 2015年 zdq. All rights reserved.
//

#import "BaseVC.h"
@class  SOrderObj;
@class  IQTextView;
@interface CmmVC : BaseVC


@property (weak, nonatomic) IBOutlet UIScrollView *mscrollwarp;


@property (weak, nonatomic) IBOutlet UIView *mtopwarp;

@property (weak, nonatomic) IBOutlet UIView *mscorewarp;
@property (weak, nonatomic) IBOutlet UIView *mcheckwarp;

@property (weak, nonatomic) IBOutlet UILabel *morderNum;
@property (weak, nonatomic) IBOutlet UILabel *malltext;

@property (weak, nonatomic) IBOutlet IQTextView *mtext;

@property (weak, nonatomic) IBOutlet UIView *mimagewarp;
@property (weak, nonatomic) IBOutlet UIImageView *mcheck;

@property (weak, nonatomic) IBOutlet UIButton *msubmit;


@property (nonatomic,strong) SOrderObj* mtagOrder;


@end
