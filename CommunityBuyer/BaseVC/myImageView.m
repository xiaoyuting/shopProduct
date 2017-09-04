//
//  myImageView.m
//  YiZanService
//
//  Created by zzl on 15/6/6.
//  Copyright (c) 2015年 zywl. All rights reserved.
//

#import "myImageView.h"

@implementation myImageView
{
    UITapGestureRecognizer*     _imgtap;
}

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
-(void)dealloc
{
    [self.msameicon removeFromSuperview];
    self.msameicon = nil;
    
    [self removeGestureRecognizer:_imgtap];
    
}
-(void)addSameBt
{
    CGRect frame = self.frame;
    UIImage* ttt = [UIImage imageNamed:@"delsame1"];
    
    self.msameicon = [[UIButton alloc]initWithFrame:CGRectMake(frame.size.width * 0.7,-12, frame.size.width * 0.5, frame.size.height * 0.5)];
    [self.msameicon setImage:ttt forState:UIControlStateNormal];
    CGFloat ss = _msameicon.frame.size.width * 0.5;

    //self.msameicon.imageEdgeInsets = UIEdgeInsetsMake(0, ss, ss, 0);
    
    [self addSubview: self.msameicon];
    self.msameicon.translatesAutoresizingMaskIntoConstraints = YES;
    
    self.msameicon.userInteractionEnabled = YES;
    [self.msameicon addTarget:self action:@selector(delImg:) forControlEvents:UIControlEventTouchUpInside];

    UIButton* bt = [[UIButton alloc]initWithFrame:CGRectMake(frame.size.width * 0.5,0, frame.size.width * 0.5, frame.size.height * 0.5)];
    [self addSubview:bt];
    bt.userInteractionEnabled = YES;
    [bt addTarget:self action:@selector(delImgA:) forControlEvents:UIControlEventTouchUpInside];
    
    
    _imgtap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imgtap:)];
    self.userInteractionEnabled = YES;
    [self addGestureRecognizer:_imgtap];
}
-(void)imgtap:(UITapGestureRecognizer*)sender
{
    if( _mtag )
        [_mtag performSelector:_msel withObject:@{@"id":@(sender.view.tag),@"bdel":@(NO)}];
}
-(void)delImgA:(UIButton*)sender
{
    if( _mtag  )
    {
        if( !_msameicon.hidden )
            [_mtag performSelector:_msel withObject:@{@"id":@(sender.superview.tag),@"bdel":@(YES)}];
        else
        {//如果是添加,就透过去
            [_mtag performSelector:_msel withObject:@{@"id":@(sender.superview.tag),@"bdel":@(NO)}];

        }
    }
}
-(void)delImg:(UIButton*)sender
{
    if( _mtag && !_msameicon.hidden )
    {
        if( !_msameicon.hidden )
            [_mtag performSelector:_msel withObject:@{@"id":@(sender.superview.tag),@"bdel":@(YES)}];
        else
        {//如果
            [_mtag performSelector:_msel withObject:@{@"id":@(sender.superview.tag),@"bdel":@(NO)}];
        }
    }
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
