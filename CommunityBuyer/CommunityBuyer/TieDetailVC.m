//
//  TieDetailVC.m
//  CommunityBuyer
//
//  Created by zzl on 16/1/8.
//  Copyright © 2016年 zdq. All rights reserved.
//

#import "TieDetailVC.h"
#import "TieRebackCell.h"
#import "IQTextView.h"
#import "ShowMenuVC.h"
#import "TieReportVC.h"
#import "FaultRepairVC.h"
#import "ZWImageWaperView.h"
#import "TieHeaderVC.h"

@interface TieDetailVC ()<UITableViewDataSource,UITableViewDelegate,ChooseMenuDelegate>

@end

@implementation TieDetailVC
{
    int                     _isLandlord;
    int                     _sort;
    
    int     _layoutcount;
    
    SForumPosts *   _rebacktag;
    ShowMenuVC*     _menuvc;
    
    TieHeaderVC*    _mtopheader;
    
    BOOL        _baddsel;
    
}
-(void)dealloc
{
    self.tableView = nil;
}

- (void)viewDidLoad {
    self.hiddenTabBar = YES;
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navBar.tag = 191817;
    
    self.mPageName = @"帖子详情";
    self.Title = self.mtagPost.mTitle;
    
    self.rightBtnImage = [UIImage imageNamed:@"ic_more"];
    
    self.tableView = self.mtabview;
    
    UINib * nib = [UINib nibWithNibName:@"TieRebackCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"cell"];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.haveFooter = YES;
    self.haveHeader = YES;
    
    self.minputreback.layer.cornerRadius = 3;

    _sort = 1;
    _isLandlord = NO;

    _rebacktag = self.mtagPost;
    self.minputreback.placeholder = @"回复精彩内容";
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textDidChangeedNotfi:) name:UITextViewTextDidChangeNotification object:nil];
    
    //[self.mimgwaper addObserver:self forKeyPath:@"bounds" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:NULL];
    _mtopheader = [[TieHeaderVC alloc]initWithNibName:@"TieHeaderVC" bundle:nil];
    [self addChildViewController:_mtopheader];
  
    /*
    
    CGRect f = _mtopheader.frame;
    f.origin.x = 0;
    f.origin.y = 0;
    f.size.width = DEVICE_Width;
    self.mtopheaer.frame = f;
    
    */
    
}
/*
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if( object == self.mimgwaper )
    {
        CGRect ffnew = [change[@"new"] CGRectValue];
        CGRect ffold = [change[@"old"] CGRectValue];
        if( ffnew.size.width != ffold.size.width )
        {
            [self updateMidImage];
        }
    }
}
*/
-(void)rightBtnTouched:(id)sender
{
    if( _menuvc == nil )
    {
        NSMutableArray* t = NSMutableArray.new;
        OneItem* one = OneItem.new;
        one.mNoramlTxt = @"查看全部";
        one.mSelectTxt  = @"只看楼主";
        one.mNoramlImg = [UIImage imageNamed:@"ic_looksome"];
        one.mSelectImg = one.mNoramlImg;
        [t addObject:one];
        
        one = OneItem.new;
        
        one.mNoramlTxt = @"升序查看";
        one.mSelectTxt  = @"倒序查看";
        one.mNoramlImg = [UIImage imageNamed:@"ic_sortorder"];
        one.mSelectImg = one.mNoramlImg;
        [t addObject:one];
        one = OneItem.new;
        
        one.mNoramlTxt = @"举报";
        one.mSelectTxt  = @"举报";
        one.mNoramlImg = [UIImage imageNamed:@"ic_report"];
        one.mSelectImg = one.mNoramlImg;
        [t addObject:one];
        
        _menuvc = [ShowMenuVC ShowItemMenu:self.view dataArr:t delegate:self];
    }
    else
    {
        [_menuvc  showIt];
    }
}

-(void)chooseMenuService:(int)index
{
    if( index == 0 )
    {
        _isLandlord = !_isLandlord;
        [self.tableView headerBeginRefreshing];
    }
    else if( index == 1 )
    {
        _sort = !_sort;
        [self.tableView headerBeginRefreshing];
    }
    else if( index == 2 )
    {
        TieReportVC * vc = [[TieReportVC alloc]initWithNibName:@"TieReportVC" bundle:nil];
        vc.mtagPost = self.mtagPost;
        [self pushViewController:vc];
        
       
    }
    else
    {
        NSLog(@"what index?");
    }
}

-(void)textDidChangeedNotfi:(NSNotification*)obj
{
    UITextView* tagtextview = obj.object;
    if( tagtextview == self.minputreback )
    {
        NSDictionary *tdic =  [NSDictionary dictionaryWithObjectsAndKeys:tagtextview.font,NSFontAttributeName, nil];
        
        CGSize  labelsize = [tagtextview.text boundingRectWithSize:CGSizeMake(tagtextview.bounds.size.width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:tdic context:nil].size;
//        if( ceil((labelsize.height/tagtextview.font.lineHeight)) >= 3 )
//        {
//            if( self.minputconsth.constant == 35.0f )
//                self.minputconsth.constant = tagtextview.bounds.size.height;
//            tagtextview.scrollEnabled = YES;
//        }
//        else
//        {
//            self.minputconsth.constant = 35.0f;
//            tagtextview.scrollEnabled = NO;
//        }
    }
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

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    if( self.tableView.tableHeaderView == nil )
    {
        self.tableView.tableHeaderView = _mtopheader.view;
        [self updatePage];
    }
    
}

-(void)updatePage
{
    if( !_baddsel )
    {
        [_mtopheader.mlikebt addTarget:self action:@selector(likeclicked:) forControlEvents:UIControlEventTouchUpInside];
        [_mtopheader.mrebackbt addTarget:self action:@selector(rebackclicked:) forControlEvents:UIControlEventTouchUpInside];
        [_mtopheader.mtelbt addTarget:self action:@selector(callPhone:) forControlEvents:UIControlEventTouchUpInside];
        _baddsel = YES;
    }
    
    
    [self updateTopUserInfo];
    [self updateMidImage];
    [self updateMidInfo];
    [self updateBottomInfo];
}

-(void)updateTopUserInfo
{
    NSString* url = self.mtagPost.mUser.mHeadImgURL;
    url = [Util makeImgUrl:url tagImg:_mtopheader.mheadimg];
    [_mtopheader.mheadimg sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"defultHead"]];
    _mtopheader.mheadimg.layer.cornerRadius =  _mtopheader.mheadimg.bounds.size.height/2;
    
    _mtopheader.mtitle.text = self.mtagPost.mUser.mUserName;
    _mtopheader.mcommname.text = [NSString stringWithFormat:@"来自%@",self.mtagPost.mPlate.mName];
    _mtopheader.mtime.text = self.mtagPost.mCreateTimeStr;
}

-(void)updateMidImage
{
    _mtopheader.mtietitle.text = self.mtagPost.mTitle;
    _mtopheader.mcontent.text  = self.mtagPost.mContent;
    
    if( self.mtagPost.mImagesArr.count )
    {
        [_mtopheader.mimgwaper showSomeImages:self.mtagPost.mImagesArr imgsblock:^(NSArray *allViewSize) {
            
            NSDictionary* one = allViewSize.lastObject;
            _mtopheader.mimgwaperconst.constant = [[one objectForKey:@"h"] floatValue];
            [_mtopheader.view layoutIfNeeded];
            
            NSLog(@"fff:%f", _mtopheader.mbottominfowaper.frame.origin.y );
            CGRect f = _mtopheader.view.frame;
            f.size.height =  _mtopheader.mbottominfowaper.frame.origin.y +  _mtopheader.mbottominfowaper.frame.size.height + 6;
            _mtopheader.view.frame = f;
            
            self.tableView.tableHeaderView = _mtopheader.view;
        }];
    }
    else
    {
        _mtopheader.mimgwaperconst.constant = 0;
        [_mtopheader.view layoutIfNeeded];
        
        NSLog(@"fff:%f", _mtopheader.mbottominfowaper.frame.origin.y );
        CGRect f = _mtopheader.view.frame;
        f.size.height =  _mtopheader.mbottominfowaper.frame.origin.y +  _mtopheader.mbottominfowaper.frame.size.height + 6;
        _mtopheader.view.frame = f;
        
        self.tableView.tableHeaderView = _mtopheader.view;
    }
    
}

-(void)updateMidInfo
{
    _mtopheader.mlikecount.text = [NSString stringWithFormat:@"%d", self.mtagPost.mGoodNum ];
    _mtopheader.mchatcount.text = [NSString stringWithFormat:@"%d", self.mtagPost.mRateNum ];
    _mtopheader.mlikeimg.image = self.mtagPost.mIsPraise ? [UIImage imageNamed:@"ic_likecount"] : [UIImage imageNamed:@"ic_nolike"];
    
    if ( self.mtagPost.mAddress ) {
        //地址
        
        _mtopheader.mName.text     =   self.mtagPost.mAddress.mName;
        _mtopheader.mPhone.text    =   self.mtagPost.mAddress.mMobile;
        _mtopheader.mAddress.text  =   self.mtagPost.mAddress.mAddress;
        _mtopheader.mAddressHeight.constant = 1000000;
        
    }else{
        _mtopheader.mAddressHeight.constant=0;
    }
    [_mtopheader.view layoutIfNeeded];
    self.tableView.tableHeaderView = _mtopheader.view;

    
}
-(void)updateBottomInfo
{
    [self.tableView headerBeginRefreshing];
    
}

-(void)headerBeganRefresh
{
    self.page = 1;
    [self.mtagPost getRebacks:self.page isLandlord:_isLandlord sort:_sort block:^(SResBase *resb, NSArray *all) {
        
        [self headerEndRefresh];
        
        [self.tempArray removeAllObjects];
        if( resb.msuccess )
        {
            [self.tempArray addObjectsFromArray: all];
        }
        else
        {
            [SVProgressHUD showErrorWithStatus:resb.mmsg];
        }
        
        if( self.tempArray.count == 0 )
        {
            [self addEmptyViewWithImg:nil];
        }
        else
        {
            [self removeMEmptyView];
        }
        
        [self.tableView reloadData];
        [self updateMidInfo];
        
    }];
}

-(void)footetBeganRefresh
{
    self.page++;
    [self.mtagPost getRebacks:self.page isLandlord:_isLandlord sort:_sort block:^(SResBase *resb, NSArray *all) {
        
        [self footetEndRefresh];
        if( resb.msuccess )
        {
            [self.tempArray addObjectsFromArray:all];
            [self.tableView reloadData];
        }
        else
        {
            [SVProgressHUD showErrorWithStatus:resb.mmsg];
        }
        
        if( self.tempArray.count == 0 )
        {
            [self addEmptyViewWithImg:nil];
        }
        else
        {
            [self removeMEmptyView];
        }
        
    }];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  UITableViewAutomaticDimension;
}
-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  UITableViewAutomaticDimension;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.tempArray.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TieRebackCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    SForumPosts* oneobj = self.tempArray[ indexPath.row];
    NSString * url = oneobj.mUser.mHeadImgURL;
    url = [Util makeImgUrl:url tagImg:cell.mheadimg];
    [cell.mheadimg sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"defultHead"]];
    cell.mname.text = oneobj.mUser.mUserName;
    
    
    cell.mcommname.text = [NSString stringWithFormat:@"来自%@",oneobj.mPlate.mName];
    cell.mcontent.text = oneobj.mContent;
    cell.mrebackbt.tag = indexPath.row;

    cell.mselref = @selector(cellrebackbt:);
    cell.mtagref = self;
    
    if( oneobj.mReplyContent.length && oneobj.mReplyPosts.mContent.length )
    {
        cell.mrefname.text = oneobj.mReplyContent;
        cell.mrefcontent.text = oneobj.mReplyPosts.mContent;
        cell.mrefconsth.constant = 1000000;
    }
    else
    {
        cell.mrefname.text = nil;
        cell.mrefcontent.text = nil;
        cell.mrefconsth.constant = 0;
    }
    
    cell.mlowicon.hidden = oneobj.mUser.mUserId != self.mtagPost.mUser.mUserId;
    cell.mlow.text = [NSString stringWithFormat:@"%d楼",oneobj.mFlood];
    cell.mtime.text = oneobj.mCreateTimeStr;
    return cell;
}

-(void)cellrebackbt:(UIButton*)sender
{
    SForumPosts* oneobj = self.tempArray[ sender.tag ];
    _rebacktag = oneobj;
    self.minputreback.placeholder = [NSString stringWithFormat:@"回复 %@:", oneobj.mUser.mUserName ];
    [self.minputreback becomeFirstResponder];
    
}

- (IBAction)rebackbtclicked:(id)sender {
    
    if( self.minputreback.text.length == 0 )
    {
        [SVProgressHUD showErrorWithStatus:@"请先输入回复内容"];
        return;
    }
    
    
    [SVProgressHUD showWithStatus:@"回复中..." maskType:SVProgressHUDMaskTypeClear];
    [_rebacktag rebackThis:self.minputreback.text block:^(SResBase *resb) {
        
        if( resb.msuccess )
        {
            [SVProgressHUD showSuccessWithStatus:resb.mmsg];
            [self.tableView headerBeginRefreshing];
            self.minputreback.text = nil;
            _rebacktag = self.mtagPost;
            self.minputreback.placeholder = @"回复精彩内容";
            
            [self.minputreback resignFirstResponder];
        }
        else
        {
            [SVProgressHUD showErrorWithStatus:resb.mmsg];
        }
        
    }];
    
}

- (IBAction)likeclicked:(id)sender {
    
    [SVProgressHUD showWithStatus:@"操作中..." maskType:SVProgressHUDMaskTypeClear];
    [self.mtagPost goodThis:^(SResBase *resb) {
       
        if( resb.msuccess )
        {
            [SVProgressHUD dismiss];
            [self updateMidInfo];
        }
        else
        {
            [SVProgressHUD showErrorWithStatus:resb.mmsg];
        }
    }];
    
}

- (IBAction)rebackclicked:(id)sender {
    
    _rebacktag = self.mtagPost;
    self.minputreback.placeholder = @"回复精彩内容";
    [self.minputreback becomeFirstResponder];
    
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

- (IBAction)callPhone:(id)sender { 
    
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",self.mtagPost.mAddress.mMobile];
    //            NSLog(@"str======%@",str);
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}
@end
