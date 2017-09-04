//
//  MapView.h
//  PaoTuiBuyer
//
//  Created by 周大钦 on 15/8/12.
//  Copyright (c) 2015年 zdq. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UITableView+DataSourceBlocks.h"
@class TableViewWithBlock;

@interface MapView : UIView

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mBottomHeight;
@property (weak, nonatomic) IBOutlet UIView *mProvinceView;
@property (weak, nonatomic) IBOutlet UILabel *mProvincelb;
@property (weak, nonatomic) IBOutlet UIButton *mProvinceBT;
@property (weak, nonatomic) IBOutlet UIView *mCityView;
@property (weak, nonatomic) IBOutlet UILabel *mCitylb;
@property (weak, nonatomic) IBOutlet UIButton *mCityBT;
@property (weak, nonatomic) IBOutlet UIView *mAreaView;
@property (weak, nonatomic) IBOutlet UILabel *mArealb;
@property (weak, nonatomic) IBOutlet UIButton *mAreaBT;
@property (weak, nonatomic) IBOutlet UIView *mDetailView;
@property (weak, nonatomic) IBOutlet UITextField *mDetailTF;
@property (retain, nonatomic) IBOutlet TableViewWithBlock *mProviceTB;
@property (retain, nonatomic) IBOutlet TableViewWithBlock *mCityTB;
@property (retain, nonatomic) IBOutlet TableViewWithBlock *mAreaTB;

+ (MapView *)shareView;

@end
