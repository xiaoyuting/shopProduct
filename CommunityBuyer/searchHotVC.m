//
//  searchHotVC.m
//  CommunityBuyer
//
//  Created by zzl on 15/9/25.
//  Copyright © 2015年 zdq. All rights reserved.
//

#import "searchHotVC.h"
#import "searchCell.h"
#import "searchCellH.h"
#import "searchReslout.h"
@interface searchHotVC ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>

@end

@implementation searchHotVC
{
    NSArray * _allhot;
    NSArray*    _allhistory;
    UIView* _Rv;
    UIView* _Hv;
    
    UIView* _hotview;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.Title = self.mPageName = @"搜索";
    self.hiddenTabBar = YES;
    
    self.searchWarp.layer.borderColor = self.view.backgroundColor.CGColor;
    self.searchWarp.layer.cornerRadius = 5;
    self.searchWarp.layer.borderWidth =  1;
    self.msearchText.delegate = self;
    
    UINib* nib = [UINib nibWithNibName:@"searchCell" bundle:nil];
    [_mItTable registerNib:nib forCellReuseIdentifier:@"cella"];
    
    nib = [UINib nibWithNibName:@"searchCellH" bundle:nil];
    [_mItTable registerNib:nib forCellReuseIdentifier:@"cellb"];
    
    nib = [UINib nibWithNibName:@"searchFooter" bundle:nil];
    [_mItTable registerNib:nib forCellReuseIdentifier:@"cellc"];
    
    
    _mItTable.tableFooterView = [[UIView alloc]init];
    _mItTable.delegate = self;
    _mItTable.dataSource = self;
    
    _mItTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    CGRect f = _mItTable.frame;
    f.origin.y = _searchWarp.frame.origin.y + _searchWarp.frame.size.height + 14;
    f.size.height = DEVICE_Height- f.origin.y;
    _mItTable.frame = f;
    
    
    [SVProgressHUD showWithStatus:@"正在加载..." maskType:SVProgressHUDMaskTypeClear];
    [SSeller getSearchKeys:^(SResBase *info, NSArray *allhot, NSArray *allhistory) {
        
        if( info.msuccess )
        {
            _allhot = allhot;
            _allhistory = allhistory;
            
            [_mItTable reloadData];
            [SVProgressHUD dismiss];
        }
        else
        {
            [SVProgressHUD showErrorWithStatus:info.mmsg];
        }
    }];
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 25;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if( section == 0 )
    {
        if(_Rv ) return _Rv;
        _Rv = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 100, 25)];
        _Rv.backgroundColor = [UIColor colorWithRed:0.910 green:0.918 blue:0.922 alpha:1];
        UILabel* ll = [[UILabel alloc]initWithFrame:CGRectMake(15,2, 85, 20)];
        ll.text = @"热门搜索";
        ll.font = [UIFont systemFontOfSize:14];
        ll.textColor = [UIColor lightGrayColor];
        
        [_Rv addSubview: ll];
        return _Rv;
        
    }
    if( _Hv ) return _Hv;
    
    _Hv = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 100, 25)];
    _Hv.backgroundColor = [UIColor colorWithRed:0.910 green:0.918 blue:0.922 alpha:1];
    UILabel* ll = [[UILabel alloc]initWithFrame: CGRectMake(15, 2, 85, 20)];
    ll.text = @"历史搜索";
    ll.font = [UIFont systemFontOfSize:14];
    ll.textColor = [UIColor lightGrayColor];
    
    [_Hv addSubview: ll];
    
    return _Hv;
    
}

-(UIView*)layoutHotView:(CGFloat)maxW
{
    if( _allhot == nil ) return nil;
    
    
    CGFloat maxXW = maxW - 15.0f;
    CGFloat offsetX = 15.0f;
    CGFloat offsetY = 5;
    
    UIView* tagview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, maxW, 20)];
    tagview.backgroundColor = [UIColor clearColor];
    for ( NSString* one in _allhot ) {
        CGSize textsize =  [one sizeWithAttributes:@{  NSFontAttributeName: [UIFont systemFontOfSize:14.0f]}];
        UIButton* onebt = [[UIButton alloc]initWithFrame:CGRectMake(offsetX, offsetY, textsize.width + 30, 34)];
        [onebt setTitle:one forState:UIControlStateNormal];
        onebt.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        [onebt setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        
        [tagview addSubview:onebt];
        offsetX += onebt.bounds.size.width + 10;
        if ( offsetX > maxXW ) {
            offsetX = 15;
            offsetY += 44;
            onebt.frame = CGRectMake( offsetX, offsetY, onebt.bounds.size.width, onebt.bounds.size.height);
            offsetX += onebt.bounds.size.width + 10;
        }
        
        [onebt addTarget:self action:@selector(btclick:) forControlEvents:UIControlEventTouchUpInside];
        
        onebt.layer.cornerRadius = 3;
        onebt.layer.borderColor = self.view.backgroundColor.CGColor;
        onebt.layer.borderWidth = 1;
        onebt.backgroundColor = [UIColor colorWithRed:217/255.0f green:217/255.0f blue:217/255.0f alpha:1];
    }
    
    CGRect f = tagview.frame;
    f.size.height = offsetY + 44;
    tagview.frame = f;
    return tagview;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if( section == 0 )
    {
        return 1;
    //return ( _allhot.count == 0 ? 0:(_allhot.count-1)/4 + 1);
    }
    return _allhistory.count>0?_allhistory.count+1:0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if( indexPath.section == 0 )
    {
        if( _hotview == nil )
        {
            _hotview = [self layoutHotView:tableView.bounds.size.width];
        }
        return _hotview.bounds.size.height;
    }
    return 44.0f;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if( indexPath.section == 0 )
    {
        searchCell* cella = [tableView dequeueReusableCellWithIdentifier:@"cella"];
        [cella.contentView addSubview:_hotview];
        
        cella.selectionStyle = UITableViewCellSelectionStyleNone;
        return cella;
    }
    else
    {
        if( indexPath.row == _allhistory.count )
        {
            UITableViewCell* cellc = [tableView dequeueReusableCellWithIdentifier:@"cellc"];
            
            return cellc;
        }
        else
        {
            searchCellH* cellb = [tableView dequeueReusableCellWithIdentifier:@"cellb"];
            
            cellb.mtext.text = _allhistory[indexPath.row];
            
            return cellb;
        }
    }
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if( indexPath.section == 1 )
    {
        if( _allhistory.count == indexPath.row )
        {
            [SSeller cleanAllKeys];
            _allhistory = nil;
            [tableView reloadData];
        }
        else
            [self gotoSearch:_allhistory[indexPath.row]];
    }
}
-(void)btclick:(UIButton*)sender
{
    NSString* tt  = [sender titleForState:UIControlStateNormal];
    [self gotoSearch:tt];
}
-(void)gotoSearch:(NSString*)key
{
    _msearchText.text = key;
    
    [_msearchText resignFirstResponder];
    searchReslout* vc = [[searchReslout alloc]init];
    vc.mSearchKey = key;
    [self pushViewController:vc];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField              // called when 'return' key pressed. return NO to ignore
{
    [self gotoSearch:textField.text];
    return YES;
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
