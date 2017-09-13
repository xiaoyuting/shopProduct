//
//  AddressTableview.h
//  UserdCarApp
//
//  Created by ljg on 14-10-29.
//  Copyright (c) 2014年 allran.mine. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol AddressDelegate <NSObject>

-(void)tableViewCellDidSelectAddress;
@end

@interface AddressTableview : UITableView<UITableViewDataSource,UITableViewDelegate>
-(AddressTableview *)initWithFrame:(CGRect )rect;
+(void)showAddressTabeleinView:(UIView *)view StartPoint:(float)startpoint height:(float)height delegate:(id<AddressDelegate>)addrDelegate;
+(void)hideAddressTableView;
-(AddressTableview*)currentAddressTableView;
-(void)SetCurrentAddressTaleview:(AddressTableview *)view;
@property (nonatomic,weak)id<AddressDelegate>addrDelegate;
@end
