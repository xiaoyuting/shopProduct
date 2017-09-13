//
//  ShareVC.h
//  JiaZhengBuyer
//
//  Created by 周大钦 on 15/7/29.
//  Copyright (c) 2015年 zdq. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShareVC : BaseVC
@property (weak, nonatomic) IBOutlet UIImageView *mImage;
@property (nonatomic,strong) NSString* shareString;
@property (nonatomic,strong) NSString* qrcodeString;

@end
