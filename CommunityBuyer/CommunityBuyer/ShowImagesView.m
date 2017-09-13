//
//  ShowImagesView.m
//  ChengEg
//
//  Created by zy _cheng_mac on 16/1/28.
//  Copyright © 2016年 zongyoutec.com. All rights reserved.
//

#import "ShowImagesView.h"
#import "MJPhoto.h"
#import "MJPhotoBrowser.h"
#import <objc/runtime.h>


@implementation ShowImagesView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


- (void)showMoreImage:(NSArray *)imageArray position:(int) position returnHeight:(void(^)(CGFloat height,UIView *view))block{
    
    if (!_flag) {
        
        _flag=YES;
        
//        for (UIImageView *view in [self subviews])
//        {
//            if ([view isKindOfClass:[UIImageView class]])
//            {
//                [view removeFromSuperview];
//            }
//        }
        
        
        
        NSUInteger num=[self.subviews count];
        
        
        NSLog(@"num=====%ld",num);
        
        //    imageArray=@[@"http://img4.3lian.com/sucai/img6/230/29.jpg",@"http://img1.3lian.com/img2011/w1/104/26/48.jpg"];
        
        _height=0;//view高度
        
        
        _imageHeight=0;//图片高度
        
        _width=self.frame.size.width;//view宽度
        
        _imageArray=imageArray;
        
        _mImageArr=[[NSMutableDictionary alloc] init];
        
        _smallimageArray=[[NSMutableArray alloc] init];
        
        for(int i=0;i<imageArray.count;i++){
            
            
            
            NSString* oneurl = imageArray[i];
            
            oneurl =[Util makeImgUrl:oneurl fixw:_width];
            
            [_smallimageArray addObject:oneurl];
            
            
            //加载图片
            [SDWebImageDownloader.sharedDownloader downloadImageWithURL:[NSURL URLWithString:oneurl]
                                                                options:0
                                                               progress:^(NSInteger receivedSize, NSInteger expectedSize)
             {
                 // 处理下载进度的代码.
             } completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
                 
                 
                 if (image && finished) {
                     
                     
                     //缓存
                     [[SDImageCache sharedImageCache] storeImage:image forKey:oneurl toDisk:NO];
                     
                     [_mImageArr setObject:image forKey:oneurl];
                     
                     //判断是否加载完成
                     if (_mImageArr.count==imageArray.count) {
                         
                         
                         
                         for(int j=0;j<_mImageArr.count;j++){
                             
                             
                             UIImageView *imageview=nil;
                             
                             UIImage *tempImage=[_mImageArr objectForKey:_smallimageArray[j]];
                             
                             if(_width<=tempImage.size.width){
                                 _imageHeight=tempImage.size.height*_width/tempImage.size.width;//按照uiView宽度得到高
                                 
                                 
                                 imageview=[[UIImageView alloc] initWithFrame:CGRectMake(0, _height, _width, _imageHeight)];
                                 
                                 
                                 
                             }else{
                                 _imageHeight=tempImage.size.height;
                                 switch (position) {
                                     case 1://左
                                         
                                         imageview=[[UIImageView alloc] initWithFrame:CGRectMake(0, _height, tempImage.size.width, _imageHeight)];
                                         
                                         break;
                                     case 2://右
                                         
                                         imageview=[[UIImageView alloc] initWithFrame:CGRectMake(_width-tempImage.size.width, _height, tempImage.size.width, _imageHeight)];
                                         break;
                                     case 3://中
                                         imageview=[[UIImageView alloc] initWithFrame:CGRectMake((_width-tempImage.size.width)/2, _height, tempImage.size.width, _imageHeight)];
                                         break;
                                     default:
                                         break;
                                 }
                                 
                             }
                             [imageview setImage:tempImage];
                             
                             if( !imageview.userInteractionEnabled )
                             {
                                 imageview.userInteractionEnabled  = YES;
                                 UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageClick:)];
                                 
                                 imageview.tag=j+1;
                                 [imageview addGestureRecognizer:tap];
                                 
                                 
                             }
                             
                             
                             [self addSubview:imageview];
                             
                             _height+=_imageHeight+5;
                             
                         }
                         _flag=NO;
                         block(_height,self);
                         
                     }
                     
                 } }];
            
        }

        
    }else{
 
        NSLog(@"!!!图片未完成下载");
    }
    
    
    
}


-(void)imageClick:(UITapGestureRecognizer*)sender
{
    UIImageView* tagv = (UIImageView*)sender.view;

    NSMutableArray* allimgs = NSMutableArray.new;
    for ( NSString* url in _imageArray )
    {
        MJPhoto* onemj = [[MJPhoto alloc]init];
        onemj.url = [NSURL URLWithString:url ];
        onemj.srcImageView = tagv;
        [allimgs addObject: onemj];
    }
    
    MJPhotoBrowser* browser = [[MJPhotoBrowser alloc]init];
    browser.currentPhotoIndex = tagv.tag-1;
    browser.photos  = allimgs;
    [browser show];
}

@end
