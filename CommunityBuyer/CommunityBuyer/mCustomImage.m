//
//  mCustomImage.m
//  CommunityBuyer
//
//  Created by 密码为空！ on 15/10/9.
//  Copyright © 2015年 zdq. All rights reserved.
//

#import "mCustomImage.h"

@implementation mCustomImage

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if( self )
    {
        [self addSameBt];
    }
    return self;
}
-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if( self )
    {
        [self addSameBt];
    }
    return self;
}
-(void)addSameBt
{
    CGRect frame = self.frame;
    UIImage* ttt = [UIImage imageNamed:@"my_store_delete"];
    
//    self.msameicon = [[UIButton alloc]initWithFrame:CGRectMake(frame.size.width * 0.5,0, frame.size.width * 0.5, frame.size.height * 0.5)];
    self.msameicon = [[UIButton alloc]initWithFrame:CGRectMake(frame.size.width * 0.6,0, 30, 30)];

    [self.msameicon setImage:ttt forState:UIControlStateNormal];
    CGFloat ss = _msameicon.frame.size.width * 0.5;
    self.msameicon.imageEdgeInsets = UIEdgeInsetsMake(0, ss, ss, 0);
    [self addSubview: self.msameicon];
}

@end
