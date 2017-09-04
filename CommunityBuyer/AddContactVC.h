//
//  AddContactVC.h
//  JiaZhengBuyer
//
//  Created by 周大钦 on 15/7/20.
//  Copyright (c) 2015年 zdq. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AddContactDelegate <NSObject>

- (void)setContactName:(NSString *)name andPhone:(NSString *)phone;

@end

@interface AddContactVC : BaseVC

@property (nonatomic,strong) id<AddContactDelegate>delegate;

@property (weak, nonatomic) IBOutlet UITextField *mName;
@property (weak, nonatomic) IBOutlet UITextField *mPhone;
@property (weak, nonatomic) IBOutlet UIButton *mSubmit;
- (IBAction)SubmitClick:(id)sender;

@end
