//
//  PhoneCell.h
//  PaoTuiBuyer
//
//  Created by 周大钦 on 15/8/12.
//  Copyright (c) 2015年 zdq. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWTableViewCell.h"

@interface PhoneCell : SWTableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *mCheckImg;
@property (weak, nonatomic) IBOutlet UILabel *mPhone;

@end
