//
//  OrderVC.m
//  XiCheBuyer
//
//  Created by 周大钦 on 15/6/18.
//  Copyright (c) 2015年 zdq. All rights reserved.
//

#import "OrderVC.h"
#import "OrderCell.h"
#import "PingjiaVC.h"
#import "OrderDetailVC.h"
#import "OrderPay.h"
#import "NavC.h"
#import "PayView.h"
#import "CmmVC.h"

@interface myActButton : UIButton

@property (nonatomic,assign)    SEL mAct;

@end

@implementation myActButton

@end

@interface OrderVC ()<UITableViewDataSource,UITableViewDelegate>
{
    int nowSelect;
    UIButton *tempBtn;
    UIImageView *lineImage;
    
    NSMutableDictionary *tempDic;
    
    BOOL    _bgotologin;
    
    SOrderObj *tempOrder;
    
}

@end

@implementation OrderVC{
    NSInteger _mybereloadone;
    
    BOOL      _neverload;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
    
    if( !_neverload )
    {
        _neverload = YES;
         nowSelect = 0;
        tempDic = NSMutableDictionary.new;
//        [self.tableView headerBeginRefreshing];
    }
    
    [self.tableView headerBeginRefreshing];
}


-(id)init{
    if(self==[super init]){
        self.type = [NSString string];
    }
    return self;
}


- (void)viewDidLoad {
   
    self.hiddenTabBar = YES;
    [super viewDidLoad];
    // Do any additional setup after loading the view.
     self.hiddenBackBtn = NO;
    if([self.type intValue]==0){
         self.mPageName = @"订单";
    }else if([self.type intValue]==1){
         self.mPageName = @"卡券";
    }
   
    self.Title = self.mPageName;
    
    [self loadTableView:CGRectMake(0, 64+55, DEVICE_Width, DEVICE_InNavBar_Height-55) delegate:self dataSource:self];
    self.haveHeader = YES;
    self.haveFooter = YES;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor clearColor];
    
    UINib *nib = [UINib nibWithNibName:@"OrderCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"cell1"];
    
    tempBtn = _mLeftBT;
    
    _mLeftBT.layer.borderColor = COLOR(228, 228, 229).CGColor;
    _mLeftBT.layer.borderWidth = 0.5;
    _mMiddleBT.layer.borderColor = COLOR(228, 228, 229).CGColor;
    _mMiddleBT.layer.borderWidth = 0.5;
//    _mRightBT.layer.borderColor = COLOR(228, 228, 229).CGColor;
//    _mRightBT.layer.borderWidth = 0.5;
}


#pragma mark -- tableviewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView              // Default is 1 if not implemented
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString *key2 = [NSString stringWithFormat:@"nowselectdata%d",nowSelect];
    NSArray *arr = [tempDic objectForKey:key2];
    return arr.count;
    
}
-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    OrderCell *cell;
    cell = (OrderCell *)[tableView dequeueReusableCellWithIdentifier:@"cell1"];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    NSString *key2 = [NSString stringWithFormat:@"nowselectdata%d",nowSelect];
    NSArray *arr = [tempDic objectForKey:key2];
    if (arr.count>indexPath.row) {
        
        SOrderObj *order = [arr objectAtIndex:indexPath.row];
        
        [self initCell:cell andOrder:order];
    }

    return cell;
    
}


- (void)initCell:(OrderCell *)cell andOrder:(SOrderObj *)order{
    
    cell.mOrderSn.text = order.mSn;
    cell.stateLB.text = order.mOrderStatusStr;
    
    for (UIImageView *imgV in cell.mImgBgView.subviews) {
        
        if ([imgV isKindOfClass:[UIImageView class]]) {
            
            imgV.image = nil;
            
            for (int i = 0; i < order.mGoodsImages.count; i++) {
                
                if (imgV.tag -10 ==i) {
                    
                    [imgV sd_setImageWithURL:[NSURL URLWithString:[order.mGoodsImages objectAtIndex:i]] placeholderImage:[UIImage imageNamed:@"DefaultImg"]];
                }
            }
        }
    }
    
    
    NSMutableAttributedString *attriString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"共%d件",order.mCount]];
    
    [attriString addAttribute:NSForegroundColorAttributeName value:M_TCO range:NSMakeRange(0,1)];
    [attriString addAttribute:NSForegroundColorAttributeName value:M_TCO range:NSMakeRange(attriString.length-1,1)];
    
     cell.mNum.attributedText = attriString;
    
    NSMutableAttributedString *attriString2 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"¥%.2f元",order.mPayFee]];
    
    [attriString2 addAttribute:NSForegroundColorAttributeName value:M_TCO range:NSMakeRange(0,1)];
    [attriString2 addAttribute:NSForegroundColorAttributeName value:M_TCO range:NSMakeRange(attriString2.length-1,1)];
    
    cell.mPrice.attributedText = attriString2;
  
    
    NSMutableArray *statuAry =  NSMutableArray.new;
    NSArray *btnArr = @[cell.mRightBT,cell.mLeftBT];

    SEL selectorAry[6];
    int index = 0;
    if(((order.mIsCanDelete || order.mIsCanRate) && statuAry.count<2) || statuAry.count == 0){
        
        [statuAry addObject:@"去逛逛"];
        selectorAry[index] = @selector(GoAction:);
        index++;
    }
    if (order.mIsCanConfirm) {//确认完成
        [statuAry addObject:@"确认完成"];
        selectorAry[index] = @selector(comfirmAction:);
        index++;
    }
    if (order.mIsCanPay) {//去支付
        
        [statuAry addObject:@"去支付"];
        selectorAry[index] = @selector(GoPayAction:);
        index++;
        
    }
    if (order.mIsCanCancel) {//取消订单
        
        [statuAry addObject:@"取消订单"];
        selectorAry[index] = @selector(cancelAction:);
        index++;
    }
    if (order.mIsCanRate) {//评价
        
        [statuAry addObject:@"评价"];
        selectorAry[index] = @selector(PingjiaAction:);
        index++;
    }
    if (order.mIsCanDelete) {//删除订单
        
        [statuAry addObject:@"删除订单"];
        selectorAry[index] = @selector(deleteAction:);
        index++;
    }
    
 
    
    for (int i = 0; i<2; i++) {
        myActButton *bbb = btnArr[i];
        if (i <statuAry.count) {
            bbb.hidden = NO;
            [bbb setTitle:statuAry[i] forState:UIControlStateNormal];
            if( bbb.mAct != NULL )
            {
                [bbb removeTarget:self action:bbb.mAct forControlEvents:UIControlEventTouchUpInside];
            }
            [bbb addTarget:self action:selectorAry[i] forControlEvents:UIControlEventTouchUpInside];
            bbb.mAct = selectorAry[i];
            
        }
        else{
            bbb.hidden = YES;
        }
    }

    
}

- (void)deleteAction:(UIButton *)sender{
    //删除订单
    
    OrderCell *cell = (OrderCell*)[sender findSuperViewWithClass:[OrderCell class]];
    NSIndexPath *indexpath = [self.tableView indexPathForCell:cell];
    NSString *key2 = [NSString stringWithFormat:@"nowselectdata%d",nowSelect];
    NSArray *arr = [tempDic objectForKey:key2];
    SOrderObj *order = [arr objectAtIndex:indexpath.row];
    
    //删除订单
    NSInteger _ww = indexpath.row;
    [SVProgressHUD showWithStatus:@"正在删除..." maskType:SVProgressHUDMaskTypeClear];
    
    [order deleteThis:^(SResBase *retobj) {
        if( retobj.msuccess )
        {
            [SVProgressHUD showSuccessWithStatus:retobj.mmsg];
            NSString *key2 = [NSString stringWithFormat:@"nowselectdata%d",nowSelect];
            NSArray *arr = [tempDic objectForKey:key2];
            NSMutableArray* tmpdelarr = [[NSMutableArray alloc]initWithArray:arr];
            [tmpdelarr removeObjectAtIndex:_ww];
            [tempDic setObject:tmpdelarr forKey:key2];
            
            [self.tableView beginUpdates];
            [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:_ww inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
            [self.tableView endUpdates];
        }
        else
            [SVProgressHUD showErrorWithStatus:retobj.mmsg];
        
    }];
    

    
    
}

//取消订单
- (void)cancelAction:(UIButton *)sender{
    
    OrderCell *cell = (OrderCell*)[sender findSuperViewWithClass:[OrderCell class]];
    NSIndexPath *indexpath = [self.tableView indexPathForCell:cell];
    NSString *key2 = [NSString stringWithFormat:@"nowselectdata%d",nowSelect];
    NSArray *arr = [tempDic objectForKey:key2];
    SOrderObj *order = [arr objectAtIndex:indexpath.row];
    tempOrder = order;
    
    
    
    if(!tempOrder.mIsContactCancel){
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您确定要取消订单吗？" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
        //    [alert setAlertViewStyle:UIAlertViewStylePlainTextInput];
        [alert show];
    }else{
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示" message:[NSString stringWithFormat:@"商家已接单，如需取消订单请电话联系%@:%@",tempOrder.mShopName,tempOrder.mSellerTel] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"拨打", nil];
        //    [alert setAlertViewStyle:UIAlertViewStylePlainTextInput];
        [alert show];
        
        
    }
    
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    
    if (tempOrder.mIsContactCancel) {
        
        if (buttonIndex == 1){
            NSMutableString * mobile=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",tempOrder.mSellerTel];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:mobile]];
        }else{
            
            return;
        }
        
        
    }else{
        
        if (buttonIndex == 0) {
            
            [SVProgressHUD showWithStatus:@"正在取消..." maskType:SVProgressHUDMaskTypeClear];
            [tempOrder cancelThis:nil block:^(SResBase *resb) {
                if( resb.msuccess )
                {
                    [SVProgressHUD showSuccessWithStatus:resb.mmsg];
                    
                    [self.tableView reloadData];
                    
                }
                else
                    [SVProgressHUD showErrorWithStatus:resb.mmsg];
                
            }];
            
        }else{
            
            return;
        }

    }
    
}

//评价订单
- (void)PingjiaAction:(UIButton *)sender{
    
    OrderCell *cell = (OrderCell*)[sender findSuperViewWithClass:[OrderCell class]];
    NSIndexPath *indexpath = [self.tableView indexPathForCell:cell];
    NSString *key2 = [NSString stringWithFormat:@"nowselectdata%d",nowSelect];
    NSArray *arr = [tempDic objectForKey:key2];
    SOrderObj *order = [arr objectAtIndex:indexpath.row];
    
    CmmVC* vc = [[CmmVC alloc]initWithNibName:@"CmmVC" bundle:nil];
    vc.mtagOrder = order;
    [self pushViewController:vc];
}

//去支付
- (void)GoPayAction:(UIButton *)sender{
    
    OrderCell *cell = (OrderCell*)[sender findSuperViewWithClass:[OrderCell class]];
    NSIndexPath *indexpath = [self.tableView indexPathForCell:cell];
    NSString *key2 = [NSString stringWithFormat:@"nowselectdata%d",nowSelect];
    NSArray *arr = [tempDic objectForKey:key2];
    SOrderObj *order = [arr objectAtIndex:indexpath.row];
    
    PayView *payV = [[PayView alloc] initWithNibName:@"PayView" bundle:nil];
    payV.mTagOrder = order;
    [self pushViewController:payV];
}

//确认完成
- (void)comfirmAction:(UIButton *)sender{
    
    OrderCell *cell = (OrderCell*)[sender findSuperViewWithClass:[OrderCell class]];
    NSIndexPath *indexpath = [self.tableView indexPathForCell:cell];
    NSString *key2 = [NSString stringWithFormat:@"nowselectdata%d",nowSelect];
    NSArray *arr = [tempDic objectForKey:key2];
    SOrderObj *order = [arr objectAtIndex:indexpath.row];
    
    [SVProgressHUD showWithStatus:@"正在确认完成..." maskType:SVProgressHUDMaskTypeClear];
     NSInteger _ww = indexpath.row;
    [order confirmThis:^(SResBase *retobj) {
        if( retobj.msuccess )
        {
            [SVProgressHUD showSuccessWithStatus:@"操作成功"];
            order.mIsCanConfirm = NO;
            order.mIsCanRate = YES;
            
            [self.tableView beginUpdates];
            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:_ww inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
            [self.tableView endUpdates];
        }
        else
            [SVProgressHUD showErrorWithStatus:retobj.mmsg];
        
    }];
    
    
}

//去逛逛
- (void)GoAction:(UIButton *)sender{
    
    self.tabBarController.selectedIndex = 0;
}





- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *key2 = [NSString stringWithFormat:@"nowselectdata%d",nowSelect];
    NSArray *arr = [tempDic objectForKey:key2];
    
    SOrderObj *order = [arr objectAtIndex:indexPath.row];
    
    [OrderDetailVC whereToGo:order vc:self];
}

-(void)headerBeganRefresh
{
    self.page = 1;
    
    [self headerEndRefresh];

 
    
    [[SUser currentUser]  getMyOrders: [self.type intValue]  status: nowSelect page:(int)self.page block:^(SResBase *resb, NSArray *all,int num) {
        [self headerEndRefresh];
        
        if (resb.msuccess) {
            NSString *key2 = [NSString stringWithFormat:@"nowselectdata%d",nowSelect];
            
            [tempDic setObject:all forKey:key2];
            if (all.count==0) {
                [self addEmptyViewWithImg:@"noitem"];
            }else
            {
                [self removeEmptyView];
            }
            
            [self.tableView reloadData];
            
            [_mMiddleBT setTitle:[NSString stringWithFormat:@"待评价（%d）",num] forState:UIControlStateNormal];
        }else
        {
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
        
        [self.tableView reloadData];
        
    }];
    
    
}
-(void)footetBeganRefresh
{
    

    
    self.page ++;
    
    
    [[SUser currentUser]getMyOrders:[self.type intValue] status: nowSelect page:(int)self.page block:^(SResBase *resb, NSArray *all,int num) {
        [self footetEndRefresh];
        
        if (resb.msuccess) {
            NSString *key2 = [NSString stringWithFormat:@"nowselectdata%d",nowSelect];
            
            NSArray *oldarr = [tempDic objectForKey:key2];
            
            [_mMiddleBT setTitle:[NSString stringWithFormat:@"待评价（%d）",num] forState:UIControlStateNormal];
            
            if (all.count!=0) {
                [self removeEmptyView];
                
                
                NSMutableArray *array = [NSMutableArray array];
                if (oldarr) {
                    [array addObjectsFromArray:oldarr];
                }
                [array addObjectsFromArray:all];
                [tempDic setObject:array forKey:key2];
            }else
            {
                if(!oldarr||oldarr.count==0)
                {
                    [SVProgressHUD showSuccessWithStatus:@"暂无数据"];
                }
                else
                    [SVProgressHUD showSuccessWithStatus:@"暂无新数据"];
                //   [self addEmptyView:@"暂无数据"];
                
            }
            [self.tableView reloadData];
            
        }else
        {
            [SVProgressHUD showErrorWithStatus:resb.mmsg];
            // [self addEmptyView:resb.mmsg];
        }
    }];
    
}

- (IBAction)TopClick:(id)sender {
    
    UIButton *button = (UIButton *)sender;
    
    if (tempBtn == sender&&button.tag !=12) {
        return;
    }
    else
    {
        if (button.tag ==10) {
            NSLog(@"left");
            nowSelect = 0;
        }
        else if(button.tag == 11)
        {
            nowSelect = 1;
            NSLog(@"mid");
        }
    
        NSString *key1 = [NSString stringWithFormat:@"nowselectdata%d",nowSelect];
        
        if (![tempDic objectForKey:key1]) {
            
            [self.tableView headerBeginRefreshing];
        }
        else
        {
            NSArray *ary = [tempDic objectForKey:key1];
            if (ary.count>0) {
                [self removeEmptyView];
            }else{
                [self addEmptyViewWithImg:@"noitem"];
            }
            [self.tableView reloadData];
        }
        
        [tempBtn setBackgroundColor:COLOR(239, 240, 241)];
        [sender setBackgroundColor:[UIColor whiteColor]];
        tempBtn = sender;
        
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
