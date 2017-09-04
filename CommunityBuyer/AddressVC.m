//
//  AddressVC.m
//  YiZanService
//
//  Created by ljg on 15-3-23.
//  Copyright (c) 2015年 zywl. All rights reserved.
//

#import "AddressVC.h"
#import "AddressCell.h"
#import "addMapVC.h"
#import "searchInMap.h"
#import "addrEdit.h"
#import "UILabel+myLabel.h"
#import "AddressNewCell.h"

@interface AddressVC ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>

@end

@implementation AddressVC{

    BOOL isload;
    
    UIView*   _headerview;
    
    NSIndexPath *_path;
    SAddress *_address;
}


-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];

    return self;
}



- (void)viewDidLoad {
    self.hiddenTabBar = YES;
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.mPageName = @"地址管理";
    self.Title = self.mPageName;
    
    
    UINib *nib = [UINib nibWithNibName:@"AddressNewCell" bundle:nil];
    
    _mTableView.delegate = self;
    _mTableView.dataSource = self;
    self.tableView = _mTableView;
    self.haveHeader = YES;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = M_BGCO;
    [self.tableView registerNib:nib forCellReuseIdentifier:@"addressCell"];
    
    [self installHeaer];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.rightBtnTitle = @"新增";
    
    [self.tableView headerBeginRefreshing];
    
}
-(void)installHeaer
{
    _headerview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DEVICE_Width, 44)];
    _headerview.backgroundColor = [UIColor whiteColor];
    
    UIView* line = [[UIView alloc]initWithFrame:CGRectMake(0, 44, DEVICE_Width, 0.5)];
    line.backgroundColor = [UIColor lightGrayColor];
    [_headerview addSubview: line];
    
    
    UILabel* txt = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 20, 30)];
    txt.text = @"自动定位到当前位置";
    txt.textColor = [UIColor lightGrayColor];
    txt.font = [UIFont systemFontOfSize:15.0f];
    
    [txt autoReSizeWidthForContent:260];
    [_headerview addSubview:txt];
    txt.center = CGPointMake( _headerview.bounds.size.width / 2 , _headerview.bounds.size.height/2);
    UIImageView* vvv = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"main_address"]];
    [_headerview addSubview:vvv];
    vvv.center = txt.center;
    [Util relPosUI:txt dif:5 tag:vvv tagatdic:E_dic_r];
    
    UIButton* bt = [[UIButton alloc]initWithFrame:_headerview.bounds];
    [_headerview addSubview:bt];
    [bt addTarget:self action:@selector(locbt:) forControlEvents:UIControlEventTouchUpInside];
    
}
-(void)locbt:(UIButton*)sender
{
    [SVProgressHUD showWithStatus:@"正在定位..." maskType:SVProgressHUDMaskTypeClear];
    [[SAppInfo shareClient]getUserLocationQ:YES block:^(NSString *err) {
       
        if( err )
        {
            [SVProgressHUD showErrorWithStatus:err];
            return ;
        }
        [SVProgressHUD dismiss];
        
        if ( _itblock ) {
            
            SAddress*address = SAddress.new;
            address.mlat = [SAppInfo shareClient].mlat;
            address.mlng = [SAppInfo shareClient].mlng;
            address.mAddress = [SAppInfo shareClient].mAddr;
            _itblock( address );
            
        }
        [self leftBtnTouched:nil];
        
    }];
}

- (void)rightBtnTouched:(id)sender{

    addrEdit* vc = [[addrEdit alloc]initWithNibName:@"addrEdit" bundle:nil];
    vc.itblock = ^(SAddress* retobj)
    {
        if( retobj )
        {
            NSInteger index = self.tempArray.count>0?1:0;
            [self.tempArray insertObject:retobj atIndex:index];
            
            [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
            [self removeEmptyView];
        }
        
    };
    
    [self  pushViewController:vc];
}

-(void)headerBeganRefresh
{
    [[SUser currentUser] getMyAddress:^(SResBase *resb, NSArray *arr) {
        
        [self headerEndRefresh];
        if (resb.msuccess) {
            
            
            self.tempArray = [[NSMutableArray alloc] initWithArray:arr];
            
            [self.tableView reloadData];
            if (self.tempArray.count == 0) {
                [self addEmptyViewWithImg:@"noitem"];
            }else
            {
                [self removeEmptyView];
            }
            
        }else
        {
            
            [SVProgressHUD showErrorWithStatus:resb.mmsg];
        }
    }];
}


#pragma mark -- tableviewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView              // Default is 1 if not implemented
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.tempArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if( !_mShowlocself ) return 0.0f;
    return _headerview.frame.size.height;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if( !_mShowlocself ) return nil;
    return _headerview;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{

    return 0;
}


-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AddressNewCell *cell = (AddressNewCell *)[tableView dequeueReusableCellWithIdentifier:@"addressCell"];

    cell.selectionStyle =  UITableViewCellSelectionStyleNone;
    
    SAddress *address = [self.tempArray objectAtIndex:indexPath.row];
    cell.mAddress.text = address.mAddress;
    cell.mPhone.text = address.mMobile;
    cell.mName.text = address.mName;
    
    cell.mTop.hidden = !address.mIsDefault;
    cell.mBottom.hidden = !address.mIsDefault;
    if(address.mIsDefault){
        [cell.mCheck setImage:[UIImage imageNamed:@"quanhong"] forState:UIControlStateNormal];
        cell.mDefault.text = @"默认";
    }
    else{
        [cell.mCheck setImage:[UIImage imageNamed:@"quan"] forState:UIControlStateNormal];
        cell.mDefault.text = @"设为默认";
    }
    
    
    cell.mDelet.tag = indexPath.row;
    [cell.mDelet addTarget:self action:@selector(deleteOne:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.mEdit.tag = indexPath.row;
    [cell.mEdit addTarget:self action:@selector(editOne:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.mCheck.tag = indexPath.row;
    [cell.mCheck addTarget:self action:@selector(defaultOne:) forControlEvents:UIControlEventTouchUpInside];


  
    return cell;
}

- (void)deleteOne:(UIButton *)sender{
    
    UIAlertView *alt = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确认要删除该地址吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    
    [alt show];

    AddressNewCell *cell = (AddressNewCell*)[sender findSuperViewWithClass:[AddressNewCell class]];
    _path = [self.tableView indexPathForCell:cell];

    _address = [self.tempArray objectAtIndex:_path.row];
    
    

}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{

    if (buttonIndex == 1) {
        
        [SVProgressHUD showWithStatus:@"操作中"];
        [_address delThis:^(SResBase *retobj){
            
            if (retobj.msuccess) {
                [SVProgressHUD showSuccessWithStatus:retobj.mmsg];
                
                [self.tempArray removeObjectAtIndex:_path.row];
                [self.tableView beginUpdates];
                [self.tableView deleteRowsAtIndexPaths:@[_path] withRowAnimation:UITableViewRowAnimationAutomatic];
                [self.tableView endUpdates];
                
            }
            else{
                [SVProgressHUD showErrorWithStatus:retobj.mmsg];
            }
            
            
        }];

    }
}

- (void)editOne:(UIButton *)sender{

    AddressNewCell *cell = (AddressNewCell*)[sender findSuperViewWithClass:[AddressNewCell class]];
    NSIndexPath *indexpath = [self.tableView indexPathForCell:cell];
    
    SAddress *address = [self.tempArray objectAtIndex:indexpath.row];
    
    addrEdit* vc = [[addrEdit alloc]initWithNibName:@"addrEdit" bundle:nil];
    vc.mHaveAddr = address;
    vc.itblock = ^(SAddress* retobj)
    {
        if( retobj )
        {
            [self.tempArray replaceObjectAtIndex:indexpath.row withObject:retobj];
            [self.tableView beginUpdates];
            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:indexpath.row inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
            [self.tableView endUpdates];
        }
    };
    
    [self pushViewController:vc];
}


- (void)defaultOne:(UIButton *)sender{
    
    AddressNewCell *cell = (AddressNewCell*)[sender findSuperViewWithClass:[AddressNewCell class]];
    NSIndexPath *indexpath = [self.tableView indexPathForCell:cell];
    
    SAddress *address = [self.tempArray objectAtIndex:indexpath.row];
    
    if(address.mIsDefault)
        return;
    
    [SVProgressHUD showWithStatus:@"操作中"];
    __block SAddress* nowdef = nil;
    for ( SAddress* one in self.tempArray ) {
        if( one.mIsDefault )
            nowdef = one;
    }
    [address setThisDefault:^(SResBase *resb) {
        
        if (resb.msuccess) {
            
            [SVProgressHUD showSuccessWithStatus:resb.mmsg];
            if( nowdef )
                nowdef.mIsDefault = NO;
            
            [self.tableView reloadData];
            
        }else{
            
            [SVProgressHUD showErrorWithStatus:resb.mmsg];
        }
        
    }];

}




-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    NSInteger index = indexPath.row;
    SAddress *address = [self.tempArray objectAtIndex:indexPath.row];
    
    if (_itblock) {
        _itblock(address);
        
        [self popViewController];
        return;
    }
    
    addrEdit* vc = [[addrEdit alloc]initWithNibName:@"addrEdit" bundle:nil];
    vc.mHaveAddr = address;
    vc.itblock = ^(SAddress* retobj)
    {
        if( retobj )
        {
            [self.tempArray replaceObjectAtIndex:index withObject:retobj];
            [self.tableView beginUpdates];
            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
            [self.tableView endUpdates];
        }
    };
    
    [self pushViewController:vc];
    
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
