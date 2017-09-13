//
//  ZWSideBtImg.m
//  CommunityBuyer
//
//  Created by zzl on 16/1/4.
//  Copyright © 2016年 zdq. All rights reserved.
//

#import "ZWSideBtImg.h"

@implementation ZWSideBtImg
{
    UIButton*   _sidebt;
    CGPoint     _btcenterpoint;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
 
-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if( self )
    {
        [self cgfdefault];
    }
    
    return self;
}
-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if( self )
    {
        [self cgfdefault];
    }
    
    return self;
}
-(id)init
{
    self = [super init];
    
    if( self )
    {
        [self cgfdefault];
    }
    
    return self;
}
-(void)cgfdefault
{
    self.mbShowBt = YES;
    self.mDicBt = 1;
    self.mImageBt = [UIImage imageNamed:@"my_store_delete"];
    UITapGestureRecognizer* guest = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imgCliecked:)];
    [self addGestureRecognizer: guest];
    self.userInteractionEnabled = YES;
}

-(void)imgCliecked:(UIGestureRecognizer*)sender
{
    if( _mimgClicked )
        _mimgClicked((ZWSideBtImg*) sender.view );
    else if( _mdelegate && [_mdelegate respondsToSelector:@selector(imgclicked:) ])
    {
        [_mdelegate imgclicked:self];
    }
}

-(void)setMbShowBt:(BOOL)mbShowBt
{
    _mbShowBt = mbShowBt;
    _sidebt.hidden = !_mbShowBt;
}

-(void)setMImageBt:(UIImage *)mImageBt
{
    _mImageBt = mImageBt;
    
    [self showImgBt];
}

-(void)showImgBt
{
    if( nil == _sidebt )
    {
        _sidebt = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
        [_sidebt addTarget:self action:@selector(btClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_sidebt setImage:_mImageBt forState:UIControlStateNormal];
    }
    [self changeSideBt];
}
-(void)btClicked:(UIButton*)sender
{
    if( _mbtClicked )
        _mbtClicked( self );
    else if( _mdelegate && [_mdelegate respondsToSelector:@selector(btclicked:imagetag:)])
    {
        [_mdelegate btclicked:sender imagetag:self];
    }
}
-(void)didMoveToSuperview
{
    if( _mbShowBt && _sidebt.superview != self.superview )
    {//只要不一样就处理
        if( self.superview )
        {
            [self.superview addSubview:_sidebt];
            [self changeSideBt];
        }
        else
            [_sidebt removeFromSuperview];
    }
}
-(void)setHidden:(BOOL)hidden
{
    [super setHidden:hidden];
    _sidebt.hidden = hidden;
}
-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    [self changeSideBt];
}
-(void)setCenter:(CGPoint)center
{
    [super setCenter:center];
    [self changeSideBt];
}
-(void)setBounds:(CGRect)bounds
{
    [super setBounds:bounds];
    [self changeSideBt];
}

-(void)changeSideBt
{
    //if( !_mbShowBt ) return;
    
    if( _mDicBt == 0 )
    {
        _btcenterpoint = CGPointMake( self.frame.origin.x , self.frame.origin.y );
    }
    else if( _mDicBt == 1 )
    {
        _btcenterpoint = CGPointMake( self.frame.origin.x + self.frame.size.width , self.frame.origin.y );
    }
    else if( _mDicBt == 2 )
    {
        _btcenterpoint = CGPointMake( self.frame.origin.x + self.frame.size.width ,self.frame.origin.y + self.frame.size.height);
    }
    else if( _mDicBt == 3 )
    {
        _btcenterpoint = CGPointMake( self.frame.origin.x  ,self.frame.origin.y + self.frame.size.height);
    }
    _sidebt.center = _btcenterpoint;
}






@end
