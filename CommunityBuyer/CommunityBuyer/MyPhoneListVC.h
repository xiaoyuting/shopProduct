//
//  MyPhoneListVC.h
//  PaoTuiBuyer
//
//  Created by 周大钦 on 15/8/12.
//  Copyright (c) 2015年 zdq. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyPhoneListVC : BaseVC
@property (weak, nonatomic) IBOutlet UITableView *mTableView;

@property (nonatomic,strong) void(^itblock)(SMobile *mobile);


- (IBAction)AddPhoneClick:(id)sender;

@end
