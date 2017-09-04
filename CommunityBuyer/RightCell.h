//
//  RightCell.h
//  XiCheBuyer
//
//  Created by 周大钦 on 15/7/16.
//  Copyright (c) 2015年 zdq. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StrikeThroughLabel.h"
#import "RTLabel.h"
#import "CellButton.h"
#import "DetailTextView.h"

@interface RightCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *mName;
@property (weak, nonatomic) IBOutlet UILabel *mPrice;
@property (weak, nonatomic) IBOutlet SImageView *mImg;
@property (weak, nonatomic) IBOutlet UILabel *mNormName;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mDetailHeight;
@property (weak, nonatomic) IBOutlet UILabel *mXiaoLiang;


@property (weak, nonatomic) IBOutlet CellButton *mAddButton;
@property (weak, nonatomic) IBOutlet CellButton *mDelButton;
@property (weak, nonatomic) IBOutlet UILabel *mNum;



@end
