//
//  AddressNewCell.h
//  CommunityBuyer
//
//  Created by 周大钦 on 16/1/26.
//  Copyright © 2016年 zdq. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddressNewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *mName;
@property (weak, nonatomic) IBOutlet UILabel *mPhone;
@property (weak, nonatomic) IBOutlet UILabel *mAddress;
@property (weak, nonatomic) IBOutlet UIButton *mCheck;
@property (weak, nonatomic) IBOutlet UILabel *mDefault;
@property (weak, nonatomic) IBOutlet UIButton *mEdit;
@property (weak, nonatomic) IBOutlet UIButton *mDelet;
@property (weak, nonatomic) IBOutlet UIImageView *mTop;
@property (weak, nonatomic) IBOutlet UIImageView *mBottom;

@end
