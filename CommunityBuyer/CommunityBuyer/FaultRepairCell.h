//
//  FaultRepairCell.h
//  CommunityBuyer
//
//  Created by zy _cheng_mac on 16/1/21.
//  Copyright © 2016年 zdq. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FaultRepairCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *mTitle;//标题
@property (weak, nonatomic) IBOutlet UILabel *mContent;//内容
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mImageViewHeight;//图片外层view的高度  cell中 当一个图片都没有的时候使用
@property (weak, nonatomic) IBOutlet UIImageView *mImage1;//图片1
@property (weak, nonatomic) IBOutlet UIImageView *mImage2;//图片2
@property (weak, nonatomic) IBOutlet UIImageView *mImage3;//图片3
@property (weak, nonatomic) IBOutlet UIImageView *mImage4;//图片3
@property (weak, nonatomic) IBOutlet UILabel *mTime;

@property (weak, nonatomic) IBOutlet UIView *mImgUIView;


@end
