//
//  ShowMenuVC.h
//  CommunityBuyer
//
//  Created by zy _cheng_mac on 16/1/22.
//  Copyright © 2016年 zdq. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ChooseMenuDelegate <NSObject>

- (void)chooseMenuService:(int) index;//index根据table数组的数据决定

@end

@interface OneItem : NSObject

@property (nonatomic,strong) NSString*  mSelectTxt;
@property (nonatomic,strong) NSString*  mNoramlTxt;
@property (nonatomic,strong) UIImage*   mSelectImg;
@property (nonatomic,strong) UIImage*   mNoramlImg;
@property (nonatomic,assign) BOOL       mSelected;

@end

@interface ShowMenuVC : UIViewController
@property (nonatomic,strong) id<ChooseMenuDelegate> delegate;
@property (nonatomic,strong) NSArray *itemData;

@property (nonatomic,strong) NSArray *imageArray;//图片
@property (nonatomic,strong) NSArray *lightimageArray;//高亮图片
@property (nonatomic,strong) NSArray *textArray;//文字
@property (nonatomic,strong) NSArray *lightTextArray;//高亮文字
@property (nonatomic,strong) NSArray *isSelect;//是否已选择


//dataArr ==> OneItem
+ (ShowMenuVC*)ShowItemMenu:(UIView *)subView dataArr:(NSArray *)dataArr delegate:(id<ChooseMenuDelegate>)delegate;
//+ (void)initTableShowImage:(UIView *)subView data:(NSArray *)text :(NSArray *)lightText :(NSArray *)image :(NSArray *)lightimage :(NSArray *)isSelect;

-(void)showIt;

@end
