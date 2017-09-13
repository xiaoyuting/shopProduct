//
//  AdvView.m
//  CommunityBuyer
//
//  Created by 周大钦 on 15/12/15.
//  Copyright © 2015年 zdq. All rights reserved.
//

#import "AdvView.h"

@interface AdvView ()

@end

@implementation AdvView

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
}

-(void)showInView:(UIView *)view title:(NSString *)title content:(NSString *)content{

    CGRect rect = CGRectMake(0, 0, DEVICE_Width, DEVICE_Height);
    self.view.frame = rect;
    if (title.length>0) {
        _mTitle.text = title;
    }
    
    if (content.length>0) {
        _mContent.text = content;
    }
    self.view.alpha = 0.f;
    self.view.transform = CGAffineTransformMakeScale(0.1f, 0.1f);
    if( NO )
    {
        [UIView animateWithDuration:0.35f
                              delay:0.f
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             self.view.alpha = 1.f;
                             self.view.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
                         } completion:^(BOOL finished) {
                             
                             [UIView animateWithDuration:0.18f
                                                   delay:0.f
                                                 options:UIViewAnimationOptionCurveEaseInOut
                                              animations:^{
                                                  self.view.transform = CGAffineTransformMakeScale(0.9f, 0.9f);
                                              } completion:^(BOOL finished) {
                                                  
                                                  [UIView animateWithDuration:0.14f
                                                                        delay:0.f
                                                                      options:UIViewAnimationOptionCurveEaseInOut
                                                                   animations:^{
                                                                       self.view.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
                                                                   } completion:nil];
                                                  
                                                  
                                              }];
                             
                             
                         }];
        
        
        [view addSubview:self.view];
    }
    else
    {
        [UIView animateWithDuration:0.35f
                              delay:0.f
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             self.view.alpha = 1.f;
                             self.view.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
                         } completion:^(BOOL finished) {
                        
                             
                             
                         }];
        
        
        [view addSubview:self.view];
    }
    
}

- (void)hiddenView{

    [UIView animateWithDuration:0.3f animations:^{
        self.view.alpha = 0.1f;
        self.view.transform = CGAffineTransformMakeScale(0.1f, 0.1f);
    } completion:^(BOOL finished) {
        [self.view removeFromSuperview];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
