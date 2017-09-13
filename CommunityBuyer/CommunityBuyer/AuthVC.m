//
//  AuthVC.m
//  CommunityBuyer
//
//  Created by zzl on 15/12/1.
//  Copyright © 2015年 zdq. All rights reserved.
//

#import "AuthVC.h"
#import "dateModel.h"
#import "UILabel+myLabel.h"
#import "VillageVC.h"

@interface AuthVC ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation AuthVC
{
    NSArray *   _mbuildarr;
    NSArray* _mroomarr;
    UITableView*    _mtmptabview;
    UIImageView*    _mtmpicon;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[IQKeyboardManager sharedManager] setEnable:YES];
    [[IQKeyboardManager sharedManager]setEnableAutoToolbar:YES];
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    
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
    // Do any additional setup after loading the view from its nib.
    self.Title = self.mPageName = @"小区身份认证";

 
    if( _mAuthInfo == nil )
    {
        self.mAuthInfo = SAuth.new;
    }
    [self updatePage];
    
}
-(IBAction)choseVill:(id)sender
{
    return;
    VillageVC* vc = [[VillageVC alloc]initWithNibName:@"VillageVC" bundle:nil];
    
    vc.mitblock = ^(SDistrict* retobj )
    {
        if( retobj )
        {
            if( self.mAuthInfo.mDistrict.mId != retobj.mId )
            {
                self.mAuthInfo.mDistrict = retobj;
                self.mAuthInfo.mBuild = nil;
                self.mAuthInfo.mRoom = nil;
                _mbuildarr = nil;
                _mroomarr = nil;
                
                [self updatePage];
            }
        }
    };
    [self pushViewController:vc];
    
    
}
-(IBAction)choseBuilding:(id)sender
{
    if( self.mAuthInfo.mDistrict.mName.length == 0 )
    {
        [SVProgressHUD showErrorWithStatus:@"请先选择小区"];
        return;
    }
    
    if( _mbuildarr.count == 0 )
    {
        [SVProgressHUD showWithStatus:@"加载中..." maskType:SVProgressHUDMaskTypeClear];
        [self.mAuthInfo.mDistrict getBuilds:^(NSArray *all, SResBase *resb) {
            if( resb.msuccess )
            {
                [SVProgressHUD dismiss];
                _mbuildarr = all;
                if( all.count )
                {
                    [self showTable:_mchosebuilding];
                }
            }
            else
                [SVProgressHUD showErrorWithStatus:resb.mmsg];
        }];
    }
    else
    {
        [self showTable:_mchosebuilding];
    }
    
}
-(IBAction)choseRoom:(id)sender
{
    if( self.mAuthInfo.mBuild.mName.length == 0 )
    {
        [SVProgressHUD showErrorWithStatus:@"请先选择楼栋号"];
        return;
    }
    
    if( _mroomarr.count == 0 )
    {
        [self.mAuthInfo.mBuild getRooms:^(NSArray *all, SResBase *resb) {
           
            if( resb.msuccess )
            {
                [SVProgressHUD dismiss];
                _mroomarr = all;
                if( all.count )
                    [self showTable:_mchoseroom];
            }
            else
                [SVProgressHUD showErrorWithStatus:resb.mmsg];
            
        }];
    }
    else
    {
        [self showTable:_mchoseroom];
    }
    
}
-(void)updatePage
{
    if( self.mAuthInfo.mDistrict.mName.length )
    {
        _mvillname.text = self.mAuthInfo.mDistrict.mName;
    }
    else
        _mvillname.text = @"选择小区";
    if( self.mAuthInfo.mBuild.mName.length )
    {
        _mchosebuilding.text = self.mAuthInfo.mBuild.mName;
    }
    else
        _mchosebuilding.text = @"请选择";
        
    [_mchosebuilding autoReSizeWidthForContent:200 ];
    [Util relPosUI:_mchosebuilding dif:10 tag:_miconRBuild tagatdic:E_dic_r];
    
    if( self.mAuthInfo.mRoom.mRoomNum.length )
    {
        _mchoseroom.text = self.mAuthInfo.mRoom.mRoomNum;
    }
    else
    {
        _mchoseroom.text = @"请选择";
    }
    [_mchoseroom autoReSizeWidthForContent:200];
    [Util relPosUI:_mchoseroom dif:10 tag:_miconRRoom tagatdic:E_dic_r];
    
    
    if( self.mAuthInfo.mName.length && _minputname.text.length == 0 )
    {
        _minputname.text = self.mAuthInfo.mName;
    }
    
    if( self.mAuthInfo.mMobile.length && _minputtel.text.length == 0 )
    {
        _minputtel.text = self.mAuthInfo.mMobile;
    }
    
    
}

- (IBAction)submit:(id)sender {
    
    if( 0 == self.mAuthInfo.mDistrict.mName.length )
    {
        [SVProgressHUD showErrorWithStatus:@"请先选择小区"];
        return;
    }
    if( 0 == self.mAuthInfo.mBuild.mName.length )
    {
        [SVProgressHUD showErrorWithStatus:@"请先选择楼栋号"];
        return;
    }
    if( 0 == self.mAuthInfo.mRoom.mRoomNum.length )
    {
        [SVProgressHUD showErrorWithStatus:@"请先选择房间号"];
        return;
    }
    if( 0 == _minputname.text.length )
    {
        [SVProgressHUD showErrorWithStatus:@"请先输入姓名"];
        return;
    }
    if( 0 == _minputtel.text.length )
    {
        [SVProgressHUD showErrorWithStatus:@"请先输入电话"];
        return;
    }
    if( ![Util isMobileNumber:_minputtel.text] )
    {
        [SVProgressHUD showErrorWithStatus:@"请先输入合法的手机号码"];
        return;
    }
    
    self.mAuthInfo.mName = _minputname.text;
    self.mAuthInfo.mMobile = _minputtel.text;
    
    [SVProgressHUD showWithStatus:@"正在提交" maskType:SVProgressHUDMaskTypeClear];
    [self.mAuthInfo submitThisAuth:^(SResBase *resb) {
        
        if( resb.msuccess )
        {
            [SVProgressHUD showSuccessWithStatus:resb.mmsg];
            [self performSelector:@selector(leftBtnTouched:) withObject:nil afterDelay:0.85f];
        }
        else
        {
            [SVProgressHUD showErrorWithStatus:resb.mmsg];
        }
    }];
}

-(CGRect)makePosRect:(UILabel*)taglable
{
    CGRect f = CGRectMake(0, 0, 150, 1);
    
    f.origin.x = taglable.frame.origin.x + taglable.superview.frame.origin.x;
    f.origin.y = taglable.frame.origin.y + taglable.superview.frame.origin.y + taglable.frame.size.height + 10;
    
    return f;
}
-(void)showTable:(UILabel*)taglable
{
    if( _mtmptabview )
    {
        [self hidenTable:^{
            
        }];
    }
    else
    {
        _mtmptabview = [[UITableView alloc]initWithFrame:[self makePosRect:taglable]];
        _mtmptabview.userInteractionEnabled = YES;
        _mtmptabview.tag = taglable.tag;
        _mtmptabview.delegate   = self;
        _mtmptabview.dataSource = self;
        [_mtmptabview registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
        [self.view addSubview:_mtmptabview];
        
        _mtmptabview.layer.cornerRadius = 3.0f;
        _mtmptabview.layer.borderWidth = 1.0f;
        _mtmptabview.layer.borderColor = [UIColor lightGrayColor].CGColor;

        CGFloat maxh = 200;
        
        if( taglable.tag == 1 )
        {
            _mtmpicon = _miconRBuild;
            maxh = _mbuildarr.count * 44.0f;
        }
        else
        {
            _mtmpicon = _miconRRoom;
            maxh = _mroomarr.count * 44.0f;
        }
        
        maxh = maxh > 200 ? 200:maxh;
        
        [UIView animateWithDuration:0.2f animations:^{
           
            _mtmpicon.image = [UIImage imageNamed:@"huishang"];
            CGRect f  =_mtmptabview.frame;
            f.size.height = maxh;
            _mtmptabview.frame = f;
            
        }];
    }
    
}

-(void)hidenTable:(void(^)())block
{
    [UIView animateWithDuration:0.2f animations:^{
        
        _mtmpicon.image = [UIImage imageNamed:@"huixia"];
        
        CGRect f  =_mtmptabview.frame;
        f.size.height = 1;
        _mtmptabview.frame = f;
        
    } completion:^(BOOL finished) {
        [_mtmptabview removeFromSuperview];
        _mtmptabview = nil;
        if( block )
            block();
    }];
}
-(IBAction)bgtaped:(id)sender
{
    if( _mtmptabview != nil )
        [self hidenTable:nil];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if( tableView.tag == 1 )
        return _mbuildarr.count;
    return _mroomarr.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0f;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];

    if( tableView.tag == 1 )
    {
        SBuilding* b = _mbuildarr[ indexPath.row];
        cell.textLabel.text = b.mName;
    }
    else
    {
        SRoom* r = _mroomarr[ indexPath.row];
        cell.textLabel.text = r.mRoomNum;
    }
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if( tableView.tag == 1 )
    {
        SBuilding* b = _mbuildarr[ indexPath.row];

        if( self.mAuthInfo.mBuild.mId != b.mId )
        {
            self.mAuthInfo.mRoom = nil;
            _mroomarr = nil;
        }
        
        self.mAuthInfo.mBuild = b;
        
    }
    else
    {
        SRoom* r = _mroomarr[ indexPath.row];
        self.mAuthInfo.mRoom = r;
    }
    
    [self updatePage];
    [self hidenTable:nil];
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
