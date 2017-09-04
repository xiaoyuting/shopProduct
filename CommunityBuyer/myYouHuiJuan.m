//
//  myYouHuiJuan.m
//  CommunityBuyer
//
//  Created by zzl on 15/12/28.
//  Copyright © 2015年 zdq. All rights reserved.
//

#import "myYouHuiJuan.h"
#import "ZWTopFilterView.h"
#import "OneJCell.h"
#import "LingQuVC.h"

@interface myYouHuiJuan ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation myYouHuiJuan
{
    ZWTopFilterView*    _topfilter;
    int         _itstatus;
    int         _cangetcount;
    
    UIImageView*    _mdian;
    
    BOOL    _willrealod;
}
-(void)dealloc
{
    self.tableView = nil;
}




-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[IQKeyboardManager sharedManager] setEnable:YES];
    [[IQKeyboardManager sharedManager]setEnableAutoToolbar:YES];
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    
    if( _willrealod )
    {
        _willrealod = NO;
        [self.tableView headerBeginRefreshing];
        
    }
    

    
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[IQKeyboardManager sharedManager] setEnable:NO];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:NO];
}


- (void)viewDidLoad {
    self.hiddenTabBar = YES;
    [super viewDidLoad];
    
    if( _mselect )
    {
        self.mPageName = self.Title = @"选择优惠券";
    }
    else
        self.mPageName = self.Title = @"优惠券";
    
    
    
    UINib* nib = [UINib nibWithNibName:@"OneJCell" bundle:nil];
    [self.mtable registerNib:nib forCellReuseIdentifier:@"cell"];
    self.mtable.delegate = self;
    self.mtable.dataSource = self;
    self.tableView = self.mtable;
    
    self.haveFooter = YES;
    self.haveHeader = YES;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    if( _mselect )
    {
        self.mtaboffsettop.constant = 64;
        _itstatus = 2;
        
        self.rightBtnTitle = @"取消选择";
        [self.tableView headerBeginRefreshing];
        [self setRightBtnWidth:80];
    }
    else
    {
        _topfilter = [ZWTopFilterView  makeTopFilterView:@[@"未使用",@"已失效"] MainCorol:M_CO rect:CGRectMake(0, 64, DEVICE_Width, 45)];
        _topfilter.backgroundColor= [UIColor whiteColor];
        __weak myYouHuiJuan* selfref = self;
        _topfilter.mitblock = ^(int from ,int to){
            [selfref topselected:from to:to];
        };
        [self.view addSubview:_topfilter];
        
        UIView* vv = [[UIView alloc]init];
        vv.backgroundColor = [UIColor colorWithWhite:0.945 alpha:1.000];
        CGRect f = vv.frame;
        f.size.height = 20;
        f.size.width = 1;
        f.origin.x = DEVICE_Width/2;
        f.origin.y = 12;
        vv.frame = f;
        [_topfilter addSubview:vv];
    
        
        /*
        self.rightBtnTitle = @"领券";
        _mdian = [[UIImageView alloc]initWithImage: [UIImage imageNamed:@"ic_hongdian"]];
        [self.navBar.rightBtn addSubview:_mdian];
        _mdian.center = CGPointMake( self.navBar.rightBtn.bounds.size.width - 25 , 10);
         */
    }
  
    
}

-(void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    if( self.tableView.tableHeaderView == nil )
        self.tableView.tableHeaderView = self.mtopheader;
}

-(void)rightBtnTouched:(id)sender
{
    if( _mselect )
    {//取消现在
        if( self.mitblock )
            self.mitblock( nil );
        [self leftBtnTouched:nil];
    }
    else
    {
//        LingQuVC* vc = [[LingQuVC alloc]init];
//        [self pushViewController:vc];
//        _willrealod = YES;
    }
    
}

- (IBAction)clickeddesc:(id)sender {
    
    WebVC* vc = [[WebVC alloc]init];
    vc.mName = @"优惠券说明";
    vc.mUrl = [GInfo shareClient].mIntroUrl;
    [self pushViewController:vc];
    
}


-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
  
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.tempArray.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OneJCell*cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (self.tempArray.count>indexPath.row) {
        
        SPromotion* oneobj = self.tempArray[indexPath.row];
        if( [oneobj bY] )
        {
            NSMutableAttributedString* attr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"¥%g",oneobj.mMoney]];
            [attr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(0, 1)];
            cell.mPrcie.attributedText = attr;
            cell.mname.text = @"优惠券";
            cell.mforbid.text = oneobj.mName;
            cell.mPrcie.textColor = [UIColor colorWithRed:0.890 green:0.271 blue:0.376 alpha:1.000];
            cell.mBgImg.image = [UIImage imageNamed:@"bg_yhj"];
        }
        else
        {
            cell.mPrcie.textColor = [UIColor colorWithRed:0.925 green:0.702 blue:0.306 alpha:1.000];
            cell.mPrcie.text =  @"抵";
            cell.mname.text = @"抵用券";
            cell.mforbid.text = oneobj.mName;
            cell.mBgImg.image = [UIImage imageNamed:@"bg_dyj"];
        }
        
        cell.mexttime.text = oneobj.mExpireTimeStr;
        
        cell.mexpimg.hidden = !oneobj.mStatus;
    }
    
    
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if( _mselect )
    {
        SPromotion* oneobj = self.tempArray[indexPath.row];
        if( self.mitblock )
            self.mitblock( oneobj );
        [self leftBtnTouched:nil];
    }
}

-(void)headerBeganRefresh
{
    self.page = 1;
    [[SUser currentUser]getMyYouHuiJuan:self.page status:_itstatus sellerId:self.mSellerId money:self.mMoney block:^(SResBase *resb, NSArray *all, int cangetcount) {
        
        [self headerEndRefresh];
        [self.tempArray removeAllObjects];
        if (resb.msuccess) {
            [self.tempArray addObjectsFromArray: all];
        }
        else
        {
            [SVProgressHUD showErrorWithStatus:resb.mmsg];
        }
        
        if ( self.tempArray.count == 0 )
        {
            [self addEmptyViewWithImg:@"noitem"];
        }
        else
        {
            [self removeEmptyView];
        }
        _cangetcount = cangetcount;

        [self.tableView reloadData];
        
        [self updateTop];
    }];
}
-(void)updateTop
{
    NSString* ss = [NSString stringWithFormat:@"%d",_cangetcount];
    NSString* aa =[NSString stringWithFormat:@"有%@张优惠券",ss];
    NSMutableAttributedString* attr = [[NSMutableAttributedString alloc]initWithString:aa];
    
    [attr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:[aa rangeOfString:ss]];
    self.mallcount.attributedText = attr;
    
}

-(void)footetBeganRefresh
{
    self.page ++;
    [[SUser currentUser]getMyYouHuiJuan:self.page status:_itstatus sellerId:self.mSellerId money:self.mMoney block:^(SResBase *resb, NSArray *all, int cangetcount) {
          
        [self footetEndRefresh];
        if (resb.msuccess) {
            [self.tempArray addObjectsFromArray: all];
            [self.tableView reloadData];
        }
        else
        {
            [SVProgressHUD showErrorWithStatus:resb.mmsg];
        }
        
        if ( self.tempArray.count == 0 )
        {
            [self addEmptyViewWithImg:@"noitem"];
        }
        else
        {
            [self removeEmptyView];
        }
        
        _cangetcount = cangetcount;
        [self updateTop];
        
    }];
}

-(void)topselected:(int)from to:(int)to
{
    if( to == 0 )
        _itstatus = 3;
    else if ( to == 1 )
        _itstatus = 1;
    
    [self.tableView headerBeginRefreshing];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)changeclicked:(id)sender {
    
 [_minputcode resignFirstResponder];
    if( _minputcode.text.length == 0 )
    {
        [SVProgressHUD showErrorWithStatus:@"请先输入兑换码"];
        return;
    }
    
    [SVProgressHUD showWithStatus:@"操作中..." maskType:SVProgressHUDMaskTypeClear];
    [SPromotion exchangeOne:_minputcode.text block:^(SResBase *resb, SPromotion *retobj) {
        
        if( resb.msuccess )
        {
            [SVProgressHUD dismiss];
            [_minputcode resignFirstResponder];
            [self.tableView headerBeginRefreshing];
        }
        else
        {
            
            [SVProgressHUD showErrorWithStatus:resb.mmsg];
        }
    }];
    
    
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
