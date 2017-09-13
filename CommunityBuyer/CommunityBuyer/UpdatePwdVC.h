//
//  UpdatePwdVC.h
//  CommunityBuyer
//
//  Created by 周大钦 on 15/12/14.
//  Copyright © 2015年 zdq. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UpdatePwdVC : BaseVC
@property (weak, nonatomic) IBOutlet UITextField *mOldPwd;
@property (weak, nonatomic) IBOutlet UITextField *mNewPwd;
@property (weak, nonatomic) IBOutlet UITextField *mNewPwdTwo;
@property (weak, nonatomic) IBOutlet UIButton *mSubmitBT;
- (IBAction)mSubmitBT:(id)sender;

@end
