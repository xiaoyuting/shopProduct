//
//  AddAddressVC.h
//  MeiRongBuyer
//
//  Created by 周大钦 on 16/1/7.
//  Copyright © 2016年 zdq. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QMapKit/QMapKit.h>

@interface AddAddressVC : BaseVC
@property (nonatomic,strong) SAddress *mAddress;
@property (nonatomic,strong) void(^block)(SAddress *address);
@property (weak, nonatomic) IBOutlet UIView *mMapView;
@property (weak, nonatomic) IBOutlet UITableView *mTableView;
@property (weak, nonatomic) IBOutlet UIView *mSearchView;
- (IBAction)searchClick:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *mImg;

@end
