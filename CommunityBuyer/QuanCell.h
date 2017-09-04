//
//  QuanCell.h
//  CommunityBuyer
//
//  Created by zzl on 15/12/30.
//  Copyright © 2015年 zdq. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWTableViewCell.h"

@interface QuanCell : SWTableViewCell

@property (weak, nonatomic) IBOutlet UILabel *mtitle;

@property (weak, nonatomic) IBOutlet UILabel *msubtitle;

@property (weak, nonatomic) IBOutlet UILabel *mtime;
@property (weak, nonatomic) IBOutlet UILabel *mcount;

@end
