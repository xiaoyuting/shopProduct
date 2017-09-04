//
//  AccessControlVC.h
//  CommunityBuyer
//
//  Created by 周大钦 on 15/11/30.
//  Copyright © 2015年 zdq. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AccessControlVC : BaseVC
@property (weak, nonatomic) IBOutlet UISwitch *mSwitch;
@property (weak, nonatomic) IBOutlet UITableView *mTableView;
@property (nonatomic,assign) int mVillagesid;


-(void)quickload;

-(void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event;


@end
