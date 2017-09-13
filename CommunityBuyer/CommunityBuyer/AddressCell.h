//
//  AddressCell.h
//  YiZanService
//
//  Created by ljg on 15-3-23.
//  Copyright (c) 2015年 zywl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWTableViewCell.h"

@interface AddressCell : SWTableViewCell
@property (weak, nonatomic) IBOutlet UILabel *mAddress;
@property (weak, nonatomic) IBOutlet UILabel *mPhone;

@property (weak, nonatomic) IBOutlet UILabel *mName;
@property (weak, nonatomic) IBOutlet UIImageView *mTopTiao;

@property (weak, nonatomic) IBOutlet UIImageView *mBottomTiao;

@property (weak, nonatomic) IBOutlet UIImageView *mJiantou;
@property (weak, nonatomic) IBOutlet UILabel *mNoAddress;

@end
