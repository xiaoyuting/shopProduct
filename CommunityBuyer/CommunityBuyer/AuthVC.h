//
//  AuthVC.h
//  CommunityBuyer
//
//  Created by zzl on 15/12/1.
//  Copyright © 2015年 zdq. All rights reserved.
//

#import "BaseVC.h"

@interface AuthVC : BaseVC

@property (weak, nonatomic) IBOutlet UILabel *mvillname;
@property (weak, nonatomic) IBOutlet UILabel *mchosebuilding;
@property (weak, nonatomic) IBOutlet UILabel *mchoseroom;
@property (weak, nonatomic) IBOutlet UITextField *minputname;
@property (weak, nonatomic) IBOutlet UITextField *minputtel;

@property (weak, nonatomic) IBOutlet UIImageView *miconRBuild;
@property (weak, nonatomic) IBOutlet UIImageView *miconRRoom;

@property (nonatomic,strong)    SAuth*  mAuthInfo;
@property (weak, nonatomic) IBOutlet UIView *mwaperinfo;

@end
