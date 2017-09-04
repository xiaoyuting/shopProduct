//
//  storeTypeTableViewCell.h
//  CommunityBuyer
//
//  Created by 密码为空！ on 15/10/12.
//  Copyright © 2015年 zdq. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface storeTypeTableViewCell : UITableViewCell
///类型
@property (weak, nonatomic) IBOutlet UILabel *mName;
///图片
@property (weak, nonatomic) IBOutlet UIImageView *mImg;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mTableViewHeight;
@property (weak, nonatomic) IBOutlet UITableView *mTableView;
@end
