//
//  CmmVC.m
//  CommunityBuyer
//
//  Created by zzl on 15/10/10.
//  Copyright © 2015年 zdq. All rights reserved.
//

#import "CmmVC.h"
#import "dateModel.h"
#import "myImageView.h"
#import "CTAssetsPickerController.h"
#import "IQTextView.h"
#import "OrderDetailVC.h"

@interface CmmVC ()<UIActionSheetDelegate,UINavigationControllerDelegate,CTAssetsPickerControllerDelegate>

@end

@implementation CmmVC
{
    int                 _score;
    NSMutableArray*     _allselectimgs;
    int                _bchecked;
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
    // Do any additional setup after loading the view from its nib
    self.mPageName = self.Title = @"评价";
    
    _score = 3;
    _bchecked = 0;
    _allselectimgs = NSMutableArray.new;
    _mtext.placeholder = @"您的意见很重要!来点评一下吧...";
    [_mtext setHolderToTop];
    
    [self updatePage];
    
}
-(void)updatePage
{
    //上面部分
    self.morderNum.text = _mtagOrder.mSn;
    int allcount = 0;
    NSMutableArray* allgoodsimgs = NSMutableArray.new;
    if( _mtagOrder.mGoodsImages == nil )
    {
        for( SCarSeller* one in _mtagOrder.mCartSellers )
        {
            if( one.mGoodsImages )
                [allgoodsimgs addObject: one.mGoodsImages];
            allcount += one.mNum;
        }
    }
    else
    {
        [allgoodsimgs addObjectsFromArray: _mtagOrder.mGoodsImages];
        allcount = _mtagOrder.mCount;
    }
    
    for (int j = 0  ; j < 4; j++) {
        UIImageView* one = (UIImageView*)[_mtopwarp viewWithTag: 10+j];
        if(  j < allgoodsimgs.count )
        {
            [one sd_setImageWithURL:[NSURL URLWithString:allgoodsimgs[j]] placeholderImage:[UIImage imageNamed:@"DefaultImg"]];
            one.hidden = NO;
        }
        else break;
    }
    
    NSString* strv = [NSString stringWithFormat:@"共%u件",allcount];
    
    NSMutableAttributedString* str = [[NSMutableAttributedString alloc] initWithString:strv];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(1,strv.length - 2 )];
    self.malltext.attributedText = str;
    
    //中间部分的
    [self updateScore];

    
    //下面部分的图片选择
    [self updateSelectImages];
    
    
    [self updateCheck];
}

-(void)updateCheck
{
    _mcheck.image = _bchecked != 0? [UIImage imageNamed:@"checkgou"] : [UIImage imageNamed:@"checknogou"];
}

-(void)updateSelectImages
{
    for( int j = 0 ;j < 8 ; j ++ )
    {
        myImageView* one = (myImageView*)[_mimagewarp viewWithTag:j + 30 ];
        one.mtag = self;
        one.msel = @selector(selectImageClicked:);
        if( j < _allselectimgs.count )
        {
            one.image = _allselectimgs[j];
            one.hidden = NO;
            one.msameicon.hidden = NO;
        }
        else if( j == _allselectimgs.count )
        {
            one.image = [UIImage imageNamed:@"addcmmimage"];
            one.hidden = NO;
            one.msameicon.hidden = YES;
        }
        else
        {
            one.hidden = YES;
        }
    }
    
    CGFloat h = 0;
    if( _allselectimgs.count < 4 )
        h = 89;
    else
        h = 167;
    
    CGRect f = _mimagewarp.frame;
    f.size.height = h;
    _mimagewarp.frame = f;
    
    [Util relPosUI:_mimagewarp dif:0 tag:_mcheckwarp tagatdic:E_dic_b];
    [Util relPosUI:_mcheckwarp dif:13 tag:_msubmit tagatdic:E_dic_b];
    
    CGSize ss = _mscrollwarp.contentSize;
    ss.height = _msubmit.frame.origin.y + _msubmit.frame.size.height;
    _mscrollwarp.contentSize = ss;
    
}

-(void)selectImageClicked:(NSDictionary*)itid
{
    
    int i = [[itid objectForKey:@"id"] intValue] - 30;
    BOOL bdel = [[itid objectForKey:@"bdel"] boolValue];
    if( bdel )
    {//删除
        [_allselectimgs removeObjectAtIndex:i];
        [self  updateSelectImages];
    }
    else if( i == _allselectimgs.count )
    {//添加
        
        CTAssetsPickerController *picker = [[CTAssetsPickerController alloc] init];
        picker.maximumNumberOfSelection = 8 - _allselectimgs.count;
        picker.assetsFilter = [ALAssetsFilter allPhotos];
        picker.delegate = self;
        [self presentViewController:picker animated:YES completion:NULL];
        
    }
    else
    {
        
    }
}

-(void)updateScore
{
    for ( int j = 0 ; j < 5; j++) {
        UIButton* one = (UIButton*)[_mscorewarp viewWithTag:j+20];
        if( j < _score )
            [one setImage:[UIImage imageNamed:@"satrtcmm"] forState:UIControlStateNormal];
        else
            [one setImage:[UIImage imageNamed:@"starcmmno"] forState:UIControlStateNormal];
    }
}



- (IBAction)scorebt:(UIButton*)sender {
    
    _score = (int)sender.tag - 20 + 1;
    [self updateScore];
    
}

- (IBAction)submit:(id)sender {
    
    
    
    if( _mtext.text.length == 0 )
    {
        [SVProgressHUD showErrorWithStatus:@"请先输入评价内容"];
        return;
    }
    [SVProgressHUD showWithStatus:@"操作中..." maskType:SVProgressHUDMaskTypeClear];
    [_mtagOrder cmmThis:_mtext.text star:_score imgs:_allselectimgs bno:_bchecked block:^(SResBase *resb) {
        if( resb.msuccess ){
            [SVProgressHUD showSuccessWithStatus:resb.mmsg];
            
            OrderDetailVC* vcc = [OrderDetailVC whichVC:_mtagOrder];
            vcc.mTagOrder = _mtagOrder;
            NSMutableArray* vcs = [[NSMutableArray alloc]initWithArray:self.navigationController.viewControllers];
            [vcs removeLastObject];
            [vcs removeLastObject];
            [vcs addObject:vcc];
            [self.navigationController pushViewController:vcc   animated:YES];
        }
        else
            [SVProgressHUD showErrorWithStatus:resb.mmsg];
    }];
}
- (IBAction)checkbt:(id)sender {
    
    _bchecked = !_bchecked;
    [self updateCheck];
    
}



//相册选择的
- (void)assetsPickerController:(CTAssetsPickerController *)picker didFinishPickingAssets:(NSArray *)assets
{
    for (  ALAsset * one in assets  )
    {
        [_allselectimgs addObject:[UIImage imageWithCGImage: [[one defaultRepresentation] fullScreenImage] ]];
    }
    
    [self updateSelectImages];
}

//通过相册拍照的
-(void)assetsPickerControllerDidCamera:(CTAssetsPickerController *)picker imgage:(UIImage*)image
{
    if (_allselectimgs.count < 8 && image) {
        [_allselectimgs addObject:image];
        [self updateSelectImages];
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
