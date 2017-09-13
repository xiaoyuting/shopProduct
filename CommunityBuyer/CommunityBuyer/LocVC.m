//
//  LocVC.m
//  YiZanService
//
//  Created by zzl on 15/3/25.
//  Copyright (c) 2015年 zywl. All rights reserved.
//

#import "LocVC.h"
#import "LocCell.h"
#import "addMapVC.h"
#import "CunsomLabel.h"
@interface LocVC ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation LocVC
{
    NSArray* _allmyaddr;
    int _blocing;
}
-(id)init
{
    self = [super init];
    if( self )
    {
        //self.isMustLogin = YES;
    }
    
    return self;
}
-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if( self )
    {
        //self.isMustLogin = YES;
    }
    return self;
}

-(void)loadView
{
    self.hiddenTabBar = YES;
    [super loadView];
}
- (void)viewDidLoad {
    self.mPageName = @"定位选择";
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.Title = self.mPageName;
    _blocing = 1;
    if( [SUser isNeedLogin] )
    {
        
        [[SAppInfo shareClient] getUserLocationQ:YES block:^(NSString *err) {
            
            if( err ) _blocing = 2;
            _blocing = 0;
            [self updatePage];
        }];
        
    }
    else
    {
        [SVProgressHUD showWithStatus:@"加载中..." maskType:SVProgressHUDMaskTypeClear];
        [[SUser currentUser] getMyAddress:^(SResBase *resb, NSArray *arr) {
            if( resb.msuccess )
            {
                _allmyaddr = arr;
                [SVProgressHUD dismiss];
                [self updatePage];
            }
            else
            {
                [SVProgressHUD showErrorWithStatus:resb.mmsg];
            }
        }];
        
        [[SAppInfo shareClient] getUserLocationQ:YES block:^(NSString *err) {
            
            if( err ) _blocing = 2;
            _blocing = 0;
            if( _allmyaddr != nil )
                [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
        }];
    }
    
}
-(void)updatePage
{
    
    self.tableView = [[UITableView alloc]initWithFrame:self.contentView.bounds];
    self.tableView.separatorStyle  = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor colorWithRed:0.937 green:0.922 blue:0.918 alpha:1.000];
    UINib* nib = [UINib nibWithNibName:@"LocCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"cell"];
    [self.contentView addSubview: self.tableView];
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if( section == 0 ) return 1;
    return _allmyaddr.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 57;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 37;
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView* v = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DEVICE_Width, 37)];
    v.backgroundColor = self.tableView.backgroundColor;
    UILabel* la = [[UILabel alloc]initWithFrame:CGRectMake(15, 8, 100, 20)];
    la.font = [UIFont systemFontOfSize:16];
    la.textColor = [UIColor blackColor];
    [v addSubview:la];
    if( section ==  0 )
    {
        la.text = @"GPS定位地址";
    }
    else
    {
        la.text = @"常用地址";
    }
    return v;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LocCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    cell.contentView.layer.borderColor = [[UIColor colorWithRed:0.867 green:0.859 blue:0.855 alpha:1.000]CGColor];
    cell.contentView.layer.borderWidth = 0.5f;
    cell.maddress.verticalAlignment = VerticalAlignmentMidele;
    if( indexPath.section == 0 )
    {
        cell.marrow.hidden = NO;
        if( _blocing == 1 )
            cell.maddress.text = @"正在定位中....";
        else if( _blocing == 2 )
            cell.maddress.text = @"定位失败!";
        else
            cell.maddress.text = [SAppInfo shareClient].mAddr;
    }
    else
    {
        SAddress* oneadd = _allmyaddr[indexPath.row];
        cell.maddress.text = oneadd.mAddress;
        cell.marrow.hidden = YES;
    }
    
    //CGSize its = [cell.maddress.text sizeWithAttributes:@{NSFontAttributeName:cell.maddress.font}];
    CGSize its  = [cell.maddress sizeThatFits:cell.maddress.bounds.size];
    
    int lines = floor(its.height / cell.maddress.font.lineHeight);

    CGRect f = cell.mloccion.frame;
    f.origin.y = lines == 1 ? 18:10;
    cell.mloccion.frame = f;
    
    f =  cell.marrow.frame;
    f.origin.y =lines == 1 ? 21:10;
    cell.marrow.frame = f;
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if( indexPath.section == 1 )
    {
        if(_itblock )
            _itblock( _allmyaddr[indexPath.row] );
        [self popViewController];
    }
    else
    {
        addMapVC* gotosele = [[addMapVC alloc]init];
        gotosele.mJustSelect = YES;
        gotosele.mItRegions = self.mItpolys;
        
        gotosele.itblock = ^(SAddress* retobj){
            
            if( _itblock )
            {
                _itblock(retobj);
            }
            //这里不需要 popViewController 了,那边会自动回到上一层
        };
        [self pushViewController:gotosele];
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
