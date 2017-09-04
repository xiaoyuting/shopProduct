//
//  MyPhoneListVC.m
//  PaoTuiBuyer
//
//  Created by 周大钦 on 15/8/12.
//  Copyright (c) 2015年 zdq. All rights reserved.
//

#import "MyPhoneListVC.h"
#import "PhoneCell.h"
#import "EditPhoneVC.h"

@interface MyPhoneListVC ()<UITableViewDataSource,UITableViewDelegate,SWTableViewCellDelegate>

@end

@implementation MyPhoneListVC{

    BOOL isload;
}

- (void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:YES];
    
        
    if (!isload) {
        
        [self.tableView headerBeginRefreshing];
        
        isload = YES;
    }

}

- (void)viewDidLoad {
    self.hiddenTabBar = YES;
    [super viewDidLoad];
    
    self.mPageName = @"我的电话";
    self.Title = self.mPageName;
    
    
    UINib *nib = [UINib nibWithNibName:@"PhoneCell" bundle:nil];
    [_mTableView registerNib:nib forCellReuseIdentifier:@"cell"];
    
    _mTableView.delegate = self;
    _mTableView.dataSource = self;
    self.tableView = _mTableView;
    self.haveHeader = YES;
//    self.haveFooter = YES;
    _mTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    
}

- (void)headerBeganRefresh{

    [SVProgressHUD showWithStatus:@"加载中" maskType:SVProgressHUDMaskTypeClear];
    /*
    [[SUser currentUser] getMyMobile:^(SResBase *resb, NSArray *arr) {
        
        [self.tableView headerEndRefreshing];
        
        
        if (resb.msuccess) {
            [SVProgressHUD dismiss];
            self.tempArray = [[NSMutableArray alloc] initWithArray:arr];
            
            [self.tableView reloadData];
            
            if (arr.count == 0) {
                [self addEmptyViewWithImg:@"noitem"];
            }else
            {
                [self removeEmptyView];
            }
            
        }else{
            
            [SVProgressHUD showErrorWithStatus:resb.mmsg];
        }
        
    }];
*/
}

#pragma mark -- tableviewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView              // Default is 1 if not implemented
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [self.tempArray count];
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0;
}


//-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return UITableViewAutomaticDimension;
//}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    PhoneCell *cell = (PhoneCell *)[tableView dequeueReusableCellWithIdentifier:@"cell"];
    [cell setRightUtilityButtons:[self rightButtons] WithButtonWidth:58.0f];
    cell.delegate = self;
    
    SMobile *mobile = [self.tempArray objectAtIndex:indexPath.row];
/*    cell.mPhone.text = mobile.mMobile;
    cell.mCheckImg.hidden = YES;
    if (mobile.) {
        cell.mCheckImg.hidden = NO;
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    */
    return cell;
}

- (NSArray *)rightButtons
{
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
    [rightUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:0.78f green:0.78f blue:0.8f alpha:1.0]
                                                title:@"默认"];
    [rightUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:1.0f green:0.231f blue:0.188 alpha:1.0f]
                                                title:@"删除"];
    
    return rightUtilityButtons;
}

- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index
{
    
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    SMobile *mobile = [self.tempArray objectAtIndex:indexPath.row];
    /*
    switch (index) {
            
        case 0:
        {
            
            
            [SVProgressHUD showWithStatus:@"操作中"];
            
            [mobile setThisDefautl:^(SResBase *resb) {
                
                if (resb.msuccess) {
                    
                    [SVProgressHUD showSuccessWithStatus:resb.mmsg];
                    
                    [self.tableView reloadData];
                    
                }else{
                    
                    [SVProgressHUD showErrorWithStatus:resb.mmsg];
                }

            }];
            
            
            break;
        }
        case 1:
        {
            [SVProgressHUD showWithStatus:@"操作中"];
            [mobile delThis:^(SResBase *retobj){
                
                if (retobj.msuccess) {
                    [SVProgressHUD showSuccessWithStatus:retobj.mmsg];
                    
                    [self.tempArray removeObjectAtIndex:indexPath.row];
                    [self.tableView beginUpdates];
                    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                    [self.tableView endUpdates];
                    
                }
                else{
                    [SVProgressHUD showErrorWithStatus:retobj.mmsg];
                }
                
                
            }];
            
            
            break;
        }
        default:
            break;
    }
     */
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SMobile *mobile = [self.tempArray objectAtIndex:indexPath.row];
    
    
    if (_itblock) {
        
        _itblock(mobile);
        
        [self popViewController];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)AddPhoneClick:(id)sender {
    
    EditPhoneVC *edit = [[EditPhoneVC alloc] initWithNibName:@"EditPhoneVC" bundle:nil];
    
    edit.itblock = ^(BOOL add){
    
        if (add) {
            
            [self.tableView headerBeginRefreshing];
        }
    };
    [self pushViewController:edit];
}
@end
