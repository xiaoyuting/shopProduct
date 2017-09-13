//
//  UpdatePhoneVC.h
//  CommunityBuyer
//
//  Created by 周大钦 on 15/12/14.
//  Copyright © 2015年 zdq. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UpdatePhoneVC : BaseVC
@property (weak, nonatomic) IBOutlet UILabel *mPhone;
@property (weak, nonatomic) IBOutlet UITextField *mCode;
@property (weak, nonatomic) IBOutlet UIButton *mCodeBT;
@property (weak, nonatomic) IBOutlet UIButton *mNextBT;

- (IBAction)mGetCodeClick:(id)sender;
- (IBAction)mNextClick:(id)sender;

@end
