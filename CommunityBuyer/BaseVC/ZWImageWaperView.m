//
//  ZWImageWaperView.m
//  CommunityBuyer
//
//  Created by zzl on 16/1/28.
//  Copyright © 2016年 zdq. All rights reserved.
//

#import "ZWImageWaperView.h"
#import "MJPhotoBrowser.h"
#import "MJPhoto.h"


@interface ZWImageWaperView ()

@property (nonatomic,strong) void(^mitblock)(NSArray*);
@property (nonatomic,strong) NSArray*   mallimgs;
@property (nonatomic,strong) NSMutableArray*   mallsameimgs;

@end

@implementation ZWImageWaperView
{
    NSMutableDictionary* _downloadimgs;
}
-(id)init
{
    self = [super init];
    if( self )
    {
        [self loadcfg];
    }
    return  self;
}
-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if( self )
    {
        [self loadcfg];
    }
    return self;
}
-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if( self )
    {
        [self loadcfg];
    }
    
    return self;
}
-(void)loadcfg
{
    self.mbShowBig = YES;
    self.mlayoutal = 0;
    self.mtbpading = 10;
    _downloadimgs = NSMutableDictionary.new;
}
-(void)dealloc
{
    self.mitblock = nil;
    self.mallimgs = nil;
    [self.mallsameimgs removeAllObjects];
    self.mallsameimgs = nil;
}
-(void)showSomeImages:(NSArray *)allimgs imgsblock:(void (^)(NSArray *))block
{
    self.mitblock = block;
    self.mallimgs = allimgs;

    self.mallsameimgs = NSMutableArray.new;
    NSMutableArray* retsizearr = NSMutableArray.new;

    
    CGFloat offsety = 0;
    UIImage* defimg = [UIImage imageNamed:@"DefaultImg"];
    
    NSMutableArray* thefuckarr = NSMutableArray.new;
    
    for ( NSString* one in self.mallimgs ) {
        
        NSString* oneurl = [Util makeImgUrl:one fixw:self.bounds.size.width];
        UIImageView* oneimageview = [[UIImageView alloc]initWithImage:defimg];
        CGRect f = oneimageview.frame;
        if( self.mlayoutal == 1 )
            f.origin.x = 0;
        else if( self.mlayoutal == 2 )
            f.origin.x = self.bounds.size.width - f.size.width;
        else
            f.origin.x = 0;
        
        f.origin.y = offsety;
        oneimageview.frame = f;
        [self addSubview: oneimageview];
        
        [retsizearr addObject: @{@"w":@(oneimageview.bounds.size.width),@"h":@(oneimageview.bounds.size.height)} ];

        offsety += self.mtbpading + f.size.height;
        
        oneimageview.tag = [allimgs indexOfObject:one]+1;
        
        [self.mallsameimgs addObject: oneurl];
        
        [thefuckarr addObject: oneurl];//延迟到后面去调用,,否则下面的 mitblock 可能后来
    }
    
    [retsizearr addObject: @{@"w":@(self.bounds.size.width),@"h":@(offsety)} ];
    
    if( self.mitblock )
    {
        self.mitblock(retsizearr);
    }
    
    for ( NSString* one in thefuckarr ) {
        UIImageView* oneimageview = [self viewWithTag:  [thefuckarr indexOfObject:one]+1];
        [oneimageview sd_setImageWithURL:[NSURL URLWithString: one] placeholderImage:defimg completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL){
            
            [self layoutImg:image url:imageURL.absoluteString];
            
        }];
    }
    
}
-(void)layoutImg:(UIImage*)img url:(NSString*)url
{
    if( img  )
       [_downloadimgs setObject:img forKey:url];
    else
        [_downloadimgs setObject:@"" forKey:url];
    
    if( _downloadimgs.count == self.mallimgs.count )
    {//下载完成了
        
        CGFloat offsety = 0;
        NSMutableArray* retsizearr = NSMutableArray.new;
        float scale = [UIScreen mainScreen].scale;// 1x 2x 3x;
        if( scale == 0.0f )
            scale = 2;
        
        for ( NSString* oneurl in self.mallsameimgs ) {
            UIImage* downloadimg = [_downloadimgs objectForKey:oneurl];
            UIImageView * vvvv =  [self viewWithTag:[self.mallsameimgs indexOfObject:oneurl] + 1];
            vvvv.contentMode = UIViewContentModeScaleAspectFit;
            vvvv.clipsToBounds = YES;
            if( [downloadimg isKindOfClass:[UIImage class]] )
            {
                CGSize ss = downloadimg.size;
                CGFloat norwidth = ss.width /  scale;//这个才是屏幕的坐标系,
                CGFloat norhieght = ss.height/ scale;
                if( norwidth > self.bounds.size.width )
                {
                    ss.height   = ss.height * ( self.bounds.size.width / ss.width);
                    ss.width    = self.bounds.size.width;
                }
                else
                {
                    ss.height = norhieght;
                    ss.width = norwidth;
                }
                
                
                CGRect f = vvvv.frame;
                f.size.height = ss.height;
                f.size.width = ss.width;
                
                if( self.mlayoutal == 1 )
                    f.origin.x = 0;
                else if( self.mlayoutal == 2 )
                    f.origin.x = self.bounds.size.width - f.size.width;
                else
                    f.origin.x = 0;
                
                f.origin.y = offsety;
                vvvv.frame = f;
                
                offsety += self.mtbpading + f.size.height;
                [retsizearr addObject: @{@"w":@(ss.width),@"h":@(ss.height)} ];

            }
            else
            {
                //这种情况仅仅修改下Y坐标就好了
                CGRect f = vvvv.frame;
                if( self.mlayoutal == 1 )
                    f.origin.x = 0;
                else if( self.mlayoutal == 2 )
                    f.origin.x = self.bounds.size.width - f.size.width;
                else
                    f.origin.x = 0;
                
                f.origin.y = offsety;
                vvvv.frame = f;
                
                offsety += self.mtbpading + f.size.height;
                [retsizearr addObject: @{@"w":@(f.size.width),@"h":@(f.size.height)} ];
            }
            if( self.mbShowBig )
            {
                UITapGestureRecognizer* guest = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showBigImg:)];
                [vvvv addGestureRecognizer:guest];
                vvvv.userInteractionEnabled = YES;
            }
        }
        
        [retsizearr addObject: @{@"w":@(self.bounds.size.width),@"h":@(offsety)} ];
        
        if( self.mitblock )
        {
            self.mitblock(retsizearr);
        }
    }
}
-(void)showBigImg:(UITapGestureRecognizer*)sender
{
    UIImageView* tagv = (UIImageView*)sender.view;
    
    NSMutableArray* allimgs = NSMutableArray.new;
    for ( NSString* url in self.mallimgs )
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



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
