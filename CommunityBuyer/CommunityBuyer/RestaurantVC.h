//
//  RestaurantVC.h
//  PaoTuiBuyer
//
//  Created by 周大钦 on 15/8/10.
//  Copyright (c) 2015年 zdq. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UITableView+DataSourceBlocks.h"
#import "TableViewWithBlock.h"

@interface RestaurantVC : BaseVC
@property (weak, nonatomic) IBOutlet UITableView *mTableView;

@property (nonatomic,assign) int mGoodsId;
@property (nonatomic,assign) int mType;
@property (nonatomic,strong) NSString *mGoodsName;
@property (weak, nonatomic) IBOutlet UIButton *mLeftBT;
@property (weak, nonatomic) IBOutlet UIButton *mRightBT;
@property (weak, nonatomic) IBOutlet UIView *mHeadView;
@property (retain, nonatomic) IBOutlet TableViewWithBlock *mLeftTable;
@property (retain, nonatomic) IBOutlet TableViewWithBlock *mRightTable;

@property (nonatomic,strong)    NSString*       mKeywords;
@property (weak, nonatomic) IBOutlet UIImageView *mLeftJiantou;
@property (weak, nonatomic) IBOutlet UIImageView *mRightJiantou;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mRightTableHeight;

@end
