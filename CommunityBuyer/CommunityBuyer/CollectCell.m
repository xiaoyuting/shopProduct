//
//  CollectCell.m
//  PaoTuiBuyer
//
//  Created by 周大钦 on 15/8/11.
//  Copyright (c) 2015年 zdq. All rights reserved.
//

#import "CollectCell.h"
#import "UIImage+RTTint.h"

@implementation CollectCell

- (void)awakeFromNib {
    // Initialization code
    
    _mImg.layer.masksToBounds = YES;
    _mImg.layer.cornerRadius = 3;
    _mImg.layer.borderColor = COLOR(231, 231, 231).CGColor;
    _mImg.layer.borderWidth = 0.8;
}

- (void)setStar:(float)num{

    for (UIImageView *i in self.mXing.subviews) {
        [i removeFromSuperview];
    }
    
    NSString *string =  [NSString stringWithFormat:@"%.1f",num];
    
    NSRange range = [string rangeOfString:@"."];
    NSRange range2 = {0,range.location};
    NSRange range3 = {range.location+1,1};
    int z = [[string substringWithRange:range2] intValue];
    int f = [[string substringWithRange:range3] intValue];
    
    for (int i = 0; i < 5; i++) {
        
        UIImageView *igv = [[UIImageView alloc] initWithFrame:CGRectMake(i*12, 0, 10, 10)];
        if (i<z) {
            igv.image = [UIImage imageNamed:@"hongxing"];
        }else{
            igv.image = [UIImage imageNamed:@"huixing"];
        }
        
        if (f > 0) {
            if (i == z) {
                
                float ff = (float)f;
                UIImage *image = [UIImage imageNamed:@"hongxing"];
                float j = ff/10*21;
                UIEdgeInsets e = UIEdgeInsetsMake(0, j, 0, 0);
                UIImage *tinted = [image rt_tintedImageWithColor:COLOR(184, 184, 184) insets:e];
                [igv setImage:tinted];
            }
        }
        
        [self.mXing addSubview:igv];
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
