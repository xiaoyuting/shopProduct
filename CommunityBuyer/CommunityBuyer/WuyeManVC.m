//
//  WuyeManVC.m
//  CommunityBuyer
//
//  Created by zzl on 16/1/25.
//  Copyright © 2016年 zdq. All rights reserved.
//

#import "WuyeManVC.h"
#import "WuyeNotif.h"
#import "AuthVC.h"
#import "VillageVC.h"
#import "OwnerInfoVC.h"
#import "AnnouncementVC.h"
#import "FaultRepairVC.h"
#import "PropertyIntroduceVC.h"
#import "AccessControlVC.h"
@interface WuyeManVC ()

@end

@implementation WuyeManVC
{
    WuyeNotif*  _noiftvc;
    SAuth*      _authobj;
    int         _mstep;
    
    int         _disid;//小区ID
    
}
- (void)viewDidLoad {
    
    self.hiddenTabBar = YES;
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.mPageName = @"物业";
    self.Title = @"物业";
    _disid = -1;
    
    self.mheadimg.layer.cornerRadius = self.mheadimg.bounds.size.height / 2;
}

-(void)rightBtnTouched:(UIButton*)sender
{
    NSString* ss = [sender titleForState:UIControlStateNormal];
    if( ss.length == 0 )
    {
        return;
    }
    
    VillageVC* vc = [[VillageVC alloc]initWithNibName:@"VillageVC" bundle:nil];
    vc.mitblock = ^(SDistrict* selectobj)
    {
        _disid = selectobj.mId;
    };
    [self pushViewController:vc];
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [SVProgressHUD showWithStatus:@"加载中..." maskType:SVProgressHUDMaskTypeClear];
    [SAuth getMyWuye:_disid block:^(SResBase *resb, SAuth *retobj) {
        
        [SVProgressHUD dismiss];
        [self updatePage:resb auth:retobj];
        
    }];
}

-(void)updatePage:(SResBase*)resb auth:(SAuth*)auth
{
    NSString* errstr = @"";
    NSString* errbt = @"";
    _mstep = 0;
    if( resb.msuccess )
    {
        if( auth.mId == 0 && auth.mName.length == 0 )
        {
            //没有对象,,就需要选择小区
            errstr = @"您需要先选择小区才可以申请物业";
            errbt = @"马上去选择";
            _mstep = 1;
        }
        else
        {
            /*
             @property (nonatomic,assign)    int             mIsProperty;//	int	否			是否开通物业1、需要开通
             @property (nonatomic,assign)    int             mIsVerify;//	int	否			是否申请验证1、需要申请
             @property (nonatomic,assign)    int             mIsCheck;//	int	否			是否通过验证1、需要验证
             */
            if( auth.mIsProperty == 1 )
            {//没有开通物业
                errstr = [NSString stringWithFormat:@"很抱歉,%@未开通物业板块", auth.mName];
                errbt = @"重新选择小区";
                _mstep = 2;
            }else
            if( auth.mIsVerify == 1 )
            {//需要验证,,没有身份验证
                errstr = @"您未进行身份验证";
                errbt = @"去验证";
                _mstep = 3;
            }
            else
            if( auth.mIsCheck == 1 )
            {
                errstr = @"您的身份信息已提交审核,请耐心等待";
                errbt = @"去首页逛逛";
                _mstep = 4;
            }
        }
        _authobj = auth;
    }
    else
    {
        errbt = @"刷新重试";
        errstr = resb.mmsg;
    }
    
    if( errbt.length && errstr.length )
    {
        if( _noiftvc == nil )
        {
            _noiftvc = [[WuyeNotif alloc]initWithNibName:@"WuyeNotif" bundle:nil];
        }
        [self addChildViewController: _noiftvc];
        [self.view addSubview:_noiftvc.view];
        
        CGRect f=  _noiftvc.view.frame;
        f.size.width = DEVICE_Width;
        f.origin.x = 0;
        f.origin.y = 100;
        _noiftvc.view.frame = f;
        
        self.mwaper.hidden = YES;
        
        _noiftvc.mtxt.text = errstr;
        [_noiftvc.mbt setTitle:errbt forState:UIControlStateNormal];
        [_noiftvc.mbt addTarget:self action:@selector(errbtblicked:) forControlEvents:UIControlEventTouchUpInside];
        self.rightBtnTitle = @"";
        self.Title = @"物业";
    }
    else
    {
        self.mwaper.hidden = NO;
        [_noiftvc.view removeFromSuperview];
        [_noiftvc removeFromParentViewController];
        [_noiftvc.mbt removeTarget:self action:@selector(errbtblicked:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.mheadimg sd_setImageWithURL:[NSURL URLWithString:[SUser currentUser].mHeadImgURL] placeholderImage:[UIImage imageNamed:@"defultHead"]];
        self.mname.text = _authobj.mName;
        self.mtel.text = _authobj.mMobile;
        self.mandyuan.text = [NSString stringWithFormat:@"%@#%@",_authobj.mBuild.mName,_authobj.mRoom.mRoomNum];
                
        self.rightBtnTitle = @"切换";
        self.Title = _authobj.mDistrict.mSellerName;
        
        [self doorfunc: [GInfo shareClient].mIsOpenProperty];
    }
}
-(void)errbtblicked:(UIButton*)sender
{
    switch (_mstep ) {
        case 1:
        //选择小区
        case 2:
        {//重新选择
            VillageVC * vc = [[VillageVC alloc]initWithNibName:@"VillageVC" bundle:nil];
            vc.mitblock = ^(SDistrict* selectobj)
            {
                _disid = selectobj.mId;
            };
            [self pushViewController:vc];
        }
            break;
        
        case 3:
        {//验证身份
            
            AuthVC * vc = [[AuthVC alloc]initWithNibName:@"AuthVC" bundle:nil];
            vc.mAuthInfo = _authobj;
            [self pushViewController:vc];
        }
            break;
        case 4:
        {//去首页
            self.tabBarController.selectedIndex = 0;

        }
            break;
            
            
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)gonggao:(id)sender {
    
    AnnouncementVC* vc = [[AnnouncementVC alloc]initWithNibName:@"AnnouncementVC" bundle:nil];
    vc.msellerid = _authobj.mSellerId;
    [self pushViewController:vc];
    
}

- (IBAction)baoXiug:(id)sender {
    
    FaultRepairVC* vc = [[FaultRepairVC alloc]initWithNibName:@"FaultRepairVC" bundle:nil];
    vc.mtagDistrict = _authobj.mDistrict;
    [self pushViewController:vc];
}

- (IBAction)JieSao:(id)sender {
    PropertyIntroduceVC * vc = [[PropertyIntroduceVC alloc]initWithNibName:@"PropertyIntroduceVC" bundle:nil];
    vc.mtagSeller = SSeller.new;
    vc.mtagSeller.mId = _authobj.mDistrict.mId;
    [self pushViewController:vc];
}

- (IBAction)opendoor:(id)sender {
    
    [self dealDoor];
    
}

-(void)showApplyDoor
{
    UIAlertView* vc = [[UIAlertView alloc]initWithTitle:@"申请门禁钥匙" message:@"您暂未开通门禁功能,点击申请门禁钥匙之后,请到物业办理门禁手机开锁功能" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"申请门禁钥匙", nil];
    vc.tag = 88;
    [vc show];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if( buttonIndex != 0 )
    {
        [SVProgressHUD showWithStatus:@"正在获取门禁数据..." maskType:SVProgressHUDMaskTypeClear];
        [_authobj.mDistrict checkDoor:^(SAuth *retobj, SResBase *resb) {
            
            if( resb.msuccess )
            {
                if( retobj.mAccessStatus == 1 )
                {//通过了,就更新到用户信息里面
                    
                    _authobj = retobj;
                    [SVProgressHUD dismiss];
                    
                    //跳转到开门
                    AccessControlVC* vc = [[AccessControlVC alloc]initWithNibName:@"AccessControlVC" bundle:nil];
                    vc.mVillagesid = _authobj.mDistrict.mId;
                    [self pushViewController:vc];
                    
                }
                else
                    [SVProgressHUD showErrorWithStatus:resb.mmsg];
            }
            else
            {
                [SVProgressHUD showErrorWithStatus:resb.mmsg];
            }
            
        }];
    }
}

-(void)dealDoor
{
    if( [SUser isNeedLogin] )
    {
        [self gotoLoginVC];
    }
    else if( _authobj.mAccessStatus != 1 )
    {//如果需要申请门禁
        [self showApplyDoor];
    }
    else
    {
        //直接开门了
        AccessControlVC* vc = [[AccessControlVC alloc]initWithNibName:@"AccessControlVC" bundle:nil];
        vc.mVillagesid = _authobj.mDistrict.mId;
        [self pushViewController:vc];
    }
}

- (IBAction)yezhudetail:(id)sender {

    OwnerInfoVC*  vc = [[OwnerInfoVC alloc]initWithNibName:@"OwnerInfoVC" bundle:nil];
    vc.mtagAuth = _authobj;
    [self pushViewController:vc];
    
}

-(void)doorfunc:(BOOL)bshow
{
    if( bshow )
    {
        self.mdoorfun.hidden = NO;
        self.mdoorhiconst.constant = DEVICE_Width/3;
    }
    else
    {
        self.mdoorfun.hidden = YES;
        self.mdoorhiconst.constant = 0;
    }
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
