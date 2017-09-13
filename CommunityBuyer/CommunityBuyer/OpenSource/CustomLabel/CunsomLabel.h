//
//  CunsomLabel.h
//  WeiDianApp
//
//  Created by ljg on 14-12-1.
//  Copyright (c) 2014年 allran.mine. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum{
    VerticalAlignmentTop = 0,
    VerticalAlignmentMidele,
    VerticalAlignmentBottom,
    VerticalAlignmentMax
}VerticalAlignment;
@interface CunsomLabel : UILabel
{
    VerticalAlignment _verticalAlignment;

}
@property (nonatomic, assign)VerticalAlignment verticalAlignment;

@end
