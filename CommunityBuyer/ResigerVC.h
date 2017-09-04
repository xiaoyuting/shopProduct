//
//  ResigerVC.h
//  PaoTuiBuyer
//
//  Created by 周大钦 on 15/8/12.
//  Copyright (c) 2015年 zdq. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ResigerVC : BaseVC

@property (nonatomic,assign) BOOL mIsUpdate;
@property (nonatomic,assign) BOOL mIsOwn;
@property (nonatomic,strong) UIViewController *tagVC;
@property (weak, nonatomic) IBOutlet UIView *mPhoneV;
@property (weak, nonatomic) IBOutlet UIView *mCodeV;
@property (weak, nonatomic) IBOutlet UITextField *mPhoneTF;
@property (weak, nonatomic) IBOutlet UITextField *mCodeTF;
@property (weak, nonatomic) IBOutlet UIButton *mCodeBT;
@property (weak, nonatomic) IBOutlet UIView *mNewPwdV;
@property (weak, nonatomic) IBOutlet UITextField *mNewPwdTF;

@property (weak, nonatomic) IBOutlet UIButton *mLoginBT;

- (IBAction)mEyesClick:(id)sender;

- (IBAction)GetCodeClick:(id)sender;
- (IBAction)LoginClick:(id)sender;
- (IBAction)PhoneClick:(id)sender;

@end
