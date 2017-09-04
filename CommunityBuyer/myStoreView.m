//
//  myStoreView.m
//  CommunityBuyer
//
//  Created by 密码为空！ on 15/10/9.
//  Copyright © 2015年 zdq. All rights reserved.
//

#import "myStoreView.h"

@implementation myStoreView

+(myStoreView *)shareView{
    myStoreView *view = [[[NSBundle mainBundle]loadNibNamed:@"myStoreView" owner:self options:nil]objectAtIndex:0];
    
    view.mLine.layer.masksToBounds = YES;
    view.mLine.layer.borderColor = [UIColor colorWithRed:0.859 green:0.851 blue:0.855 alpha:1].CGColor;
    view.mLine.layer.borderWidth = 0.75f;
    
    view.mLogo.layer.masksToBounds = YES;
    view.mLogo.layer.cornerRadius = view.mLogo.frame.size.width/2;
    
    return view;
}

+ (myStoreView *)shareBottomView{
    myStoreView *view = [[[NSBundle mainBundle]loadNibNamed:@"myStoreBottomView1" owner:self options:nil]objectAtIndex:0];
    
    return view;
}

+ (myStoreView *)shareTypeView{
    myStoreView *view = [[[NSBundle mainBundle]loadNibNamed:@"storeTypeView" owner:self options:nil]objectAtIndex:0];
    
    return view;
}
- (IBAction)GoAddressClick:(id)sender {
}
@end
