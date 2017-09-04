//
//  EditPhoneVC.h
//  PaoTuiBuyer
//
//  Created by 周大钦 on 15/8/12.
//  Copyright (c) 2015年 zdq. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditPhoneVC : BaseVC
@property (weak, nonatomic) IBOutlet UITextField *mPhoneTF;
@property (weak, nonatomic) IBOutlet UIButton *mButton;

@property (nonatomic,strong) void(^itblock)(BOOL isAdd);
- (IBAction)BottonClick:(id)sender;

@end
