//
//  LocCell.h
//  YiZanService
//
//  Created by zzl on 15/3/25.
//  Copyright (c) 2015年 zywl. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CunsomLabel;
@interface LocCell : UITableViewCell
@property (weak, nonatomic) IBOutlet CunsomLabel* maddress;
@property (weak, nonatomic) IBOutlet UIImageView *marrow;
@property (weak, nonatomic) IBOutlet UIImageView *mloccion;

@end
