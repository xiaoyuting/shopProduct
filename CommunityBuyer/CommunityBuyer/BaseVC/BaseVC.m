//
//  BaseVC.m
//  testBase
//
//  Created by ljg on 15-2-27.
//  Copyright (c) 2015年 ljg. All rights reserved.
//

#import "BaseVC.h"
#import "MTA.h"
#import "LoginVC.h"
#import "UILabel+myLabel.h"

@interface BaseVC ()<UIGestureRecognizerDelegate>
{
    UIView *emptyView;
    UIView *notifView;
    EmptyView *memptyView;
}
@end

@implementation BaseVC
-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if( self ) {
       self.isStoryBoard = nibNameOrNil != nil;
        NSLog(@"<------isnib");
    }
    return self;
}

- (id)init
{
    self = [super init];
    if (self) {
      
        NSLog(@"--------->isnotnib");

    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    
    self.isStoryBoard = YES;
    return [super initWithCoder:aDecoder];
}

-(void)setHiddenBackBtn:(BOOL)hiddenBackBtn
{
    self.navBar.leftBtn.hidden = hiddenBackBtn;
}
-(void)setHiddenlll:(BOOL)hiddenlll{
    self.navBar.lll.hidden = hiddenlll;
}

-(void)addNotifacationStatus:(NSString *)str
{
    if (!notifView) {
        notifView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DEVICE_Width, 50)];
        self.contentView.clipsToBounds = NO;
        UILabel *label = [[UILabel alloc]initWithFrame:notifView.bounds];
        label.text =str;
        label.font = [UIFont systemFontOfSize:13];
        label.textColor = [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentCenter;
        notifView.backgroundColor = COLOR(88, 88, 88);
        notifView.alpha = 0.0;
       // label.backgroundColor = [UIColor redColor];
        [notifView addSubview:label];
    }
    [self.contentView addSubview:notifView];

    [self notifViewAnimation:YES];
}
-(void)notifViewAnimation:(BOOL)isbegan
{
    if (isbegan) {
        [UIView animateWithDuration:1 animations:^{
//            CGRect rect = notifView.frame;
//            rect.origin.y=0;
//            notifView.frame = rect;
            notifView.alpha = 1.0;
        }];
    }else
    {
        [UIView animateWithDuration:1 animations:^{
//            CGRect rect = notifView.frame;
//            rect.origin.y=-50;
//            notifView.frame = rect;
               notifView.alpha = 0.0;
        }completion:^(BOOL finished) {
            [notifView removeFromSuperview];
            notifView = nil;
        }];
    }
}
-(void)removeNotifacationStatus
{
    [self notifViewAnimation:NO];
}
- (void)hideTabBar {
    if (self.tabBarController.tabBar.hidden == YES) {
        return;
    }
    UIView *contentView;
    if ( [[self.tabBarController.view.subviews objectAtIndex:0] isKindOfClass:[UITabBar class]] )
        contentView = [self.tabBarController.view.subviews objectAtIndex:1];
    else
        contentView = [self.tabBarController.view.subviews objectAtIndex:0];
    contentView.frame = CGRectMake(contentView.bounds.origin.x,  contentView.bounds.origin.y,  contentView.bounds.size.width, contentView.bounds.size.height + self.tabBarController.tabBar.frame.size.height);
    self.tabBarController.tabBar.hidden = YES;

}

- (void)viewDidAppear:(BOOL)animated{

    [super viewDidAppear:animated];
    
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if( !_mPageName )
    {
        NSLog(@"page not name:%@",[self description]);
        assert(_mPageName);
    }
    [MTA trackPageViewBegin:self.mPageName];
    MLLog_VC("viewWillAppear");

   
    if (self.hiddenTabBar) {
         self.tabBarController.tabBar.hidden = YES;
    }else{
        self.tabBarController.tabBar.hidden = NO;
    }

}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //MLLog_VC("viewWillDisappear");

    [MTA trackPageViewEnd:self.mPageName];
    
    [SVProgressHUD dismiss];

}
-(void)setHaveHeader:(BOOL)have
{
    __block BaseVC *vc = self;

    if(have){
        [self.tableView addHeaderWithCallback:^{
            //[vc headerBeganRefresh];
            [vc headerBeganRefreshWithBlock:^(SResBase *resb, NSArray *all) {
                
                [vc headerEndRefresh];
                [vc.tempArray removeAllObjects];
                if (resb.msuccess) {
                    [vc.tempArray addObjectsFromArray: all];
                }
                else
                {
                    [SVProgressHUD showErrorWithStatus:resb.mmsg];
                }
                
                if ( vc.tempArray.count == 0 )
                {
                    [vc addEmptyViewWithImg:@"noitem"];
                }
                else
                {
                    [vc removeEmptyView];
                }
                
                [vc.tableView reloadData];
                
             }];
            
        }];
    }
    
}
-(void)setHaveFooter:(BOOL)haveFooter
{
    __block BaseVC *vc = self;
    
    if (haveFooter) {
        [self.tableView addFooterWithCallback:^{
            //[vc footetBeganRefresh];
            [vc footetBeganRefreshWithBlock:^(SResBase *resb, NSArray *all) {
                
                [vc footetEndRefresh];
                if (resb.msuccess) {
                    [vc.tempArray addObjectsFromArray: all];
                    [vc.tableView reloadData];
                }
                else
                {
                    [SVProgressHUD showErrorWithStatus:resb.mmsg];
                }
                
                if ( vc.tempArray.count == 0 )
                {
                    [vc addEmptyViewWithImg:@"noitem"];
                }
                else
                {
                    [vc removeEmptyView];
                }
            }];
        }];
    }
}
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
//    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBarHidden = YES;
    self.view.backgroundColor = M_BGCO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    if ( [self.Title isEmpty] )
    {
        self.Title = @"base";
    }
    
    CGFloat offsetY = 0.0f;
    CGFloat contentH = DEVICE_Height;
    
    if( self.hiddenNavBar  )
    {
        //如果不要导航拦,顶部就从0开始了
        offsetY = 0.0f;
    }
    else
    {
        //如果需要,就要从导航栏下面开始
        offsetY = DEVICE_NavBar_Height;
        self.navBar =  [[NavBar alloc]init];
        self.navBar.NavDelegate = self;
        self.navBar.backgroundColor = M_NAVCO;
        [self.view addSubview: self.navBar ];
    }
    contentH  -= offsetY;
    
    if( self.hiddenTabBar )
    {
        //如果不要下面的Tab,
        self.tabBarController.tabBar.hidden = YES;
    }
    else
    {
        self.tabBarController.tabBar.hidden = NO;//这个不行,要处理下,
        //如果需要,
        contentH  -= DEVICE_TabBar_Height;
    }
    
    
    if ( !self.isStoryBoard )
    {//如果不是XIB或者 storybaord,,,就自己处理这个问题
        self.contentView = [[ContentScrollView alloc]initWithFrame:CGRectMake(0, offsetY, DEVICE_Width, contentH)];
        self.contentView.backgroundColor = M_BGCO;
        [self.view addSubview:self.contentView];
        self.automaticallyAdjustsScrollViewInsets = NO;//这个是处理XIB的时候,要空20的时候,..这么放到这里面了
    }
    
    self.tempArray = [[NSMutableArray alloc]init];
    self.page = 0;
    
    
}

-(void)headerBeganRefreshWithBlock:(void(^)(SResBase* resb,NSArray* all))block
{
    [self headerBeganRefresh];
}
-(void)footetBeganRefreshWithBlock:(void(^)(SResBase* resb,NSArray* all))block
{
    [self footetBeganRefresh];
    
}

-(void)headerBeganRefresh
{
    [self headerEndRefresh];

    //todo
}
-(void)footetBeganRefresh
{
    [self footetEndRefresh];
    //todo
}

-(void)headerEndRefresh{
    [self.tableView headerEndRefreshing];
}//header停止刷新
-(void)footetEndRefresh{
    [self.tableView footerEndRefreshing];
}//footer停止刷新
-(void)loadTableView:(CGRect)rect delegate:(id<UITableViewDelegate>)delegate dataSource:(id<UITableViewDataSource>)datasource
{
    self.tableView = [[UITableView alloc]initWithFrame:rect];
    self.tableView.delegate = delegate;
    self.tableView.dataSource = datasource;
    
    
    if(!self.isStoryBoard)
    {
        [self.contentView addSubview:self.tableView];
    }else
    {
        [self.view addSubview:self.tableView];
    }
    
}

-(void)leftBtnTouched:(id)sender
{
    [self dismiss];
    [self popViewController];
    //todo
}
-(void)rightBtnTouched:(id)sender
{
    //todo
}
- (void)ABtnTouched:(id)sender{
    
}
- (void)BBtnTouched:(id)sender{
    
}
- (void)setHiddenA:(BOOL)hiddenA{
    self.navBar.ABtn.hidden = hiddenA;
}
- (void)setHiddenB:(BOOL)hiddenB{
    self.navBar.BBtn.hidden = hiddenB;
}

-(void)setTitle:(NSString *)str
{
    _Title = str;
    self.navBar.titleLabel.text = str;
}



- (void)setAddressTitle:(NSString *)AddressTitle
{
    _Title = AddressTitle;
    self.navBar.titleLabel.text = AddressTitle;
    
    if( self.navBar.ImageV == nil )
    {
        self.navBar.ImageV = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,13, 8)];
        [self.navBar addSubview:self.navBar.ImageV];
    }
    self.navBar.ImageV.image = [UIImage imageNamed:@"huiDownjiantou"];

    if( ([[UIScreen mainScreen] bounds].size.height <= 568.0) )
        [self.navBar.titleLabel autoReSizeWidthForContent:180];
    else
        [self.navBar.titleLabel autoReSizeWidthForContent:220];
    
    self.navBar.titleLabel.center = CGPointMake( self.navBar.bounds.size.width/2, self.navBar.bounds.size.height/2+10);
    self.navBar.ImageV.center = self.navBar.titleLabel.center;
    [Util relPosUI:self.navBar.titleLabel dif:5 tag:self.navBar.ImageV tagatdic:E_dic_r];
    
}

-(void)setAtributTitle:(NSAttributedString *)test{

    _Title = [test string];
    
    self.navBar.titleLabel.attributedText = test;
}

- (void)setABtnTitle:(NSString *)ABtnTitle
{
    [self.navBar.ABtn setImage:nil forState:UIControlStateNormal];
    [self.navBar.ABtn setTitle:ABtnTitle forState:UIControlStateNormal];
}
- (void)setBBtnTitle:(NSString *)BBtnTitle
{
    [self.navBar.BBtn setImage:nil forState:UIControlStateNormal];
    [self.navBar.BBtn setTitle:BBtnTitle forState:UIControlStateNormal];
}

-(void)setRightBtnTitle:(NSString *)str
{
    [self.navBar.rightBtn setImage:nil forState:UIControlStateNormal];
    [self.navBar.rightBtn setTitle:str forState:UIControlStateNormal];
}

-(void)addMEmptyView:(UIView *)view rect:(CGRect)rect{
    
    memptyView = [EmptyView shareView];
    
    if (rect.size.width>0) {
        
        memptyView.frame = rect;
    }else{
        CGRect rect2 = memptyView.frame;
        rect2.origin.y = 64;
        rect2.size.width = DEVICE_Width;
        rect2.size.height = DEVICE_InNavBar_Height;
        memptyView.frame = rect2;
    }
    [view addSubview:memptyView];
    
}

-(void)addMEmptyView:(UIView *)view rect:(CGRect)rect imageName:(NSString *)image labelText:(NSString *)text buttonTitle:(NSString *)title{

    if( memptyView ) return;//如果有,,就不管了
    
    EmptyView * maybeold = memptyView;
    
    
    memptyView = [EmptyView shareView2];
    
    if (rect.size.width>0) {
        
        memptyView.frame = rect;
    }else{
        CGRect rect2 = memptyView.frame;
        rect2.origin.y = 64;
        rect2.size.width = DEVICE_Width;
        rect2.size.height = DEVICE_InNavBar_Height;
        memptyView.frame = rect2;
    }
    
    if (image.length>0) {
        memptyView.mImg.image = [UIImage imageNamed:image];
    }
    
    if (text.length>0) {
        memptyView.mLabel.text = text;
    }
    
    if (title.length>0) {
        [memptyView.mButton setTitle:title forState:UIControlStateNormal];
    }
    
    [memptyView.mButton addTarget:self action:@selector(ReloadClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [view addSubview:memptyView];
    
    if( maybeold )
    {
        [maybeold removeFromSuperview];
        maybeold = nil;
    }
    
}

- (void)ReloadClick:(UIButton *)sender{

    [self reloadData];
    
}



-(void)removeMEmptyView{
    
    [memptyView removeFromSuperview];
    memptyView = nil;
}

-(void)addEmptyView:(NSString *)str
{
//    return [self addEmptyViewWithImg:nil];
    
    if (emptyView) {
        [self.tableView addSubview:emptyView];
        return;
    }
    emptyView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DEVICE_Width, 200)];
    emptyView.backgroundColor = [UIColor clearColor];
    UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(150, 40, 43, 43)];
    image.center = CGPointMake(emptyView.bounds.size.width / 2, emptyView.frame.size.height / 2-40) ;
    image.image = [UIImage imageNamed:@"noitem"];
    [emptyView addSubview:image];
    UIButton *addBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 250, 60)];
    [addBtn setCenter:CGPointMake(emptyView.bounds.size.width / 2, emptyView.frame.size.height / 2+20)];
    [addBtn setTitle:str forState:UIControlStateNormal];
    [addBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    //  [addBtn addTarget:self action:@selector(addbtnTouched) forControlEvents:UIControlEventTouchUpInside];
    [emptyView addSubview:addBtn];
    self.tableView.tableFooterView = emptyView;
}
-(void)addSearchEmptyViewWithImg:(NSString *)img
{
    if( img == nil )
        img = @"ic_empty";
    
    if (emptyView) {
        [self.tableView addSubview:emptyView];
        return;
    }
    
    emptyView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DEVICE_Width, DEVICE_Width-15)];
    emptyView.backgroundColor = [UIColor clearColor];
    UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(150, 40, 250, 50)];
    image.center = CGPointMake(emptyView.bounds.size.width / 2, emptyView.frame.size.height / 2-40) ;
    image.image = [UIImage imageNamed:img];
    [emptyView addSubview:image];
    
    //    UIButton *addBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 250, 60)];
    //    [addBtn setCenter:CGPointMake(emptyView.bounds.size.width / 2, emptyView.frame.size.height / 2+20)];
    //    [addBtn setTitle:str forState:UIControlStateNormal];
    //    [addBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    //    [emptyView addSubview:addBtn];
    //
    self.tableView.tableFooterView = emptyView;
}
-(void)addEmptyViewWithImg:(NSString *)img
{
    if( img == nil )
        img = @"ic_empty";
    
    if (emptyView) {
        [self.tableView addSubview:emptyView];
        return;
    }
    
    emptyView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DEVICE_Width, 230)];
    emptyView.backgroundColor = [UIColor clearColor];
    UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(150, 40, 157, 150)];
    image.center =emptyView.center;
    image.image = [UIImage imageNamed:img];
    [emptyView addSubview:image];
    

//    
    self.tableView.tableFooterView = emptyView;
}


-(void)addEmptyViewWithStr:(NSString *)str andImg:(NSString *)img{

    if (emptyView) {
        [self.tableView addSubview:emptyView];
        return;
    }
    
    emptyView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DEVICE_Width, DEVICE_Width-15)];
    emptyView.backgroundColor = [UIColor clearColor];
    CGPoint point = emptyView.center;
    UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(150, 40, 45, 45)];
    image.center = CGPointMake(emptyView.bounds.size.width / 2, emptyView.frame.size.height / 2-40) ;
    image.image = [UIImage imageNamed:img];
    [emptyView addSubview:image];
}



-(void)removeEmptyView
{
    if (emptyView) {
        self.tableView.tableFooterView = nil;
        emptyView = nil;
    }
}



-(void)setRightBtnImage:(UIImage *)rightImage
{
    [self.navBar.rightBtn setTitle:nil forState:UIControlStateNormal];
    [self.navBar.rightBtn setImage:rightImage forState:UIControlStateNormal];
}
-(void)setRightBtnWidth:(CGFloat)size              //setRightBtnWidth Set方法
{
    CGRect rect = self.navBar.rightBtn.frame;
    self.navBar.rightBtn.frame = CGRectMake(DEVICE_Width-size, rect.origin.y, size, rect.size.height);
}
-(void)popViewController
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)popViewController_2
{
    NSMutableArray* vcs = [[NSMutableArray alloc]initWithArray:self.navigationController.viewControllers];
    if( vcs.count > 2 )
    {
        [vcs removeLastObject];
        [vcs removeLastObject];
        [self.navigationController setViewControllers:vcs   animated:YES];
    }
    else
        [self popViewController];
}

-(void)popViewController_3
{
    NSMutableArray* vcs = [[NSMutableArray alloc]initWithArray:self.navigationController.viewControllers];
    if( vcs.count > 3 )
    {
        [vcs removeLastObject];
        [vcs removeLastObject];
        [vcs removeLastObject];
        [self.navigationController setViewControllers:vcs   animated:YES];
    }
    else
        [self popViewController];
}
-(void)popToRootViewController{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
-(void)pushViewController:(UIViewController *)vc{
    if( [vc isKindOfClass:[BaseVC class] ] )
    {
        if( ((BaseVC*)vc).isMustLogin )
        {
            if( [SUser isNeedLogin] )
            {
                LoginVC *vclog = [[LoginVC alloc]init];
                vclog.tagVC = vc;
                [self pushViewController:vclog];//LoginVC,RegisterVC 里面的isMustLogin 一定不能设置了,否则递归
            }
            else
            {
                [self.navigationController pushViewController:vc animated:YES];
            }
        }
        else
            [self.navigationController pushViewController:vc animated:YES];
    }
    else
        [self.navigationController pushViewController:vc animated:YES];
}
-(void)setToViewController:(UIViewController *)vc
{
    NSMutableArray* vcs = [[NSMutableArray alloc]initWithArray:self.navigationController.viewControllers];
    [vcs removeLastObject];
    [vcs addObject:vc];
    [self.navigationController setViewControllers:vcs   animated:YES];
    
}
-(void)setToViewControllerNoAn:(UIViewController *)vc
{
    NSMutableArray* vcs = [[NSMutableArray alloc]initWithArray:self.navigationController.viewControllers];
    [vcs removeLastObject];
    [vcs addObject:vc];
    [self.navigationController setViewControllers:vcs   animated:NO];
    UIImage* vv = [self imageFromView: self.view];
    UIImageView* cimgview =[[UIImageView alloc]initWithFrame:self.view.bounds];
    cimgview.image = vv;
    [vc.view addSubview:cimgview];
    
    [UIView animateWithDuration:0.35 animations:^{
        
        cimgview.alpha = 0;
        
    } completion:^(BOOL finished) {
        
        [cimgview removeFromSuperview];
     }];
    
}
- (UIImage *)imageFromView: (UIView *) theView
{
    
    UIGraphicsBeginImageContext(theView.frame.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [theView.layer renderInContext:context];
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return theImage;
}
-(void)showWithStatus:(NSString *)str //调用svprogresssview加载框 参数：加载时显示的内容
{
    [SVProgressHUD showWithStatus:str maskType:SVProgressHUDMaskTypeClear];
}
-(void)dismiss //隐藏svprogressview
{
    [SVProgressHUD dismiss];
}
-(void)showSuccessStatus:(NSString *)str//展示成功状态svprogressview
{
    [SVProgressHUD showSuccessWithStatus:str];
}
-(void)showErrorStatus:(NSString *)astr//展示失败状态svprogressview
{
    [SVProgressHUD showErrorWithStatus:astr];
}
-(void)didSelectBtn:(NSInteger)tag
{


    switch (tag) {
        case 0:
            if (self.tabBarController.selectedIndex == 0) {

                return;

            }
            else
                self.tabBarController.selectedViewController = [self.tabBarController.viewControllers objectAtIndex:0];
            break;
        case 1:
            if (self.tabBarController.selectedIndex == 1) {
                return;
            }
            else

                self.tabBarController.selectedViewController = [self.tabBarController.viewControllers objectAtIndex:1];
            break;
        case 2:
            if (self.tabBarController.selectedIndex == 2) {
                return;
            }
            else
                self.tabBarController.selectedViewController = [self.tabBarController.viewControllers objectAtIndex:2];
            break;
        case 3:
            if (self.tabBarController.selectedIndex == 3) {
                return;
            }
            else
                self.tabBarController.selectedViewController = [self.tabBarController.viewControllers objectAtIndex:3];
            break;
        default:
            break;
    }
    /*
     CATransition *animation =[CATransition animation];
     [animation setDuration:0.5f];
     [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault]];
     [animation setType:kCATransitionFade];
     [animation setSubtype:kCATransitionFade];
     [self.view.layer addAnimation:animation forKey:@"change"];
     */
}


-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectZero];
    return view;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 5;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)gotoLoginVC
{
    if(  [[self.navigationController topViewController]isKindOfClass:[LoginVC class]] ) return;
    
    
    UIStoryboard *storyboard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    LoginVC *login = [storyboard instantiateViewControllerWithIdentifier:@"loginPwd"];
    login.isPwd = YES;
    
    
    [self presentViewController:login animated:YES completion:nil];
    
   //LoginVC,RegisterVC 里面的isMustLogin 一定不能设置了,否则递归
}

-(void)gotoLoginVC:(UIViewController *)viewcontroller{

    UIStoryboard *storyboard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    LoginVC *viewController = [storyboard instantiateViewControllerWithIdentifier:@"loginPwd"];
    viewController.mViewController = viewcontroller;
    viewController.isPwd = YES;
    
    [self presentViewController:viewController animated:YES completion:nil];
    
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
