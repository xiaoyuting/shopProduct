//
//  TabBar.h
//  Dota2Buff
//
//  Created by lijiangang on 14-1-26.
//  Copyright (c) 2014年 lijiangang. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol TabBarDelegate <NSObject>

-(void)didSelectBtn:(NSInteger)btn;

@end
@interface TabBar : UIView
@property (nonatomic,weak) id <TabBarDelegate>tabDelegate;
@end
