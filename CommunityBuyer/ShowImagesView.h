//
//  ShowImagesView.h
//  ChengEg
//
//  Created by zy _cheng_mac on 16/1/28.
//  Copyright © 2016年 zongyoutec.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShowImagesView : UIView

@property (nonatomic,assign) CGFloat width;
@property (nonatomic,assign) CGFloat height;
@property (nonatomic,assign) CGFloat imageHeight;
//@property (nonatomic,strong) UIImageView *imageview;
@property (nonatomic,strong) NSMutableDictionary *mImageArr;
@property (nonatomic,strong) NSArray *imageArray;
@property (nonatomic,strong) NSMutableArray *smallimageArray;

@property (nonatomic,assign) BOOL flag;

//@property (nonatomic,strong) UIImageView *imageview;


- (void)showMoreImage:(NSArray *)imageArray position:(int) position returnHeight:(void(^)(CGFloat height,UIView *view))block;

@end
