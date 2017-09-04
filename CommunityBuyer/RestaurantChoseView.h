//
//  RestaurantChoseView.h
//  CommunityBuyer
//
//  Created by 周大钦 on 15/11/13.
//  Copyright © 2015年 zdq. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RestaurantChoseView : UIView
@property (weak, nonatomic) IBOutlet UITableView *mLeftTableView;
@property (weak, nonatomic) IBOutlet UITableView *mRightTableView;

+ (RestaurantChoseView *)shareView;

@end
