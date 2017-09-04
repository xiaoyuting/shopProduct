//
//  MainVC.h
//  JiaZhengBuyer
//
//  Created by 周大钦 on 15/7/21.
//  Copyright (c) 2015年 zdq. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainVC : BaseVC

@property (weak, nonatomic) IBOutlet UIView *mNav;

+(BOOL)IsInMainPage;
@property (weak, nonatomic) IBOutlet UIView *mAddressView;
@property (weak, nonatomic) IBOutlet UILabel *mAddress;
- (IBAction)mSearchClick:(id)sender;
- (IBAction)mAddressClick:(id)sender;

@end
