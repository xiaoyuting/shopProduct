//
//  SearchAddressVC.h
//  CommunityBuyer
//
//  Created by 周大钦 on 16/1/26.
//  Copyright © 2016年 zdq. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SearchAddressDelegate <NSObject>

- (void)resultAddress:(SAddress *)address;

@end

@interface SearchAddressVC : BaseVC

@property (nonatomic,strong) void(^block)(SAddress *address);

@property (weak, nonatomic) IBOutlet UIView *mSearchView;
@property (weak, nonatomic) IBOutlet UITextField *mSearch;
@property (weak, nonatomic) IBOutlet UITableView *mTableView;
@property (weak, nonatomic) IBOutlet UIButton *mLeftBT;

@property (nonatomic,strong) id<SearchAddressDelegate>delegate;

- (IBAction)mLeftClick:(id)sender;

@end
