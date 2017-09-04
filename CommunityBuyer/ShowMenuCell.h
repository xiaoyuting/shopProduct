//
//  ShowMenuCell.h
//  CommunityBuyer
//
//  Created by zy _cheng_mac on 16/1/22.
//  Copyright © 2016年 zdq. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShowMenuCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *mImage;//图片
@property (weak, nonatomic) IBOutlet UILabel *mText;//文字


@property (nonatomic,assign) BOOL isSelect;



@end
