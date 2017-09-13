//
//  OwnCell.m
//  CommunityBuyer
//
//  Created by 周大钦 on 15/9/17.
//  Copyright © 2015年 zdq. All rights reserved.
//

#import "OwnCell.h"

@implementation MyUIImageView

- (instancetype)initWithImage:(UIImage *)image{
    
    return [super initWithImage:image];
}
- (id)initWithFrame:(CGRect)frame

{
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        // Initialization code
        
    }
    
    return self;
    
}

- (instancetype)init{
    
    return [super init];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{

    self = [super initWithCoder:aDecoder];
    NSLog(@"%@",[self valueForKey:@"eeee"]);
    return self;
}



@end

@implementation OwnCell



- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
