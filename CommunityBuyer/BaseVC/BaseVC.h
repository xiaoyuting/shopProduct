//
//  BaseVC.h
//  testBase
//
//  Created by ljg on 15-2-27.
//  Copyright (c) 2015年 ljg. All rights reserved.
//
#import "NavBar.h"
#import "MJRefreshBaseView.h"
#import "MJRefresh.h"
#import "TabBar.h"
#import "ContentScrollView.h"
#import "EmptyView.h"

@interface BaseVC : UIViewController<NavBarDelegate,TabBarDelegate>

@property (nonatomic,assign)BOOL  isStoryBoard;
@property (nonatomic,strong)    NSString* mPageName;
@property (nonatomic,strong) NavBar *navBar;
@property (nonatomic,strong)ContentScrollView *contentView;
@property (nonatomic,assign)BOOL  hiddenTabBar;         //是否需要tabbar 必须写在[super loadview]之前
@property (nonatomic,assign)BOOL  hiddenNavBar;         //是否需要navbar 同上
@property (nonatomic,assign)BOOL  hiddenBackBtn;        //是否需要navbar 同上
///隐藏右边navbar的竖线
@property (nonatomic,assign)BOOL  hiddenlll;        //是否需要navbar 同上

@property (nonatomic,assign)BOOL  hiddenA;        //是否需要navbar 同上
@property (nonatomic,assign)BOOL  hiddenB;        //是否需要navbar 同上
@property (nonatomic,strong) NSString *rightBtnTitle;   //navbar右边按钮title
@property (nonatomic,strong) NSString *ABtnTitle;   //navbar右边按钮title
@property (nonatomic,strong) NSString *BBtnTitle;   //navbar右边按钮title
@property (nonatomic,strong) NSString *Title;           //navbartitle
@property (nonatomic,strong) NSString *AddressTitle;
@property (nonatomic,strong) UIImage *rightBtnImage;    //navbarimage
@property (nonatomic,assign) BOOL haveHeader;           //navbarimage
@property (nonatomic,assign) BOOL haveFooter;           //navbarimage
@property (nonatomic,strong) UITableView *tableView;    //navbartitle
@property (nonatomic,strong)    NSMutableArray *tempArray; //tableview存储数据数组
@property (nonatomic,assign)   int  page;               //tableview翻页
@property (nonatomic,strong) TabBar *tabBar;            //tabbar
@property (nonatomic,assign)    BOOL    isMustLogin;//不需要登陆就可以进入该页面,否则就先跳转到登陆界面,pushViewController里面判断的
-(void)addNotifacationStatus:(NSString *)str;   
-(void)removeNotifacationStatus;
-(void)leftBtnTouched:(id)sender;                       //左边navbar事件
-(void)rightBtnTouched:(id)sender;                      //右边navbar事件
-(void)ATouched:(id)sender;                       //左边navbar事件
-(void)BTouched:(id)sender;                      //右边navbar事件

-(void)setABtnTitle:(NSString *)ABtnTitle;                //RightBtntitle Set方法
-(void)setBBtnTitle:(NSString *)BBtnTitle;                //RightBtntitle Set方法

-(void)setHiddenABtn:(BOOL)hiddenA;
-(void)setHiddenBBtn:(BOOL)hiddenB;
-(void)setHiddenRightBtn:(BOOL)hiddenRightBtn;
-(void)setHiddenlll:(BOOL)hiddenlll;
-(void)setTitle:(NSString *)test;                       //title Set方法
-(void)setAtributTitle:(NSAttributedString *)test;

-(void)setRightBtnTitle:(NSString *)str;                //RightBtntitle Set方法
-(void)setRightBtnImage:(UIImage *)rightImage;          //RightBtnimage Set方法
-(void)popViewController;                               //返回上个controller
-(void)popViewController_2;                             //返回上上个controller
-(void)popViewController_3;                             //返回上上上个controller
-(void)popToRootViewController;                         //返回rootController
-(void)pushViewController:(UIViewController *)vc;       //跳转到某个controller
-(void)setToViewController:(UIViewController *)vc;       //直接设置过去
-(void)setToViewControllerNoAn:(UIViewController *)vc;


//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//如果实现这2个,就不用处理刷新列表和现实没有的情况的图标,等等,懒人模式,,
-(void)headerBeganRefreshWithBlock:(void(^)(SResBase* resb,NSArray* all))block;
-(void)footetBeganRefreshWithBlock:(void(^)(SResBase* resb,NSArray* all))block;

//如果实现这2个,就是需要自己处理刷新的问题,
-(void)headerBeganRefresh;                              //header刷新
-(void)footetBeganRefresh;                              //footer刷新
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

-(void)headerEndRefresh;                                //header停止刷新
-(void)footetEndRefresh;                                //footer停止刷新
-(void)loadTableView:(CGRect)rect delegate:(id<UITableViewDelegate>)delegate dataSource:(id<UITableViewDataSource>)datasource;
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section;//tableview代理 用来在没数据的情况下隐藏分割线
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section;//同上
-(void)setHaveHeader:(BOOL)haveHeader;                  //set方法
-(void)setHaveFooter:(BOOL)haveFooter;                  //set方法
-(void)setHiddenBackBtn:(BOOL)hiddenBackBtn;
-(void)addEmptyView:(NSString *)str;                    //空数据添加view 参数:需要显示得内容
-(void)addEmptyViewWithImg:(NSString *)img;
-(void)addSearchEmptyViewWithImg:(NSString *)img;
-(void)addEmptyViewWithStr:(NSString *)str andImg:(NSString *)img;


-(void)addMEmptyView:(UIView *)view rect:(CGRect)rect;  //数据为空时，添加view
-(void)addMEmptyView:(UIView *)view rect:(CGRect)rect imageName:(NSString *)image labelText:(NSString *)text buttonTitle:(NSString *)title;
-(void)removeMEmptyView;                                //移除空数据背景
-(void)reloadData;                                      //重现加载



-(void)removeEmptyView;                                 //移除空数据view
-(void)showWithStatus:(NSString *)str;                  //调用svprogresssview加载框 参数：加载时显示的内容
-(void)dismiss;                                         //隐藏svprogressview
-(void)showSuccessStatus:(NSString *)str;               //展示成功状态svprogressview 参数:成功状态显示字符串
-(void)showErrorStatus:(NSString *)astr;                 //展示失败状态svprogressview 参数:失败状态显示字符串
-(void)checkUserGinfo;
//加载tabview

-(void)gotoLoginVC;
-(void)gotoLoginVC:(UIViewController *)viewcontroller;

-(void)setRightBtnWidth:(CGFloat)size;              //setRightBtnWidth Set方法

@end
