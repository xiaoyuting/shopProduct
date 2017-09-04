//
//  OwnCell.h
//  CommunityBuyer
//
//  Created by 周大钦 on 15/9/17.
//  Copyright © 2015年 zdq. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyUIImageView : UIImageView

@property (nonatomic,retain) NSNumber *eeee;

@end

@interface OwnCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *mImage;
@property (weak, nonatomic) IBOutlet UILabel *mName;
@property (weak, nonatomic) IBOutlet UIImageView *mJiantou;
@property (weak, nonatomic) IBOutlet UISwitch *mSwith;
@property (weak, nonatomic) IBOutlet UILabel *mTs;
@property (weak, nonatomic) IBOutlet UIImageView *mHot;

@end
