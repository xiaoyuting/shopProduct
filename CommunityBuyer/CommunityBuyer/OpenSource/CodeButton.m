//
//  CodeButton.m
//  CommunityBuyer
//
//  Created by 周大钦 on 15/10/16.
//  Copyright © 2015年 zdq. All rights reserved.
//

#import "CodeButton.h"

@implementation CodeButton


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    _lab = [[UILabel alloc] initWithFrame:self.frame];
    [self addSubview:_lab];
}


- (void)setTitleString:(NSString *)titleString{
    _lab.text = titleString;
}



@end
