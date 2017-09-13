//
//  AdvView.h
//  CommunityBuyer
//
//  Created by 周大钦 on 15/12/15.
//  Copyright © 2015年 zdq. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AdvView : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *mTitle;
@property (weak, nonatomic) IBOutlet UITextView *mContent;
@property (weak, nonatomic) IBOutlet UIButton *mCloseBT;

-(void)showInView:(UIView *)view title:(NSString *)title content:(NSString *)content;

-(void)hiddenView;

@end
