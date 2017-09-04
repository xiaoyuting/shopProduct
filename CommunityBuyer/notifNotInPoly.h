//
//  notifNotInPoly.h
//  YiZanService
//
//  Created by zzl on 15/6/9.
//  Copyright (c) 2015年 zywl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface notifNotInPoly : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *mbgimg;
@property (weak, nonatomic) IBOutlet UIView *mitwarper;

+(void)showInVC:(UIViewController*)vc;
 

@end
