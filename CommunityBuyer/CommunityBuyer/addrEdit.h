//
//  addrEdit.h
//  CommunityBuyer
//
//  Created by zzl on 15/9/24.
//  Copyright © 2015年 zdq. All rights reserved.
//

#import "BaseVC.h"

@class SAddress;
@interface addrEdit : BaseVC

@property (nonatomic,strong)    SAddress*   mHaveAddr;

@property (weak, nonatomic) IBOutlet UITextField *mname;
@property (weak, nonatomic) IBOutlet UITextField *mtel;
@property (weak, nonatomic) IBOutlet UILabel *maddr;
@property (weak, nonatomic) IBOutlet UITextField *mdetail;

@property (nonatomic,strong)    void(^itblock)(SAddress* retobj);

@end
