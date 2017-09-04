//
//  TieRebackCell.h
//  CommunityBuyer
//
//  Created by zzl on 16/1/18.
//  Copyright © 2016年 zdq. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TieRebackCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *mheadimg;
@property (weak, nonatomic) IBOutlet UILabel *mname;
@property (weak, nonatomic) IBOutlet UIImageView *mlowicon;
@property (weak, nonatomic) IBOutlet UILabel *mcommname;
@property (weak, nonatomic) IBOutlet UILabel *mlow;
@property (weak, nonatomic) IBOutlet UILabel *mtime;

@property (weak, nonatomic) IBOutlet UILabel *mcontent;

@property (weak, nonatomic) IBOutlet UIView *mrefview;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mrefconsth;

@property (weak, nonatomic) IBOutlet UILabel *mrefname;
@property (weak, nonatomic) IBOutlet UILabel *mrefcontent;

@property (weak, nonatomic) IBOutlet UIButton *mrebackbt;

@property (nonatomic,weak)    id  mtagref;
@property (nonatomic,assign)    SEL mselref;




@end
