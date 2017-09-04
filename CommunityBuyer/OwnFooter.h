//
//  OwnFooter.h
//  CommunityBuyer
//
//  Created by zy _cheng_mac on 16/2/1.
//  Copyright © 2016年 zdq. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OwnFooter : UIView
+ (OwnFooter *)shareView;
@property (weak, nonatomic) IBOutlet UILabel *mPhone;
@property (weak, nonatomic) IBOutlet UILabel *mTime;
@end
