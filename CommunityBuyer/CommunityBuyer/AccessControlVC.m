//
//  AccessControlVC.m
//  CommunityBuyer
//
//  Created by 周大钦 on 15/11/30.
//  Copyright © 2015年 zdq. All rights reserved.
//

#import "AccessControlVC.h"
#import "AccessControlCell.h"
#import "MDManager.h"


@interface AccessControlVC ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>

@end

@implementation AccessControlVC
{
    NSString* _mgkey;
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
    
    self.mPageName = @"门禁";
    self.Title = self.mPageName;
    
    self.tableView = _mTableView;
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.haveHeader = YES;
//    self.haveFooter = YES;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
    self.tableView.tableFooterView = UIView.new;
    
    UINib *nib = [UINib nibWithNibName:@"AccessControlCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"cell"];
    
    _mgkey =  nil;
    [self.mSwitch setOn:[[SUser currentUser] isOpenDoorShake:nil] animated:YES];
  
    [self headerBeganRefresh];
}
-(void)quickload
{
    if(  [SUser isNeedLogin] ) return;
    
    _mgkey =  nil;
    [self headerBeganRefresh];
}

-(void)setOpenDoorKey:(NSString*)key
{
    if( _mgkey == nil )
    {
        _mgkey = key;
        [[MDManager sharedManager] setAppKey:_mgkey];
    }
}

- (IBAction)openshake:(id)sender {
    
    [[SUser currentUser] isOpenDoorShake: @(self.mSwitch.on) ];
    
}

-(void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event{
    if (!(motion == UIEventSubtypeMotionShake))return;
    if( ![[SUser currentUser] isOpenDoorShake:nil] ) return;
    if( _mgkey == nil ) return;
    if( self.tempArray.count == 0 ) return;
    
    
    SDoorKeysInfo* onev = self.tempArray.firstObject;
    
    NSString* userId = onev.mUserid;
    NSMutableArray* keys = NSMutableArray.new;
    NSMutableArray* keynames = NSMutableArray.new;
    NSMutableArray* communitys = NSMutableArray.new;
    
    
    
    for ( SDoorKeysInfo*one in self.tempArray ) {
        
        [keys addObject:one.mKeyid];
        [keynames addObject:one.mKeyname];
        [communitys addObject:one.mCommunity];
        
    }
    
    MDManager *manager = [MDManager sharedManager];
    
    [manager setSoundType:OpenSoundTypeDefault2];
    
    [SVProgressHUD showWithStatus:@"正在通过摇一摇开门" maskType:SVProgressHUDMaskTypeClear];
    [manager shakeOpenDoorWithUserId:userId UseKeyIdList:keys KeyNameList:keynames CommunityList:communitys isSupportShake:YES Success:^(NSDictionary *keyInfo) {
        
        NSLog(@"open door info:%@",keyInfo);
        [self recodeOpen: [keyInfo objectForKey:@"key_name"] e:1 ];
        [SVProgressHUD showSuccessWithStatus:@"开门成功"];
        
    } Failure:^(NSUInteger errorCode) {
        

        [SVProgressHUD showErrorWithStatus: [self formartErr:errorCode]];
        
    }];
    
}
-(void)recodeOpen:(NSString*)keyname e:(int)e
{
    if( keyname )
    {
        SDoorKeysInfo* tag = nil;
        for ( SDoorKeysInfo* one in self.tempArray ) {
            if( [one.mKeyname isEqualToString:keyname] )
                tag = one;
        }
        [tag openRecode:e did:[SUser currentUser].mAuth.mDistrict.mId bid:[SUser currentUser].mAuth.mBuild.mId rid:[SUser currentUser].mAuth.mRoom.mId];
    }
}

-(NSString*)formartErr:(NSUInteger)errcode
{
    switch ( errcode ) {
         
        case ERR_UNKNOWN :// 0,
            return @"未知错误";
            
        case ERR_APP_KEY_MISS :// -1000,
            return @"APP_ID 缺失";
            
        case ERR_DEVICE_ADDRESS_EMPTY :// -2001,
            return @"设备 mac 地址为空";
            
        case ERR_BLUETOOTH_DISABLE :// -2002,
            return @"蓝牙未开启,请先打开蓝牙";
            
        case ERR_DEVICE_INVALID :// -2003,
            return @"设备失效";
            
        case ERR_DEVICE_CONNECT_FAIL :// -2004,
            return @"与设备建立连接失败";
            
        case ERR_DEVICE_OPEN_FAIL :// -2005,
            return @"开门失败";
            
        case ERR_DEVICE_DISCONNECT :// -2006,
            return @"与设备断开连接";
            
        case ERR_DEVICE_PARSE_RESPONSE_FAIL :// -2007,
            return @"解析数据失败";
            
        case ERR_APP_ID_MISMATCH :// -2008,
            return @"APP_KEY 与应用不匹配";
            
        case ERR_NO_AVAILABLE_DEVICES :// -2009,
            return @"附近没有可用设备";
            
        case ERR_DEVICE_SCAN_TIMEOUT :// -2010,
            return @"设备扫描超时";
            
        case ERR_DEVICE_CONNECT_TIMEOUT :// -2011,
            return @"设备连接超时";
            
        case ERR_KEY_STRING_PARSE_FAIL :// -2012,
            return @"钥匙信息解析失败";
            
        case ERR_SHAKE_KEY :// -2013,
            return @"摇一摇钥匙参数信息有误";
            
        case ERR_OPEN_PARAMETER_WRONG :// -2014,
            return @"开门参数中存在nil或空字符串";
            
        case ERR_BLE_SERVICE_FOUND_FAILURE :// -2015 ,     
            return @"蓝牙服务发现失败";
            
        case ERR_BLE_CHARACTER_FOUND_FAILURE :// -2016,    
            return @"蓝牙特征值发现失败";
            
        case ERR_BLE_UPDATE_VALUE_FAILURE :// -2017,       
            return @"获取蓝牙订阅值错误";
            
        case ERR_KEY_TIMEOUT :// -2018,                    
            return @"钥匙有效期失效";
            
        case ERR_NETWORK_ERROR :// -3001,                  
            return @"联网上传失败";
            
        case ERR_AUTHORIZE_INVALID :// -3002               
            return @"授权无效";
    }
    return @"未知错误,请稍后再试";
}



- (void)headerBeganRefresh{

    [SVProgressHUD showWithStatus:@"加载中.." maskType:SVProgressHUDMaskTypeClear];
    
    [SDoorKeysInfo getDoorKeys:_mVillagesid block:^(SResBase *resb, NSArray *all) {
        
        [self.tableView headerEndRefreshing];
        
        if(resb.msuccess){
            [SVProgressHUD dismiss];
            
            if( all.count )
            {
                SDoorKeysInfo* one  = all.firstObject;
                [self setOpenDoorKey:one.mAppkey];
            }
            
            self.tempArray = (NSMutableArray *)all;
            
            [self.tableView reloadData];
            
        }else{
        
            [SVProgressHUD showErrorWithStatus:resb.mmsg];
        }
        
        if ( all.count == 0 )
        {
            [self addEmptyViewWithImg:nil];
        }
        else
        {
            [self removeEmptyView];
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
//    return 3;
    
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
    
    AccessControlCell *cell = (AccessControlCell *)[tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.mName.userInteractionEnabled = YES;
    cell.mName.tag = indexPath.row;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(UpdateClick:)];
    
    [cell.mName addGestureRecognizer:tap];
    
    SDoorKeysInfo *d = [self.tempArray objectAtIndex:indexPath.row];
    
    cell.mName.text = d.mRemark.length > 0 ? d.mRemark :  d.mDoorname;
    cell.mTime.text = [NSString stringWithFormat:@"有效期：%@",d.mExpiretime];
    cell.mButton.tag = indexPath.row;
    [cell.mButton addTarget:self action:@selector(OpenDoor:) forControlEvents:UIControlEventTouchUpInside];
//    cell.mName.text = @"haha";
//    cell.mTime.text = [NSString stringWithFormat:@"有效期：%@",@"11-11"];

    
    
    return cell;
}

- (void)OpenDoor:(UIButton *)sender{

    if( sender.tag > self.tempArray.count )
    {
        [SVProgressHUD showErrorWithStatus:@"数据异常,请稍后再试"];
        return;
    }
    
    MDManager *manager = [MDManager sharedManager];
    [manager setSoundType:OpenSoundTypeDefault1];
    SDoorKeysInfo* one  = self.tempArray[sender.tag];
    
    
    [[MDManager sharedManager] openDoorWithUserId:one.mUserid UseKeyId:one.mKeyid KeyName:one.mKeyname  Community:one.mCommunity  Success:^{
        
    [one openRecode:1 did:[SUser currentUser].mAuth.mDistrict.mId bid:[SUser currentUser].mAuth.mBuild.mId rid:[SUser currentUser].mAuth.mRoom.mId];
        [SVProgressHUD showSuccessWithStatus:@"开门成功"];
        
    } Failure:^(NSUInteger errorCode) {
        
         [one openRecode:errorCode did:[SUser currentUser].mAuth.mDistrict.mId bid:[SUser currentUser].mAuth.mBuild.mId rid:[SUser currentUser].mAuth.mRoom.mId];
        [SVProgressHUD showErrorWithStatus: [self formartErr:errorCode]];
        
    }];
    
}

- (void)UpdateClick:(UITapGestureRecognizer *)tap{
    
    SDoorKeysInfo *d = [self.tempArray objectAtIndex:tap.view.tag];
    
    UIAlertView *alt = [[UIAlertView alloc] initWithTitle:@"修改门禁名称" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alt.alertViewStyle = UIAlertViewStylePlainTextInput;
     UITextField *tf=[alt textFieldAtIndex:0];
    tf.text = d.mRemark.length > 0 ? d.mRemark : d.mDoorname;
    
    [alt show];

    alt.tag = (int)tap.view.tag;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{

    if (buttonIndex == 1) {
        UITextField *tf=[alertView textFieldAtIndex:0];
        
        SDoorKeysInfo *d = [self.tempArray objectAtIndex:alertView.tag];
        
        [SVProgressHUD showWithStatus:@"编辑中.." maskType:SVProgressHUDMaskTypeClear];
        
        [d updateDoorKeys:tf.text block:^(SResBase *resb) {
            
            if (resb.msuccess) {
                [SVProgressHUD dismiss];
                
                [self.tableView beginUpdates];
                [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:alertView.tag inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
                [self.tableView endUpdates];
            }else{
                
                [SVProgressHUD showErrorWithStatus:resb.mmsg];
            }
        }];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    
    
    
    
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
