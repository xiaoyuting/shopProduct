//
//  SDCollectionViewCell.m
//  scrollV
//
//  Created by touchwaves studio on 15/3/27.
//  Copyright (c) 2015年 ST. All rights reserved.
//

#import "SDCollectionViewCell.h"

@implementation SDCollectionViewCell


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
      
        self.imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0.0, 0.0, self.bounds.size.width, self.bounds.size.height)];
       
        [self addSubview:self.imageView];
    }
    
    return self;
}

@end
