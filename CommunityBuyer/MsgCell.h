//
//  MsgCell.h
//  CommunityBuyer
//
//  Created by 周大钦 on 15/9/21.
//  Copyright © 2015年 zdq. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MsgCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *mName;
@property (weak, nonatomic) IBOutlet UILabel *mTime;
@property (weak, nonatomic) IBOutlet UILabel *mContent;
@property (weak, nonatomic) IBOutlet UIImageView *mNew;

@end
