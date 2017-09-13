//
//  UpdateNameVC.h
//  CommunityBuyer
//
//  Created by 周大钦 on 15/12/14.
//  Copyright © 2015年 zdq. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UpdateNameVC : BaseVC

@property (weak, nonatomic) IBOutlet UITextField *mName;
@property (weak, nonatomic) IBOutlet UIButton *mSubmitBT;
- (IBAction)mSubmitClick:(id)sender;
@end
