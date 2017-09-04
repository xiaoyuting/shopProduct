//
//  ActivityCell.h
//  PaoTuiBuyer
//
//  Created by 周大钦 on 15/8/7.
//  Copyright (c) 2015年 zdq. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ActivityCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *mBgView;
@property (weak, nonatomic) IBOutlet UIImageView *mImg;
@property (weak, nonatomic) IBOutlet UILabel *mName;
@property (weak, nonatomic) IBOutlet UILabel *mContent;
@property (weak, nonatomic) IBOutlet UILabel *mType;
@property (weak, nonatomic) IBOutlet UILabel *mTime;

@end
