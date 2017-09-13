//
//  UpdatePhoneTwoVC.h
//  CommunityBuyer
//
//  Created by 周大钦 on 15/12/14.
//  Copyright © 2015年 zdq. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UpdatePhoneTwoVC : BaseVC
@property (weak, nonatomic) IBOutlet UITextField *mNewPhone;
@property (weak, nonatomic) IBOutlet UITextField *mCode;
@property (weak, nonatomic) IBOutlet UIButton *mCodeBT;
@property (weak, nonatomic) IBOutlet UIButton *mSubmitBT;
- (IBAction)mGetCodeClick:(id)sender;
- (IBAction)mSubmitClick:(id)sender;

@end
