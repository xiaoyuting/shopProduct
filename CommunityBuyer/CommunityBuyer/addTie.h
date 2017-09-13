//
//  addTie.h
//  CommunityBuyer
//
//  Created by zzl on 15/12/31.
//  Copyright © 2015年 zdq. All rights reserved.
//

#import "BaseVC.h"
@class IQTextView;
@interface addTie : BaseVC

@property (weak, nonatomic) IBOutlet UITextField *msendto;

@property (weak, nonatomic) IBOutlet UITextField *mtitl;

@property (weak, nonatomic) IBOutlet IQTextView *mcontent;

@property (weak, nonatomic) IBOutlet UIView *mimagewapre;


@property (weak, nonatomic) IBOutlet UIView *mbottomwaper;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mwaperhi;
@property (weak, nonatomic) IBOutlet UIView *maddwaper;
@property (weak, nonatomic) IBOutlet UIView *maddedwaper;


@property (weak, nonatomic) IBOutlet UILabel *mtel;
@property (weak, nonatomic) IBOutlet UILabel *maddr;
@property (weak, nonatomic) IBOutlet UILabel *mname;


@property (nonatomic,strong)    SForumPosts*    mtagPost;

@property (nonatomic,strong)    SForumPlate*    mtagPlate;


@end
