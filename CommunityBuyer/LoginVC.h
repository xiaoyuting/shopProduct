//
//  LoginVC.h
//  YiZanService
//
//  Created by ljg on 15-3-20.
//  Copyright (c) 2015年 zywl. All rights reserved.
//

#import "BaseVC.h"

@interface LoginVC : BaseVC


@property (assign,nonatomic) int mSelectIndex;
@property (strong,nonatomic) UIViewController *mViewController;
@property (weak, nonatomic) IBOutlet UITextField *mPwd;
@property (weak, nonatomic) IBOutlet UITextField *mNewPwd;

@property (nonatomic,strong) UIViewController *tagVC;
;

@property (weak, nonatomic) IBOutlet UITextField *phoneTF;
@property (weak, nonatomic) IBOutlet UITextField *codeTF;
@property (weak, nonatomic) IBOutlet UIButton *getCodeBT;
@property (weak, nonatomic) IBOutlet UIButton *notCodeBT;
@property (weak, nonatomic) IBOutlet UIButton *loginBT;
@property (weak, nonatomic) IBOutlet UILabel *statementLB;
@property (weak, nonatomic) IBOutlet UIView *phoneV;
@property (weak, nonatomic) IBOutlet UIView *codeV;
@property (nonatomic,assign) BOOL isPwd;
- (IBAction)getCodeClick:(id)sender;
- (IBAction)notCodeClick:(id)sender;
- (IBAction)loginClick:(id)sender;
@property (strong, nonatomic) IBOutlet UIView *MMView;



@property (weak, nonatomic) IBOutlet UIButton *f;
@property (weak, nonatomic) IBOutlet UILabel *d;

@end
