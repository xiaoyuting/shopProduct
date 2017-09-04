//
//  notifNotInPoly.m
//  YiZanService
//
//  Created by zzl on 15/6/9.
//  Copyright (c) 2015年 zywl. All rights reserved.
//

#import "notifNotInPoly.h"

@interface notifNotInPoly ()

@end

@implementation notifNotInPoly

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    CGRect f = self.view.frame;
    f.size.height = DEVICE_Height;
    self.view.frame = f;
    
    
    f = _mitwarper.frame;
    f.origin.y = DEVICE_Height;
    _mitwarper.frame = f;
    
    _mbgimg.alpha = 0;
    
    
    _mitwarper.layer.cornerRadius = 3.0f;
    _mitwarper.layer.borderColor = [UIColor clearColor].CGColor;
    _mitwarper.layer.borderWidth = 1.0f;
    
    
}

+(void)showInVC:(UIViewController*)tagvc
{
    notifNotInPoly* vc = [[notifNotInPoly alloc]initWithNibName:@"notifNotInPoly" bundle:nil];
    [tagvc addChildViewController: vc];
    [tagvc.view addSubview:vc.view];
    [vc showIt];
}

-(void)showIt
{
    _mbgimg.alpha = 0;
    
    CGRect f = _mitwarper.frame;
    f.origin.y = DEVICE_Height;
    _mitwarper.frame = f;
    
    [UIView animateWithDuration:0.3f animations:^{
        
        _mbgimg.alpha = 0.67;
        _mitwarper.center = CGPointMake( self.view.bounds.size.width / 2 , self.view.bounds.size.height / 2);
        
    }];
}
-(void)hidenIt
{
    [UIView animateWithDuration:0.3f animations:^{
        
        _mbgimg.alpha = 0;
        CGRect f = _mitwarper.frame;
        f.origin.y =  DEVICE_Height;
        _mitwarper.frame = f;
        
    } completion:^(BOOL finished) {
        [self.view removeFromSuperview];
        [self removeFromParentViewController];
    }];
}

- (IBAction)btclicked:(id)sender {
    [self hidenIt];
}


- (IBAction)bgcliecked:(id)sender {
    [self hidenIt];
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
