//
//  ContentScrollView.h
//  YiZanService
//
//  Created by ljg on 15-3-23.
//  Copyright (c) 2015年 zywl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContentScrollView : UIScrollView
@property (nonatomic,assign) BOOL needFix;
-(void)addSubview:(UIView *)view;
@end
