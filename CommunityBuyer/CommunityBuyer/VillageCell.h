//
//  VillageCell.h
//  CommunityBuyer
//
//  Created by zy _cheng_mac on 16/1/26.
//  Copyright © 2016年 zdq. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VillageCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *mVillageName;//名称
@property (weak, nonatomic) IBOutlet UILabel *mAddress;//地址

@property (weak, nonatomic) IBOutlet UIButton *mVillageButton;//物业按钮
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mButtonheight;//按钮view高度

- (void)ButtonViewDisplay:(BOOL)bshow;

@end
