//
//  UILabel+myLabel.m
//  tour
//
//  Created by zzl on 14-10-6.
//  Copyright (c) 2014年 zzl. All rights reserved.
//

#import "UILabel+myLabel.h"

@implementation UILabel (myLabel)

-(void)autoReSizeWidthForContent:(CGFloat)maxW
{
    CGSize s = [self.text sizeWithFont:self.font constrainedToSize:CGSizeMake(CGFLOAT_MAX, self.frame.size.height)];
    
    CGFloat w = s.width + self.alignmentRectInsets.left + self.alignmentRectInsets.right;
    CGRect f = self.frame;
    f.size.width = w > maxW ? maxW : w;
    self.frame = f;
    
}
//这个用于宽度定死了,自动设置高度
-(void)autoResizeHeightForContent:(CGFloat)maxH
{
    CGSize s = [self.text sizeWithFont:self.font constrainedToSize:CGSizeMake(self.frame.size.width, CGFLOAT_MAX)];
    
    CGFloat h = s.height + self.alignmentRectInsets.top + self.alignmentRectInsets.bottom;
    CGRect f = self.frame;
    f.size.height = h > maxH ? maxH : h;
    self.frame = f;
    
}



@end
