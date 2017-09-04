//
//  SearchAddressVC.m
//  CommunityBuyer
//
//  Created by 周大钦 on 16/1/26.
//  Copyright © 2016年 zdq. All rights reserved.
//

#import "SearchAddressVC.h"
#import "AddAddressCell.h"

@interface SearchAddressVC ()<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate>{

    NSMutableArray *_searcharry;
}

@end

@implementation SearchAddressVC

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[IQKeyboardManager sharedManager] setEnable:YES];
    [[IQKeyboardManager sharedManager]setEnableAutoToolbar:YES];
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    
   

    
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    [[IQKeyboardManager sharedManager] setEnable:NO];
    [[IQKeyboardManager sharedManager]setEnableAutoToolbar:NO];
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = NO;
    
}

- (void)viewDidAppear:(BOOL)animated{

    [super viewDidAppear:animated];
    
     [_mSearch becomeFirstResponder];
}

- (void)viewDidLoad {
    self.hiddenTabBar = YES;
    self.hiddenNavBar = YES;
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.mPageName = @"搜索地址";
    _searcharry = NSMutableArray.new;
    
    _mSearchView.layer.masksToBounds = YES;
    _mSearchView.layer.cornerRadius = 5;
    
    _mTableView.delegate = self;
    _mTableView.dataSource = self;
    
    _mSearch.delegate = self;
    
    UINib *nib = [UINib nibWithNibName:@"AddAddressCell" bundle:nil];
    [_mTableView registerNib:nib forCellReuseIdentifier:@"cell1"];
    
//    [_mSearch becomeFirstResponder];

}

- (void)HiddenKeyborad{

    [_mSearch resignFirstResponder];
}

- (void)searchText:(NSString *)text{
    
    NSString* requrl = [NSString stringWithFormat:@"http://apis.map.qq.com/ws/place/v1/suggestion/?region=&keyword=%@&key=%@",[Util URLEnCode:text],QQMAPKEY];
    
//    [SVProgressHUD showWithStatus:@"加载中..." maskType:SVProgressHUDMaskTypeClear];
    [[APIClient sharedClient]GET:requrl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
//        [SVProgressHUD dismiss];
        NSArray* tmpall = [responseObject objectForKey:@"data"];
        if( tmpall.count > 0 )
        {
            for (NSDictionary *dic in tmpall) {
                SAddress *address =  [[SAddress alloc] init];
                address.mTitle = [dic objectForKey:@"title"];
                address.mAddress = [dic objectForKey:@"address"];
                address.mMapPoint = [NSString stringWithFormat:@"%.6f,%.6f",[[[dic objectForKey:@"location"] objectForKey:@"lat"] floatValue],[[[dic objectForKey:@"location"] objectForKey:@"lng"] floatValue]];
                address.mlat = [[[dic objectForKey:@"location"] objectForKey:@"lat"] floatValue];
                address.mlng = [[[dic objectForKey:@"location"] objectForKey:@"lng"] floatValue];
                [_searcharry addObject:address];
            }
            
            [self removeMEmptyView];
            [_mTableView reloadData];
        }else{
        
            [self addMEmptyView:self.view rect:CGRectZero imageName:@"search_no" labelText:@"未找到符合条件的地址" buttonTitle:@"使用地图选点"];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        MLLog(@"search poi err:%@",error);
//        [SVProgressHUD showErrorWithStatus:@"检索结果为空"];
        
    }];
    
}

-(void)reloadData{

    [self popViewController];
}


#pragma mark -- tableviewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView              // Default is 1 if not implemented
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _searcharry.count;
    
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    AddAddressCell *cell = (AddAddressCell *)[_mTableView dequeueReusableCellWithIdentifier:@"cell1"];
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_Width, 0.5)];
    line.backgroundColor = M_LINECO;
    
    SAddress *address;
    
    address = [_searcharry objectAtIndex:indexPath.row];
    
    cell.mTitle.text = address.mTitle;
    cell.mTitle.textColor = M_TCO;
    
    cell.mAddress.text = address.mAddress;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SAddress *address;
    
    
    address = [_searcharry objectAtIndex:indexPath.row];
    
    [self.delegate resultAddress:address];
    
    [self popViewController_2];
}




- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{

    [_searcharry removeAllObjects];
    
    [self searchText:textField.text];
    
    return YES;
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [_searcharry removeAllObjects];
    
    [self searchText:textField.text];
    
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

- (IBAction)mLeftClick:(id)sender {
    
    [self popViewController];
}
@end
