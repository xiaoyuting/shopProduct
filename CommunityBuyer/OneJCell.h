//
//  OneJCell.h
//  CommunityBuyer
//
//  Created by zzl on 15/12/28.
//  Copyright © 2015年 zdq. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OneJCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *mPrcie;
@property (weak, nonatomic) IBOutlet UILabel *mexttime;

@property (weak, nonatomic) IBOutlet UILabel *mname;

@property (weak, nonatomic) IBOutlet UILabel *mforbid;
@property (weak, nonatomic) IBOutlet UIImageView *mexpimg;
@property (weak, nonatomic) IBOutlet UIImageView *mBgImg;

@end
