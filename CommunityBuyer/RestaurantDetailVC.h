//
//  RestaurantDetailVC.h
//  XiCheBuyer
//
//  Created by 周大钦 on 15/7/16.
//  Copyright (c) 2015年 zdq. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RestaurantDetailVC : BaseVC

@property (nonatomic,strong) SSeller *mSeller;


@property (weak, nonatomic) IBOutlet UIView *mTopView;
@property (weak, nonatomic) IBOutlet UIButton *mLeftBT;
@property (weak, nonatomic) IBOutlet UIButton *mMiddleBT;
@property (weak, nonatomic) IBOutlet UIButton *mRightBT;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mAdvHeight;
@property (weak, nonatomic) IBOutlet UIView *mAdvView;



@property (weak, nonatomic) IBOutlet UIButton *mCarBt;
@property (weak, nonatomic) IBOutlet UITableView *mLeftTableV;
@property (weak, nonatomic) IBOutlet UITableView *mRightTableV;
@property (weak, nonatomic) IBOutlet UIView *mBottomV;
@property (weak, nonatomic) IBOutlet UILabel *mSumPrice;
@property (weak, nonatomic) IBOutlet UIButton *mSuccess;
- (IBAction)CarClick:(id)sender;
- (IBAction)GoPlaceClick:(id)sender;

- (IBAction)mTopClick:(id)sender;

@property (weak, nonatomic) IBOutlet UIView *mGoodsView;


@end
