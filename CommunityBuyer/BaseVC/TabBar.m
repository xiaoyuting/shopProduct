//
//  TabBar.m
//  Dota2Buff
//
//  Created by lijiangang on 14-1-26.
//  Copyright (c) 2014年 lijiangang. All rights reserved.
//

#import "TabBar.h"
#import "CustomDefine.h"
@implementation TabBar
{
    UIButton *tempBtn;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self loadView:frame];
    }
    return self;
}
-(void)loadView:(CGRect)rect
{

    self.frame = rect;
    self.backgroundColor = [UIColor clearColor];
    float x = 0.0f;
    for (int i =0 ; i<4; i++) {

        UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(x, 0, 80, 50)];
        bgView.tag = i+300;
        bgView.backgroundColor = COLOR(246, 246, 246);
        [self addSubview:bgView];
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(x, 0, 80, 50)];
        button.backgroundColor =[UIColor clearColor];
        button.titleLabel.font = [UIFont systemFontOfSize:12];
      //  bgView.backgroundColor = COLOR(231, 105, 105);
        [button setTitleColor:COLOR(74, 72, 79) forState:UIControlStateNormal];

        [button setTitleEdgeInsets:UIEdgeInsetsMake(50, 0, 20, 0)];
               if (i == 0) {
                  // bgView.backgroundColor = COLOR(104, 58, 2);
                   [button setTitleColor:COLOR(252, 74, 136) forState:UIControlStateNormal];
                   tempBtn = button;
        }
        //[button setTitle:[NSString stringWithFormat:@"%D",i] forState:UIControlStateNormal];
        button.tag = i+100;
        [button addTarget:self action:@selector(btnTaped:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        
        UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(x+29, 5, 23, 23)];
        image.tag = i+200;;
        switch (i) {
            case 0:
                [button setTitle:@"首页" forState:UIControlStateNormal];
                image.image = [UIImage imageNamed:@"db-11.png"];
                break;
            case 1:
                [button setTitle:@"订单" forState:UIControlStateNormal];
                image.image = [UIImage imageNamed:@"db-23.png"];

                break;
            case 2:
                [button setTitle:@"我的" forState:UIControlStateNormal];
                image.image = [UIImage imageNamed:@"db-22.png"];
                break;
            case 3:
                [button setTitle:@"更多" forState:UIControlStateNormal];
                image.image = [UIImage imageNamed:@"db-24.png"];
                
                break;
            default:
                break;
        }
        
        [self addSubview:image];
        x += 80;

        
    }
}
-(void)btnTaped:(UIButton *)btn
{

    if (tempBtn == btn) {
        return;
    }
    else
    {
        [tempBtn setTitleColor:COLOR(74, 72, 79) forState:UIControlStateNormal];
        UIImageView *oldImage = (UIImageView*)[self viewWithTag:tempBtn.tag+100];

      //  UIView *oldbgView = [self viewWithTag:tempBtn.tag+200];
        switch (tempBtn.tag) {
            case 100:
                oldImage.image = [UIImage imageNamed:@"db-21.png"];
              //  oldbgView.backgroundColor =  COLOR(231, 105, 105);


                break;
                
            case 101:
                oldImage.image = [UIImage imageNamed:@"db-23.png"];
              //  oldbgView.backgroundColor =  COLOR(231, 105, 105);

                break;
            case 102:
                oldImage.image = [UIImage imageNamed:@"db-22.png"];
             //   oldbgView.backgroundColor = COLOR(231, 105, 105);

                break;
            case 103:
                oldImage.image = [UIImage imageNamed:@"db-24.png"];

            //    oldbgView.backgroundColor =  COLOR(231, 105, 105);

                break;
                
            default:
                break;
        }



        
    }
    [btn setTitleColor:COLOR(252, 74, 136) forState:UIControlStateNormal];
    UIImageView *nowImage = (UIImageView*)[self viewWithTag:btn.tag+100];
   // UIView *nowbgView = [self viewWithTag:btn.tag+200];

    switch (btn.tag) {
        case 100:
        {
            nowImage.image = [UIImage imageNamed:@"db-11.png"];
           // nowbgView.backgroundColor = COLOR(104, 58, 2);

        }
            break;
        case 101:
        {
            nowImage.image = [UIImage imageNamed:@"db-13.png"];
          //  nowbgView.backgroundColor = COLOR(104, 58, 2);

        }
            break;
        case 102:
        {
            nowImage.image = [UIImage imageNamed:@"db-12.png"];
          //  nowbgView.backgroundColor = COLOR(104, 58, 2);

        }
            break;
        case 103:
        {
            nowImage.image = [UIImage imageNamed:@"db-14.png"];
         //   nowbgView.backgroundColor = COLOR(104, 58, 2);

        }
            break;
            
        default:
            break;
    }
    tempBtn = btn;
    
    [self.tabDelegate didSelectBtn:btn.tag-100];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
