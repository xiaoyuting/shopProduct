//
//  ChoseAreaVC.h
//  CommunityBuyer
//
//  Created by 周大钦 on 15/11/23.
//  Copyright © 2015年 zdq. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TableViewWithBlock.h"

@interface ChoseAreaVC : BaseVC

@property (nonatomic,strong) void(^itblock)(SProvince *p,SProvince *c,SProvince *a);

@property (nonatomic,strong) SProvince *pp;
@property (nonatomic,strong) SProvince *cp;
@property (nonatomic,strong) SProvince *ap;

@property (weak, nonatomic) IBOutlet UIButton *mProvice;
@property (weak, nonatomic) IBOutlet UIButton *mCity;
@property (weak, nonatomic) IBOutlet UIButton *mArea;
@property (weak, nonatomic) IBOutlet UIImageView *mProviceImg;
@property (weak, nonatomic) IBOutlet UIImageView *mCityImg;
@property (weak, nonatomic) IBOutlet UIImageView *mAreaImg;

@property (weak, nonatomic) IBOutlet TableViewWithBlock *mProviceTable;
@property (weak, nonatomic) IBOutlet TableViewWithBlock *mCityTable;
@property (weak, nonatomic) IBOutlet TableViewWithBlock *mAreaTable;
- (IBAction)mProviceClick:(id)sender;
- (IBAction)mCityClick:(id)sender;
- (IBAction)mAreaClick:(id)sender;

@end
