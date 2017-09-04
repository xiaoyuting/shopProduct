//
//  MyInfoVC.h
//  XiCheBuyer
//
//  Created by 周大钦 on 15/6/25.
//  Copyright (c) 2015年 zdq. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyInfoVC : BaseVC
@property (weak, nonatomic) IBOutlet UIImageView *myphotoIV;

@property (weak, nonatomic) IBOutlet UITextField *nameTF;
@property (weak, nonatomic) IBOutlet UILabel *mPhone;
@property (weak, nonatomic) IBOutlet UILabel *mPwd;



@property (weak, nonatomic) IBOutlet UIButton *mBaocun;
- (IBAction)BaoCunClick:(id)sender;
- (IBAction)mGoPhoneClick:(id)sender;
- (IBAction)mGoPwdClick:(id)sender;
- (IBAction)mGoNameClick:(id)sender;

- (IBAction)getPhotoClick:(id)sender;
@end
