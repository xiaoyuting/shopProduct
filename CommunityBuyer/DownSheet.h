//
//  DownSheet.h
//  audioWriting
//
//  Created by wolf on 14-7-19.
//  Copyright (c) 2014年 wangruiyy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DownSheetCell.h"
@protocol DownSheetDelegate <NSObject>
@optional
-(void)didSelectIndex:(NSInteger)index;
@end

@interface DownSheet : UIView<UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate>{
    UITableView *view;
    NSArray *listData;
}
-(id)initWithlist:(NSArray *)list height:(CGFloat)height;
- (void)showInView:(UIViewController *)Sview;
@property(nonatomic,assign) id <DownSheetDelegate> delegate;
@end
