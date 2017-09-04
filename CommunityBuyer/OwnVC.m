//
//  OwnVC.m
//  XiCheBuyer
//
//  Created by 周大钦 on 15/6/18.
//  Copyright (c) 2015年 zdq. All rights reserved.
//

#import "OwnVC.h"
#import "feedBackViewController.h"
#import "AddressVC.h"
#import "ShareVC.h"
#import "CollectVC.h"
#import "MyPhoneListVC.h"
#import "ResigerVC.h"
#import "OwnCell.h"
#import "MessageVC.h"
#import "SettingVC.h"
#import "myStoreViewController.h"
#import<MessageUI/MessageUI.h>
#import "myYouHuiJuan.h"
#import "OrderVC.h"
#import "OwnFooter.h"
#import "VillageVC.h"
#import "MoneyHeader.h"
#import "MyBalanceVC.h"

#define Height (DEVICE_Width*0.67)

#define QIANYING

@interface OwnVC ()<UITableViewDataSource,UITableViewDelegate,MFMessageComposeViewControllerDelegate,UIAlertViewDelegate>{

    UIImageView *imageV;
    UIView *nav;
    UILabel *lab;
    
    UIImageView *headImg;
    
    UILabel *namelb;
    UILabel *phonelb;
    UILabel *messageNum;
    
    UIButton *resBT;
    UIButton *loginBT;
    UIView   *lineh;
    
    UIButton *rightbtn;
    UIButton *leftbtn;
    
    
    
    MoneyHeader *moneyView;
    
    int mSysNum;
    int mMycollectionNum;
    int mAddressNum;
    int mProCount;
    
    BOOL flag;
    
    NSString *mAppUrl;
    SEL _mallsel[20][20];
}

@end

@implementation OwnVC{

    BOOL isGoLogin;
}


- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
     [self updateHeaderInfo];
    
    flag = NO;

}

- (void)initNum{
    
    [[SUser currentUser] haveNewMsg:^(int newMsgCount, int cartGoodsCount, int collectCount, int addressCount,int procount) {
        
        
        mSysNum = newMsgCount;
        mAddressNum = addressCount;
        mMycollectionNum = collectCount;
        mProCount = procount;
        
         moneyView.mCouponNum.text=[NSString stringWithFormat:@"%d",mProCount];
        
        UITabBarItem *item2 = [self.tabBarController.tabBar.items objectAtIndex:3];
        if (newMsgCount>0){
            
                messageNum.text = [NSString stringWithFormat:@"%d",newMsgCount];
                [nav addSubview:messageNum];
        
            
            item2.badgeValue = [NSString stringWithFormat:@"%d",newMsgCount];
            
           
        
        } else{
            item2.badgeValue = nil;
//        messageNum.hidden=YES;
            

            [messageNum removeFromSuperview];
        }
        
        
        [self.tableView reloadData];
    }];

}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.hiddenBackBtn = YES;
    self.mPageName = @"我的";
    self.Title = self.mPageName;
    
    mAppUrl = nil;
    
    [self loadTableView:CGRectMake(0, 0, DEVICE_Width, DEVICE_Height-50) delegate:self  dataSource:self];
    
    
    
    
    
    self.tableView.backgroundColor = M_BGCO;
    self.tableView.userInteractionEnabled = YES;
    
    
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    
    UINib *nib = [UINib nibWithNibName:@"OwnCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"cell1"];
    

    
//    [self.ownTableView setTableFooterView:[OwnFooter shareView]];
    
    
    [self loadTop];
    [self makeNewData];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(pushcoming:) name:@"pushnotfi" object:nil];
 
    
}


//暂没使用
- (void)loadFooter{
    
    
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_Width, 55)];
    UILabel *kf = [[WPHotspotLabel alloc] initWithFrame:CGRectMake(0, 15, DEVICE_Width, 20)];
    //    NSMutableAttributedString *content = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"客户服务热线：%@",[GInfo shareClient].mServiceTel]];
    //    NSRange contentRange = {7, [content length]-7};
    //    [content addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:contentRange];
    //    kf.attributedText = content;
    
    kf.textColor = M_TCO;
    kf.textAlignment = NSTextAlignmentCenter;
    kf.font = [UIFont systemFontOfSize:13];
    [footView addSubview:kf];
    //    kf.userInteractionEnabled = YES;
    //    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(CallClick:)];
    //    [kf addGestureRecognizer:tap];
    
    NSDictionary *mStyle = @{@"Action":[WPAttributedStyleAction styledActionWithAction:^{
        NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",[GInfo shareClient].mServiceTel];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
        MLLog(@"打电话");
    }],@"color": COLOR(68, 159, 243),@"xiahuaxian":@[M_CO,@{NSUnderlineStyleAttributeName : @(kCTUnderlineStyleSingle|kCTUnderlinePatternSolid)}]};
    
    kf.attributedText = [[NSString stringWithFormat:@"客户服务热线：<Action><xiahuaxian>%@</xiahuaxian></Action>",[GInfo shareClient].mServiceTel] attributedStringWithStyleBook:mStyle];
    
    
    UILabel *fu = [[UILabel alloc] initWithFrame:CGRectMake(0, 35, DEVICE_Width, 20)];
    fu.text = [NSString stringWithFormat:@"服务时间：%@",[GInfo shareClient].mServiceTime];
    fu.textColor = M_TCO;
    fu.textAlignment = NSTextAlignmentCenter;
    fu.font = [UIFont systemFontOfSize:13];
    [footView addSubview:fu];
    
    [self.tableView setTableFooterView:footView];
}
-(void)makeNewData
{
    
    int i = 0;
    int j = 0;
    
    NSArray *item=@[ [UIImage imageNamed:@"my_order"] ,@"我的订单" ];
    
    NSMutableArray *itemArr=[[NSMutableArray alloc] initWithObjects:item, nil];
    
    _mallsel[i++][j] = @selector(goMyOrderClick);
    [self.tempArray addObject:  itemArr];
    
    
    j=0;
    _mallsel[i][j++]  = @selector(goCollectClick);
    NSArray *item1=@[ [UIImage imageNamed:@"my_sc"] ,mMycollectionNum>0?[NSString stringWithFormat:@"我的收藏(%d)",mMycollectionNum]:@"我的收藏"];
    
    _mallsel[i][j++] = @selector(goAddressClick);
    NSArray *item2=@[ [UIImage imageNamed:@"my_loction"] ,mAddressNum>0?[NSString stringWithFormat:@"收货地址(%d)",mAddressNum]:@"收货地址"];
    
//    _mallsel[i][j++] = @selector(goYouHuijuanClick);
//    NSArray *item3=@[ [UIImage imageNamed:@"my_coupon"] ,mProCount>0?[NSString stringWithFormat:@"优惠券(%d)",mProCount]:@"优惠券"];

    // 暂时不要"我的小区" —— CendyWang 04.16.2016
#ifdef QIANYING
    itemArr=[[NSMutableArray alloc] initWithObjects:item1,item2, nil];
    [self.tempArray addObject:  itemArr];
#else
    _mallsel[i++][j++]= @selector(goMyVillageClick);
    NSArray *item4=@[ [UIImage imageNamed:@"my_village"] ,@"我的小区"];
    
    itemArr=[[NSMutableArray alloc] initWithObjects:item1,item2,item4, nil];
    [self.tempArray addObject:  itemArr];
#endif
    j=0;
    
#ifdef QIANYING
    i++;
#endif

    // 暂时不要 ‘我要开店’ —— Cendywang 04.16.2016
#ifndef QIANYING
    _mallsel[i][j++] = @selector(myStore);
    NSArray *item5=@[ [UIImage imageNamed:@"my_store"],@"我要开店"];
    
    _mallsel[i++][j++] = @selector(MyShare);
    NSArray *item6=@[ [UIImage imageNamed:@"my_fx"], @"邀请好友送优惠券"];
    
    itemArr=[[NSMutableArray alloc] initWithObjects:item5,item6, nil];
//    itemArr = [[NSMutableArray alloc] initWithObjects:item6, nil];
    [self.tempArray addObject:  itemArr];
    
#else
    _mallsel[i++][j++] = @selector(MyShare);
    NSArray *item6=@[ [UIImage imageNamed:@"my_fx"], @"邀请好友送优惠券"];
    
    itemArr = [[NSMutableArray alloc] initWithObjects:item6, nil];
    [self.tempArray addObject:  itemArr];
#endif
    
    j=0;
    
    _mallsel[i++][j++] = @selector(CallClick);
    NSArray *item7=@[ [NSString stringWithFormat:@"客服：%@",[GInfo shareClient].mServiceTel],[NSString stringWithFormat:@"服务时间：%@",[GInfo shareClient].mServiceTime]];
    
    
    itemArr=[[NSMutableArray alloc] initWithObjects:item7, nil];
    [self.tempArray addObject:  itemArr];
    
    [self.tableView  reloadData];
    
}

//
//-(void)makeData
//{
//    
//    int i = 0;
//    
//    
//    _mallsel[i++] = @selector(goMyOrderClick);
//    [self.tempArray addObject: @[ [UIImage imageNamed:@"ic_ordericonsam"] ,@"我的订单" ] ];
//   
//    _mallsel[i++] = @selector(goMsgClick);
//    [self.tempArray addObject: @[ [UIImage imageNamed:@"own_xx"] ,mSysNum>0?[NSString stringWithFormat:@"系统消息(%d)",mSysNum]:@"系统消息"] ];
//    
//    
//    _mallsel[i++] = @selector(goCollectClick);
//    [self.tempArray addObject: @[ [UIImage imageNamed:@"own_sc"] ,mMycollectionNum>0?[NSString stringWithFormat:@"我的收藏(%d)",mMycollectionNum]:@"我的收藏"]  ];
//    
//    _mallsel[i++] = @selector(goYouHuijuanClick);
//    [self.tempArray addObject: @[ [UIImage imageNamed:@"ic_youhuij"] ,mProCount>0?[NSString stringWithFormat:@"优惠券(%d)",mProCount]:@"优惠券"]  ];
//    
//    _mallsel[i++] = @selector(goAddressClick);
//    [self.tempArray addObject: @[ [UIImage imageNamed:@"own_dz"] ,mAddressNum>0?[NSString stringWithFormat:@"地址管理(%d)",mAddressNum]:@"地址管理"]  ];
//    
//    _mallsel[i++] = @selector(goSetting);
//    [self.tempArray addObject: @[ [UIImage imageNamed:@"own_sz"] ,@"设置"] ];
//    
//    _mallsel[i++] = @selector(myStore);
//    [self.tempArray addObject: @[ [UIImage imageNamed:@"own_store"],@"我要开店"] ];
//    
//    _mallsel[i++] = @selector(MyShare);
//    [self.tempArray addObject: @[ [UIImage imageNamed:@"own_yqhy"], @"邀请好友"] ];
//    
//    [self.tableView  reloadData];
//    
//}
-(void)pushcoming:(id)sender
{
    [self updateHeaderInfo];
}


- (void)CallClick{

    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",[GInfo shareClient].mServiceTel];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}

- (void)loadTop{

    nav = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, DEVICE_NavBar_Height)];
    lab = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, 44)];
    lab.text = @"我的";
    lab.textColor = [UIColor whiteColor];
    lab.textAlignment = NSTextAlignmentCenter;
    lab.font = [UIFont systemFontOfSize:16];
    [nav addSubview:lab];
    [self.view addSubview:nav];
    
    
    leftbtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 30, 20, 20)];
//    [leftbtn setTitle:@"" forState:UIControlStateNormal];
    [leftbtn setImage:[UIImage imageNamed:@"my_sz"] forState:UIControlStateNormal];
    [leftbtn addTarget:self action:@selector(goSetting) forControlEvents:UIControlEventTouchUpInside];
    [nav addSubview:leftbtn];
    
    rightbtn = [[UIButton alloc] initWithFrame:CGRectMake(DEVICE_Width-40, 30, 20, 20)];
//    [rightbtn setTitle:@"退出" forState:UIControlStateNormal];
    [rightbtn setImage:[UIImage imageNamed:@"my_message"] forState:UIControlStateNormal];
//    rightbtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [rightbtn addTarget:self action:@selector(goMsgClick) forControlEvents:UIControlEventTouchUpInside];
    [nav addSubview:rightbtn];
    
    
    
    messageNum = [[UILabel alloc] initWithFrame:CGRectMake(DEVICE_Width-25, 22, 18, 18)];
    
    messageNum.clipsToBounds=YES;
    messageNum.layer.cornerRadius=10;
    
    
    NSLog(@"num=========%d",mSysNum);
    
    
    
    messageNum.textColor = [UIColor whiteColor];
    messageNum.backgroundColor=[UIColor redColor];
    messageNum.textAlignment = NSTextAlignmentCenter;
    messageNum.font = [UIFont systemFontOfSize:10];
    messageNum.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;//自动布局，自适应顶部
    

    
    
    imageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_Width, Height)];
    imageV.image = [UIImage imageNamed:@"own_bg"];
    imageV.contentMode = UIViewContentModeScaleAspectFill;
    imageV.userInteractionEnabled = YES;
    
    [self.tableView setTableHeaderView:imageV];
    
    UITapGestureRecognizer *imgAction = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goMyInfoClick:)];
    [imageV addGestureRecognizer:imgAction];
    
    
    
    headImg = [[UIImageView alloc]initWithFrame:CGRectMake((DEVICE_Width-80)/2, Height-140, 80, 80)];
    headImg.center = imageV.center;
    CGRect rect = headImg.frame;
//    rect.origin.y = Height-160;
    headImg.frame = rect;
    headImg.layer.cornerRadius = 40;
    headImg.image = [UIImage imageNamed:@"defultHead"];
    headImg.contentMode=UIViewContentModeScaleAspectFill;
    headImg.clipsToBounds = YES;
    headImg.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;//自动布局，自适应顶部
    [imageV addSubview:headImg];
    
    namelb = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(headImg.frame), self.view.frame.size.width, 30)];
    namelb.text = @"";
    namelb.textColor = [UIColor whiteColor];
    namelb.textAlignment = NSTextAlignmentCenter;
    namelb.font = [UIFont systemFontOfSize:20];
    namelb.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;//自动布局，自适应顶部
    [imageV addSubview:namelb];
    
    phonelb = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(namelb.frame), self.view.frame.size.width, 30)];
    phonelb.hidden=YES;
    phonelb.text = @"";
    phonelb.textColor = [UIColor whiteColor];
    phonelb.textAlignment = NSTextAlignmentCenter;
    phonelb.font = [UIFont systemFontOfSize:20];
    phonelb.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;//自动布局，自适应顶部
//    [imageV addSubview:phonelb];
    
    resBT = [[UIButton alloc] initWithFrame:CGRectMake(DEVICE_Width/2-55, CGRectGetMaxY(headImg.frame)+10, 55, 30)];
    [resBT setTitle:@"注册" forState:UIControlStateNormal];
    [resBT setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    resBT.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    [imageV addSubview:resBT];
    [resBT addTarget:self action:@selector(GOResiger:) forControlEvents:UIControlEventTouchUpInside];
    
    lineh = [[UIView alloc] initWithFrame:CGRectMake(DEVICE_Width/2, CGRectGetMaxY(headImg.frame)+16, 1, 18)];
    lineh.backgroundColor = [UIColor whiteColor];
    lineh.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    [imageV addSubview:lineh];
    
    loginBT = [[UIButton alloc] initWithFrame:CGRectMake(DEVICE_Width/2+1, CGRectGetMaxY(headImg.frame)+10, 55, 30)];
    [loginBT setTitle:@"登录" forState:UIControlStateNormal];
    [loginBT setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    loginBT.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    [imageV addSubview:loginBT];
    [loginBT addTarget:self action:@selector(GoLoginClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    
    moneyView=[MoneyHeader shareView];
    
    
//    CGRect *r=;
    moneyView.frame=CGRectMake(0, imageV.frame.size.height-56, DEVICE_Width, 56);
    
    [moneyView.mMoneyBtn addTarget:self action:@selector(goMoneyVC) forControlEvents:UIControlEventTouchUpInside];
    [moneyView.mCouponBtn addTarget:self action:@selector(goYouHuijuanClick) forControlEvents:UIControlEventTouchUpInside];
    [imageV addSubview:moneyView];
    
    

}

//余额
- (void)goMoneyVC{
    
    MyBalanceVC *vc=[[MyBalanceVC alloc] initWithNibName:@"MyBalanceVC" bundle:nil];
    
    [self pushViewController:vc];
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    
    if (scrollView.contentOffset.y>=Height-160) {
        
        nav.backgroundColor = [UIColor whiteColor];
        lab.textColor = [UIColor blackColor];
        [rightbtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }else{
        nav.backgroundColor = [UIColor clearColor];
        lab.textColor = [UIColor whiteColor];
        [rightbtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
}

#pragma mark -- tableviewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.tempArray[section] count];
}




- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.tempArray.count;
}
//
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    
//    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_Width, 12)];
//    view.backgroundColor = [UIColor clearColor];
//    
//    return view;
//}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section==self.tempArray.count-1) {
        return 47;
    }

    return 52;
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    OwnCell *cell = (OwnCell *)[tableView dequeueReusableCellWithIdentifier:@"cell1"];
//    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_Width, 0.5)];
//    line.backgroundColor = M_LINECO;
    cell.accessoryType=UITableViewCellAccessoryNone;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.mSwith.hidden = YES;
    NSLog(@"%@",[cell.mImage valueForKey:@"eeee"]);
    
    NSArray *oneobj = self.tempArray[indexPath.section][ indexPath.row ];

    if (indexPath.section==self.tempArray.count-1) {
        
        
        OwnFooter *view=[OwnFooter shareView];
        view.frame=CGRectMake(0, 0, DEVICE_Width, 47);
        
        view.mPhone.text=oneobj[0];
        view.mTime.text=oneobj[1];
        
        [cell.mJiantou removeFromSuperview];
        
        [cell addSubview:view];
        
        
        
        NSLog(@"section%ld",indexPath.section);
        return cell;
    }

    
    if (indexPath.section==1&&indexPath.row==3) {
        cell.mTs.hidden=NO;
        cell.mTs.text=@"请选择";
    }
    
    if (indexPath.section==2&&indexPath.row==1) {
        cell.mHot.hidden=NO;
     
    }
    
    NSLog(@"NSArray%@",oneobj);
    
    cell.mImage.image = oneobj[0];
    cell.mName.text = oneobj[1];
    
//    if( indexPath.row == 0 )
//    {
//        [cell addSubview:line];
//    }
    
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    if ([SUser isNeedLogin]) {
        [self gotoLoginVC];
        
        return;
    }
    
    SEL onesel = _mallsel[indexPath.section][ indexPath.row ];
    [self performSelector:onesel];
    
}

- (void)MyShare{
    
    NSLog(@"%@",[GInfo shareClient].mShareContent);
    
    [self showMessageView:nil title:@"邀请好友" body:[GInfo shareClient].mShareContent];
}

- (void)myStore{
    
    if (flag) {
        return;
    }
    
    flag = YES;
    
    [[SUser currentUser] checkReg:^(SResBase *resb, SSeller *seller) {
        
        
        if (resb.msuccess) {
            
            [SVProgressHUD showSuccessWithStatus:resb.mmsg];
            
            
            
            if (seller.mIsCheck == 0) {
                [SVProgressHUD showErrorWithStatus:@"开店信息待审核中！"];
                
            }
            if (seller.mIsCheck == 1) {
                [self AlertViewWithTag:2 andMsg:@"亲爱的商家，距离成功入驻仅仅差一小步哦！请下载掌管生活掌柜端APP进一步完善资料。祝您心想事成入驻成功！"];
            }
            
            if (seller){
                UIStoryboard *storyboard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
                
                myStoreViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"ms"];
                viewController.mSeller = seller;
                
                [self.navigationController pushViewController:viewController animated:YES];
                
            }

            
        }
        else{
            
            if (seller.mIsCheck == 0) {
                [self AlertViewWithTag:1 andMsg:@"恭喜发财，入驻成功！请下载并登录掌管生活掌柜端APP进一步完善管理商品。"];
                [SVProgressHUD dismiss];
            }else{
                [SVProgressHUD showErrorWithStatus:resb.mmsg];
            }
            
            flag = NO;
        }
    }];




}
-(void)updateHeaderInfo
{
    
    if ([SUser isNeedLogin]) {
        
        rightbtn.hidden = YES;
        namelb.hidden = YES;
        phonelb.hidden = YES;
        resBT.hidden = NO;
        loginBT.hidden = NO;
        lineh.hidden = NO;
        headImg.image = [UIImage imageNamed:@"defultHead"];
//        [self gotoLoginVC];
        moneyView.hidden=YES;
        return;
        
    }else{
        rightbtn.hidden = NO;
        namelb.hidden = NO;
        phonelb.hidden = NO;
        resBT.hidden = YES;
        loginBT.hidden = YES;
        lineh.hidden = YES;
        moneyView.hidden=NO;
    }


    namelb.text = [SUser currentUser].mUserName;
    phonelb.text = [SUser currentUser].mPhone;
    
 
    SUser *tt=SUser.new;
    
    [tt getbalance:^(SResBase *resb,NSString *balance){
        
        if (resb.msuccess) {
            moneyView.mMoneyNum.text=balance;
        }else{
            moneyView.mMoneyNum.text=@"0";
        }
        
        
    }];
//    moneyView.mMoneyNum.text=[SUser currentUser].mbalance;

    
    if ([SUser currentUser].mHeadImg) {
        
        headImg.image = [SUser currentUser].mHeadImg;
    }else{
        [headImg sd_setImageWithURL:[NSURL URLWithString:[SUser currentUser].mHeadImgURL] placeholderImage:[UIImage imageNamed:@"defultHead"]];
    }

    headImg.layer.masksToBounds = YES;
    headImg.layer.borderColor = [UIColor colorWithRed:0.580 green:0.506 blue:0.478 alpha:1].CGColor;
    headImg.layer.cornerRadius = headImg.frame.size.width/2;
    headImg.layer.borderWidth = 5;
    
    [self initNum];
}

-(void)showMessageView:(NSArray*)phones title:(NSString*)title body:(NSString*)body
{
//    if([MFMessageComposeViewController canSendText])
//    {
//        MFMessageComposeViewController*controller=[[MFMessageComposeViewController alloc]init];
//        controller.recipients=phones;
//        controller.navigationBar.tintColor=[UIColor redColor];
//        controller.body=body;
//        controller.messageComposeDelegate=self;
//        [self presentViewController:controller animated:YES completion:nil];
//
//    }
//    else
//    {
//        UIAlertView*alert=[[UIAlertView alloc]initWithTitle:@"提示信息"
//                                                   message:@"该设备不支持短信功能"
//                                                  delegate:nil
//                                         cancelButtonTitle:@"确定"
//                                         otherButtonTitles:nil,nil];
//        [alert show];
//    }
    ShareVC *share = [[ShareVC alloc] initWithNibName:@"ShareVC" bundle:nil];
    [self pushViewController:share];
}

-(void)messageComposeViewController:(MFMessageComposeViewController*)controller didFinishWithResult:(MessageComposeResult)result
{
    [self dismissViewControllerAnimated:YES completion:nil];
    switch(result){
        caseMessageComposeResultSent:
            //信息传送成功
            break;
        caseMessageComposeResultFailed:
            //信息传送失败
            break;
        caseMessageComposeResultCancelled:
            //信息被用户取消传送
            break;
        default:
            break;
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)GoLoginClick:(id)sender{

    
    [self gotoLoginVC];
}

- (void)GOResiger:(id)sender{

    UIStoryboard *storyboard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    ResigerVC *viewController = [storyboard instantiateViewControllerWithIdentifier:@"ResigerVC"];
    viewController.mIsOwn = YES;
    
    [self presentViewController:viewController animated:YES completion:nil];
}



- (void)goAddressClick{
    
    UIStoryboard *storyboard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    AddressVC *viewController = [storyboard instantiateViewControllerWithIdentifier:@"AddressVC"];
    viewController.mIsCommon = YES;
    
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)goYouHuijuanClick{
    
    if( [SUser isNeedLogin] )
    {
        [self gotoLoginVC];
        return;
    }
    
    myYouHuiJuan* vc = [[myYouHuiJuan alloc]initWithNibName:@"myYouHuiJuan" bundle:nil];
    [self pushViewController:vc];
    
}

- (void)goMyOrderClick{
    
    
    UIStoryboard *storyboard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    OrderVC *viewController = [storyboard instantiateViewControllerWithIdentifier:@"ordervc"];
    [self pushViewController:viewController];
    
}
- (void)goMsgClick{
    
    
    WebVC* vc = [[WebVC alloc]init];
    vc.mName = @"系统消息";
    vc.mUrl =  [APIClient APiWithUrl:[NSString stringWithFormat:@"msg.message?token=%@&userId=%d",[SUser currentUser].mToken,[SUser currentUser].mUserId]];
    
    [self pushViewController:vc];
    
    /*
    MessageVC *msgVC = [[MessageVC alloc] init];
    [self pushViewController:msgVC];
     */
    
}

//我的小区
- (void)goMyVillageClick{
    
    VillageVC* vc = [[VillageVC alloc]initWithNibName:@"VillageVC" bundle:nil];
    
    vc.isOwn=YES;
    
    [self pushViewController:vc];
    
}

- (void)goSetting{
    if ([SUser isNeedLogin]) {
        [self gotoLoginVC];
        return;
    }
    SettingVC *set = [[SettingVC alloc] init];
    [self pushViewController:set];
}

- (void)goMyInfoClick:(UIGestureRecognizer *)sender {
    
    if ([SUser isNeedLogin]) {
        [self gotoLoginVC];
        return;
    }
    
    UIStoryboard *storyboard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    id viewController = [storyboard instantiateViewControllerWithIdentifier:@"myinfo"];
    
    
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (alertView.tag == 1) {
        MLLog(@"通过");
        if (buttonIndex == 0) {
            WebVC *www = [WebVC new];
            www.mName = @"下载地址";
            www.mUrl = mAppUrl;
            [self pushViewController:www];
        }
        
    }
    else if (alertView.tag == 2) {
        MLLog(@"不通过");
        if (buttonIndex == 0) {
            WebVC *www = [WebVC new];
            www.mName = @"下载地址";
            www.mUrl = mAppUrl;
            [self pushViewController:www];
        }
        
    }
    
    else if( alertView.tag == 100 )
    {
        if( [GInfo shareClient].mForceUpgrade )
        {
            [self doupdateAPP];
        }
        else
        {
            if( 1 == buttonIndex )
            {
                [self doupdateAPP];
            }
        }
        
        return;
    }
    else
    {
        if( buttonIndex == 0 )
        {
            [SUser logout];
            
            [self updateHeaderInfo];

            UITabBarItem *item = [self.tabBarController.tabBar.items objectAtIndex:1];
            item.badgeValue = nil;

            
            UITabBarItem *item2 = [self.tabBarController.tabBar.items objectAtIndex:3];
            item2.badgeValue = nil;
            
            mSysNum = 0;
            mMycollectionNum = 0;
            mAddressNum = 0;
        }
    }
}
-(void)doupdateAPP
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[GInfo shareClient].mAppDownUrl]];
}
- (void)outClick:(id)sender {
    
    UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"注销账号" message:@"您确定要注销当前账号吗?" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
    
    
    
    [alert show];
    
}



- (void)goCollectClick{
    
    CollectVC *collect = [[CollectVC alloc] init];
    [self pushViewController:collect];
    
}

- (void)AlertViewWithTag:(int)tag andMsg:(NSString *)msg{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:msg delegate:self cancelButtonTitle:@"进入下载" otherButtonTitles:@"取消", nil];
    alert.tag = tag;
    [alert show];
}

@end
