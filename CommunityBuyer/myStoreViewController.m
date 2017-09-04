//
//  myStoreViewController.m
//  CommunityBuyer
//
//  Created by 密码为空！ on 15/10/9.
//  Copyright © 2015年 zdq. All rights reserved.
//

#import "myStoreViewController.h"

#import "myStoreView.h"
#import "MJPhotoBrowser.h"
#import "MJPhoto.h"
#import "CTAssetsPickerController.h"
#import "RSKImageCropViewController.h"
#import "mCustomImage.h"
#import "RSKImageCropper.h"
#import "storeTypeViewController.h"

#import "MLKMenuPopover.h"
#import "DownSheet.h"
#import "WebVC.h"
#import "APIClient.h"
#import "ChoseAreaVC.h"
#import "searchInMap.h"
@interface myStoreViewController ()<CTAssetsPickerControllerDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,RSKImageCropViewControllerDelegate,RSKImageCropViewControllerDataSource,MLKMenuPopoverDelegate,DownSheetDelegate,UITextFieldDelegate>

@property(nonatomic,strong) MLKMenuPopover *menuPopover;
@property(nonatomic,strong) NSArray *menuItems;

@end

@implementation myStoreViewController
{
    myStoreView *mainView;
    
    myStoreView *bottomView;
    
    UIScrollView *mScrollerView;
    
    NSMutableArray *mAllImg;
    NSMutableArray *mLImg;
    
    
    UIImage *tempImage;
    UIImage *mLogImage;
    
    id     uploadzj;

    
    
    ///1是logo 2是营业执照
    int mType;

    ///商户类型
    int mStoreType;
    
    mCustomImage *mlicenceImg;
    
    NSMutableArray *mTTArr;
    NSMutableArray  *mIdArr;
    NSArray *MenuList;
    
    NSString *mCateID;
    
    int selectTag;
    
    SProvince* pp;
    SProvince* pc;
    SProvince* pa;
    
    SAddress*   _msubmit;
    
    NSString *_address;
    NSString *_maps;
    
    NSString    *_mMapPointStr;
    
    NSString *astring;
    
    

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

- (void)ServiceRangeClick:(UIButton *)sender{

    WebVC *web = [[WebVC alloc] init];
    web.mName = @"服务范围";
    
    
    NSString *ssss = @"";
    
    if( _mSeller.mMapPosStr.length )
    {
        ssss = [NSString stringWithFormat:@"&mapPos=%@&mapPoint=%@",_mSeller.mMapPosStr,_mSeller.mMapPointStr];
    
    }
    
    if (ssss.length == 0) {
        if ( _maps.length && _mMapPointStr.length ) {
            ssss = [NSString stringWithFormat:@"&mapPos=%@&mapPoint=%@",_maps,_mMapPointStr];
        }
    }
    
    NSString *string = [NSString stringWithFormat:@"seller.mappos?token=%@&userId=%d&%d%@",[GInfo shareClient].mGToken,[SUser currentUser].mUserId,(int)[[NSDate date] timeIntervalSince1970],ssss];
    
    NSString    *urlStr = [NSString stringWithFormat:@"%@",[APIClient APiWithUrl:string]];
    
    
    web.mUrl = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    web.itblock = ^(NSString* addr,NSString* maps,NSString  *mapPoint)
    {
        _address = addr;
        _maps = maps;
        _mMapPointStr = mapPoint;
        mainView.mServiceRange.text = @"修改服务范围";
        
    };
    
    [self pushViewController:web];
}

- (void)viewDidLoad {
    self.hiddenTabBar = YES;
    [super viewDidLoad];
    self.Title = self.mPageName = @"我要开店";
    self.hiddenlll = YES;
    self.navBar.rightBtn.hidden = YES;

    mScrollerView  = [UIScrollView new];
    mScrollerView.frame = CGRectMake(0, DEVICE_NavBar_Height, DEVICE_Width, DEVICE_Height);
    mScrollerView.backgroundColor = [UIColor colorWithRed:0.941 green:0.922 blue:0.918 alpha:1];
    [self.view addSubview:mScrollerView];
    
    mAllImg = NSMutableArray.new;
    mTTArr = NSMutableArray.new;
    mLImg = NSMutableArray.new;
    mIdArr = NSMutableArray.new;

    self.menuItems = [NSArray arrayWithObjects:@"商家加盟", @"个人加盟", nil];

    mStoreType = 2;
    
    [self initView];
    
    [self initData];

}
- (void)initView{
    mainView = [myStoreView shareView];
    mainView.frame = CGRectMake(0, 0, DEVICE_Width, 617);
    [mScrollerView addSubview:mainView];
    
    [mainView.mStoreTypeBtn addTarget:self action:@selector(StoreTypeAction:) forControlEvents:UIControlEventTouchUpInside];
    [mainView.mLogoBtn addTarget:self action:@selector(logoAction:) forControlEvents:UIControlEventTouchUpInside];
    [mainView.mSaleTypeBtn addTarget:self action:@selector(SaleTypeAction:) forControlEvents:UIControlEventTouchUpInside];
    [mainView.mLogoBtn addTarget:self action:@selector(logoAction:) forControlEvents:UIControlEventTouchUpInside];
    [mainView.mRangeBT addTarget:self action:@selector(ServiceRangeClick:) forControlEvents:UIControlEventTouchUpInside];
    [mainView.mAreaBT addTarget:self action:@selector(GoAreaClick:) forControlEvents:UIControlEventTouchUpInside];
    [mainView.mAddressDetailBT addTarget:self action:@selector(GoAddressClick:) forControlEvents:UIControlEventTouchUpInside];

    
    mainView.mPhoneNum.delegate = self;
    mainView.mIdCard.delegate = self;
    mainView.mPhoneNum.text = [SUser currentUser].mPhone;
    bottomView = [myStoreView shareBottomView];
    
    [mScrollerView addSubview:bottomView];
    

    [bottomView.mSubmitBtn addTarget:self action:@selector(submitAction:) forControlEvents:UIControlEventTouchUpInside];
    
    bottomView.mCardZ.userInteractionEnabled = YES;
    bottomView.mCardZ.tag = 11;
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(idcardAction:)];
    [bottomView.mCardZ addGestureRecognizer:tap2];
    
    bottomView.mCardB.userInteractionEnabled = YES;
    bottomView.mCardB.tag = 12;
    UITapGestureRecognizer *tap3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(idcardAction:)];
    [bottomView.mCardB addGestureRecognizer:tap3];
    
    
    bottomView.mZenJian.userInteractionEnabled = YES;
    bottomView.mZenJian.tag = 13;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(idcardAction:)];
    [bottomView.mZenJian addGestureRecognizer:tap];
    

        
    bottomView.frame = CGRectMake(0, mainView.frame.size.height+mainView.frame.origin.y, DEVICE_Width, 360+80);
    mScrollerView.contentSize = CGSizeMake(DEVICE_Width, mainView.frame.size.height+bottomView.frame.size.height+60);

    
    
    [self clickMenu];
}

- (void)initData{

    if (_mSeller) {
        _maps = _mSeller.mMapPosStr;
        if( _maps.length )
        {
            mainView.mServiceRange.text = @"修改服务范围";
        }
        else
            mainView.mServiceRange.text = @"未选择";
        
        mStoreType = _mSeller.mType;
        if (_mSeller.mType == 1) {
            [mainView.mStoreTypeBtn setTitle:@"个人加盟" forState:UIControlStateNormal];
            bottomView.mZenJianHeight.constant = 0;
            mainView.mNameText.text = @"真实姓名";
            mStoreType = 1;
        }else{
            [mainView.mStoreTypeBtn setTitle:@"商家加盟" forState:UIControlStateNormal];
            bottomView.mZenJianHeight.constant = 74;
            mainView.mNameText.text = @"店主/法人代表";
            mStoreType = 2;
        }
        
        if (mStoreType == 1) {
            bottomView.frame = CGRectMake(0, mainView.frame.size.height+mainView.frame.origin.y, DEVICE_Width, 360+80-74);
            mScrollerView.contentSize = CGSizeMake(DEVICE_Width, mainView.frame.size.height+bottomView.frame.size.height+60);
            
        }

        
        
        [mainView.mLogo sd_setImageWithURL:[NSURL URLWithString:_mSeller.mLogo] placeholderImage:[UIImage imageNamed:@"DefaultImg"]];
        
        mLogImage = (UIImage *)_mSeller.mLogo;
        
        mainView.mStoreName.text = _mSeller.mName;
        if (_mSeller.mCateIds) {
            
            if (_mSeller.mCateIds.count >0) {
                NSDictionary *dic = [_mSeller.mCateIds objectAtIndex:0];
                [mainView.mSaleTypeBtn setTitle:[dic objectForKey:@"name"] forState:UIControlStateNormal];
                
                
                mIdArr = [[NSMutableArray alloc] initWithObjects:[dic objectForKey:@"id"], nil];
            }
        }
       
//        mainView.mPhoneNum.text = _mSeller.mMobile;
        mainView.mAddress.text = _mSeller.mAddress;
        mainView.mIdCard.text = _mSeller.mIdcardSn;
        astring = _mSeller.mMapPointStr;
        
        mainView.mAddressDetail.text = _mSeller.mAddressDetail;
        mainView.mName.text = _mSeller.mContacts;
        mainView.mPhoneNum.text = _mSeller.mServiceTel;
        
        
        if(_mSeller.mProvince.mId == 0 && _mSeller.mCity.mId == 0 && _mSeller.mArea.mId == 0)
            mainView.mArea.text = @"未选择";
        else{
            
            pp = [[SProvince alloc] init];
            pp.mI = _mSeller.mProvince.mId;
            pp.mN = _mSeller.mProvince.mName;
            
            pc = [[SProvince alloc] init];
            pc.mI = _mSeller.mCity.mId;
            pc.mN = _mSeller.mCity.mName;
            
            pa = [[SProvince alloc] init];
            pa.mI = _mSeller.mArea.mId;
            pa.mN = _mSeller.mArea.mName;

            
            if (pa.mI !=0) {
                mainView.mArea.text = [NSString stringWithFormat:@"%@-%@-%@",pp.mN,pc.mN,pa.mN];
            }else{
                mainView.mArea.text = [NSString stringWithFormat:@"%@-%@",pp.mN,pc.mN];
            }
        }
        
        

        
        [bottomView.mCardZ sd_setImageWithURL:[NSURL URLWithString:_mSeller.mIdcardPositiveImg] placeholderImage:[UIImage imageNamed:@"card_1"]];
        
        if( _mSeller.mIdcardPositiveImg.length )
            [mAllImg addObject:_mSeller.mIdcardPositiveImg];
        else
            [mAllImg addObject:@""];
        
        [bottomView.mCardB sd_setImageWithURL:[NSURL URLWithString:_mSeller.mIdcardNegativeImg] placeholderImage:[UIImage imageNamed:@"card_2"]];
        
        if( _mSeller.mIdcardNegativeImg.length )
            [mAllImg addObject:_mSeller.mIdcardNegativeImg];
        else
            [mAllImg addObject:@""];
        
        
        [bottomView.mZenJian sd_setImageWithURL:[NSURL URLWithString:_mSeller.mCertificateImg] placeholderImage:[UIImage imageNamed:@"card_3"]];
        
        uploadzj = _mSeller.mCertificateImg;
        
        bottomView.mNote.text = _mSeller.mDetail;
    }
   
}

- (void)GoAreaClick:(UIButton *)sender{

    ChoseAreaVC *choseAreaVC = [[ChoseAreaVC alloc] initWithNibName:@"ChoseAreaVC" bundle:nil];
    choseAreaVC.pp = pp;
    choseAreaVC.cp = pc;
    choseAreaVC.ap = pa;
    
    choseAreaVC.itblock = ^(SProvince* p,SProvince* c,SProvince* a){
    
        pp = p;
        pc = c;
        pa = a;
        
        if (a.mI !=0) {
            mainView.mArea.text = [NSString stringWithFormat:@"%@-%@-%@",p.mN,c.mN,a.mN];
        }else{
            mainView.mArea.text = [NSString stringWithFormat:@"%@-%@",p.mN,c.mN];
        }
        
    };
    
    [self pushViewController:choseAreaVC];
    
}

- (void)GoAddressClick:(UIButton *)sender{

    searchInMap* vc = [[searchInMap alloc]init];
    
    vc.mNowAddr = _mSeller.mAddress;
    vc.mLat = _mSeller.mlat;
    vc.mLng = _mSeller.mlng;
    
    vc.itblock = ^(NSString* add,float lng,float lat){
        _msubmit = [[SAddress alloc] init];
        mainView.mAddress.text = add;
        _msubmit.mlat = lat;
        _msubmit.mlng = lng;
        
        astring = [NSString stringWithFormat:@"%.6f,%.6f",_msubmit.mlat,_msubmit.mlng];
    };
    [self pushViewController:vc];
}


- (void)idcardAction:(UIGestureRecognizer *)tap{

    mType = 2;
    selectTag = (int)tap.self.view.tag;
    
    UIActionSheet *ac = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从相册中选择", nil];
    ac.tag = selectTag;
    [ac showInView:[self.view window]];
    
//    CTAssetsPickerController *picker = [[CTAssetsPickerController alloc] init];
//    picker.maximumNumberOfSelection = 1;
//    picker.assetsFilter = [ALAssetsFilter allPhotos];
//    picker.delegate = self;
//    
//    [self presentViewController:picker animated:YES completion:NULL];
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark----商户类型
- (void)StoreTypeAction:(UIButton *)sender{

    
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:@"请选择商户类型"
                                  delegate:self
                                  cancelButtonTitle:@"取消"
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:@"商家加盟", @"个人加盟",nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    actionSheet.tag = 1;
    [actionSheet showInView:self.view];

}


-(void)clickMenu{
    DownSheetModel *Model_1 = [[DownSheetModel alloc]init];
    Model_1.title = @"商家加盟";
    DownSheetModel *Model_2 = [[DownSheetModel alloc]init];
    
    Model_2.title = @"个人加盟";
    
    MenuList = [[NSArray alloc]init];
    MenuList = @[Model_1,Model_2];
}
-(void)didSelectIndex:(NSInteger)index{
    
    NSArray *arr = @[@"商家加盟",@"个人加盟"];
    [mainView.mStoreTypeBtn setTitle:arr[index] forState:0];

}
#pragma mark -
#pragma mark MLKMenuPopoverDelegate

- (void)menuPopover:(MLKMenuPopover *)menuPopover didSelectMenuItemAtIndex:(NSInteger)selectedIndex
{
    [self.menuPopover dismissMenuPopover];
    
    [mainView.mStoreTypeBtn setTitle:[self.menuItems objectAtIndex:selectedIndex ] forState:0];

}
#pragma mark----店铺logo
- (void)logoAction:(UIButton *)sender{
    mType = 1;
    UIActionSheet *ac = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从相册中选择", nil];
    ac.tag = 1001;
    [ac showInView:[self.view window]];
}

#pragma mark----经营类型
- (void)SaleTypeAction:(UIButton *)sender{
    
    mCateID = nil;
    [mTTArr removeAllObjects];
    
    UIStoryboard *storyboard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    storeTypeViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"sss"];
    viewController.itblock = ^(NSArray *arr){

        if (arr.count == 0) {
            [mainView.mSaleTypeBtn setTitle:@"未选择" forState:0];

        }else{
            
            [mIdArr removeAllObjects];
            for (NSDictionary *dic in arr) {
                [mTTArr addObject:[dic objectForKey:@"name"]];
                [mIdArr addObject:[dic objectForKey:@"id"]];
            }
            
            MLLog(@"%@",mTTArr);
            

            NSString *string = @"";
            for (int i = 0;i<mTTArr.count;i++) {
                
                NSString *s = [mTTArr objectAtIndex:i];
                
                string = [string stringByAppendingString:s];
                
                if (i!=mTTArr.count-1) {
                    string = [string stringByAppendingString:@","];
                }
            }
            
            [mainView.mSaleTypeBtn setTitle:string forState:0];
        }
    };
    [self.navigationController pushViewController:viewController animated:YES];

}




#pragma mark----提交按钮
- (void)submitAction:(UIButton *)sender{
    MLLog(@"ids:---------%@",mIdArr);

    for (id one in mAllImg ) {
        if( [one isKindOfClass:[NSString class]] )
        {
            NSString* sss = one;
            if( sss.length == 0 )
            {
                [SVProgressHUD showErrorWithStatus:@"身份证必须上传正反面2张！"];
                return;
            }
        }
    }
    
    
    if (mStoreType == 0) {
        [SVProgressHUD showErrorWithStatus:@"请选择商户类型"];
        return;
    }
    if (mLogImage == nil && _mSeller.mLogo.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请选择店铺logo"];
        return;

    }
    if (mainView.mStoreName.text == nil || [mainView.mStoreName.text isEqualToString:@""]) {
        [SVProgressHUD showErrorWithStatus:@"店铺名称不能为空"];
        [mainView.mStoreName becomeFirstResponder];
        return;
    }
    if (mIdArr.count == 0) {
        [SVProgressHUD showErrorWithStatus:@"经营类型不能为空"];
        return;
    }
    if (mainView.mAddress.text == nil || [mainView.mAddress.text isEqualToString:@""]) {
        [SVProgressHUD showErrorWithStatus:@"店铺地址不能为空"];
        [mainView.mAddress becomeFirstResponder];
        return;
    }
    if (mainView.mPhoneNum.text == nil || [mainView.mPhoneNum.text isEqualToString:@""]) {
        [SVProgressHUD showErrorWithStatus:@"服务电话不能为空"];
        [mainView.mPhoneNum becomeFirstResponder];
        return;
    }
    
    if (mainView.mName.text.length  == 0) {
        
        if(mStoreType == 1){
            [SVProgressHUD showErrorWithStatus:@"请输入真实姓名"];
        }else{
            [SVProgressHUD showErrorWithStatus:@"请输入店主/法人代码"];
        }
        
        [mainView.mName becomeFirstResponder];
    }

    if (mainView.mIdCard.text == nil || [mainView.mIdCard.text isEqualToString:@""]) {
        [SVProgressHUD showErrorWithStatus:@"身份证不能为空"];
        [mainView.mIdCard becomeFirstResponder];
        return;
    }
//    if ([Util checkSFZ:mainView.mIdCard.text]==NO) {
//        [SVProgressHUD showErrorWithStatus:@"身份证不正确"];
//        [mainView.mIdCard becomeFirstResponder];
//        return;
//    }
    if (bottomView.mNote.text == nil || [bottomView.mNote.text isEqualToString:@""]) {
        [SVProgressHUD showErrorWithStatus:@"店铺介绍不能为空"];
        [bottomView.mNote becomeFirstResponder];
        return;
    }
    if (bottomView.mNote.text.length>200) {
        [SVProgressHUD showErrorWithStatus:@"店铺介绍不能超过200字！"];
        [bottomView.mNote becomeFirstResponder];
        return;
    }
    
    if (mainView.mAddress.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请选择店铺地址"];
        
        return;
    }
    
    if (mainView.mAddressDetail.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请填写详细地址"];
        [mainView.mAddressDetail becomeFirstResponder];
        
        return;
    }
    
    if (mStoreType == 2) {
        
        if(  [uploadzj isKindOfClass:[NSString class]] && ((NSString*)uploadzj).length == 0 )
        {
            [SVProgressHUD showErrorWithStatus:@"请选择证件"];
            return;
        }
    }
    
    NSString *tempString = [NSString stringWithFormat:@"%d",[mIdArr.firstObject intValue]];
    

    MLLog(@"%@",tempString);
    
    
    [SVProgressHUD showWithStatus:@"正在提交..." maskType:SVProgressHUDMaskTypeClear];

    [[SUser currentUser] willCreateStore:mStoreType andLogo:mLogImage andStoreName:mainView.mStoreName.text andCateId:tempString andAddress:mainView.mAddress.text adressDetail:mainView.mAddressDetail.text proviceId:pp.mI cityId:pc.mI areaId:pa.mI mapPosStr:_maps mapPointStr:astring andMbile:mainView.mPhoneNum.text andName:mainView.mName.text andIdCard:mainView.mIdCard.text andIdCardImg:mAllImg[0] andIdCardImg2:mAllImg[1] andLicenceImg:uploadzj andIntroduction:bottomView.mNote.text block:^(SResBase *resb) {
        if (resb.msuccess) {
            [SVProgressHUD showSuccessWithStatus:resb.mmsg];
            sleep(3);
            
            [self popViewController];
        }else{
            [SVProgressHUD showErrorWithStatus:resb.mmsg];

        }
    }];
}


#pragma mark----delegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{

    if (actionSheet.tag == 1) {
        if (buttonIndex == 0) {
            MLLog(@"商家加盟");
            [mainView.mStoreTypeBtn setTitle:@"商家加盟" forState:0];
            mStoreType = 2;
            bottomView.mZenJianHeight.constant = 74;
            bottomView.frame = CGRectMake(0, mainView.frame.size.height+mainView.frame.origin.y, DEVICE_Width, 360+80);
            mScrollerView.contentSize = CGSizeMake(DEVICE_Width, mainView.frame.size.height+bottomView.frame.size.height+60);
            mainView.mNameText.text = @"店主/法人代表";
          
        }else if (buttonIndex == 1) {
            MLLog(@"个人加盟");
            [mainView.mStoreTypeBtn setTitle:@"个人加盟" forState:0];
            mStoreType = 1;
            bottomView.mZenJianHeight.constant = 0;
            bottomView.frame = CGRectMake(0, mainView.frame.size.height+mainView.frame.origin.y, DEVICE_Width, 360+80-74);
            mScrollerView.contentSize = CGSizeMake(DEVICE_Width, mainView.frame.size.height+bottomView.frame.size.height+60);
            mainView.mNameText.text = @"真实姓名";
        }else if(buttonIndex == 2) {
            MLLog(@"取消");
            
        }
    }else
        if ( buttonIndex != 2 ) {
            
            [self startImagePickerVCwithButtonIndex:buttonIndex];
        }
    
}
- (void)startImagePickerVCwithButtonIndex:(NSInteger )buttonIndex
{
    int type;
    
    
    if (buttonIndex == 0) {
        type = UIImagePickerControllerSourceTypeCamera;
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.sourceType = type;
        imagePicker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        imagePicker.allowsEditing =NO;
        
        [self presentViewController:imagePicker animated:YES completion:^{
            
        }];
        
    }
    else if(buttonIndex == 1){
        type = UIImagePickerControllerSourceTypePhotoLibrary;
        
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.sourceType = type;
        imagePicker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        imagePicker.allowsEditing = NO;
        [self presentViewController:imagePicker animated:YES completion:NULL];
        
        
    }
    
    
    
}
- (void)imagePickerController:(UIImagePickerController *)imagePickerController didFinishPickingMediaWithInfo:(id)info
{
    
    UIImage* tempimage1 = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    [self gotCropIt:tempimage1];
    
    [imagePickerController dismissViewControllerAnimated:YES completion:^() {
        
    }];
    
}
-(void)gotCropIt:(UIImage*)photo
{
    RSKImageCropViewController *imageCropVC = nil;
    
    if (mType == 1) {
        imageCropVC = [[RSKImageCropViewController alloc] initWithImage:photo cropMode:RSKImageCropModeCircle];
    }else{
        imageCropVC = [[RSKImageCropViewController alloc] initWithImage:photo cropMode:RSKImageCropModeCustom];
    }
    
    imageCropVC.dataSource = self;
    imageCropVC.delegate = self;
    [self.navigationController pushViewController:imageCropVC animated:YES];
    
}
- (void)imageCropViewControllerDidCancelCrop:(RSKImageCropViewController *)controller
{
    
    [controller.navigationController popViewControllerAnimated:YES];
}

- (CGRect)imageCropViewControllerCustomMaskRect:(RSKImageCropViewController *)controller
{
    
    if (mType == 1) {
        return   CGRectMake(self.view.center.x-mainView.mLogo.frame.size.width/2, self.view.center.y-mainView.mLogo.frame.size.height/2, mainView.mLogo.frame.size.width, mainView.mLogo.frame.size.height);

    }else{
        
        return   CGRectMake(0, DEVICE_Height /2  - (DEVICE_Width/4*3)/2 , DEVICE_Width, DEVICE_Width/4*3);
    }
    
}
- (UIBezierPath *)imageCropViewControllerCustomMaskPath:(RSKImageCropViewController *)controller
{
    if (mType == 1) {
         return [UIBezierPath bezierPathWithRect:CGRectMake(self.view.center.x-mainView.mLogo.frame.size.width/2, self.view.center.y-mainView.mLogo.frame.size.height/2, mainView.mLogo.frame.size.width, mainView.mLogo.frame.size.height)];
    }else{
         return  [UIBezierPath bezierPathWithRect:[self imageCropViewControllerCustomMaskRect:controller]];
        
    }
   
    
}
- (void)imageCropViewController:(RSKImageCropViewController *)controller didCropImage:(UIImage *)croppedImage
{
    [mLImg removeAllObjects];
    [controller.navigationController popViewControllerAnimated:YES];
    
    tempImage = croppedImage;//[Util scaleImg:croppedImage maxsize:140];
    
    if (mType == 1) {
        mainView.mLogo.image = tempImage;
        mLogImage = tempImage;
    }
    else{
        
        if (selectTag == 11) {
            bottomView.mCardZ.image = tempImage;
            [mAllImg replaceObjectAtIndex:0 withObject:bottomView.mCardZ.image];
        }else if (selectTag == 12){
            
            bottomView.mCardB.image = tempImage;
            [mAllImg replaceObjectAtIndex:1 withObject:bottomView.mCardB.image];
            
        }else{
            
            bottomView.mZenJian.image =  tempImage;
            
            uploadzj = bottomView.mZenJian.image;
            
            mLImg = [[NSMutableArray alloc] initWithObjects:tempImage,nil];
        }
        
    }
    
}

///限制电话号码输入长度
#define TEXT_MAXLENGTH 11
///限制密码输入长度
#define PASS_LENGHT 20
#define CODE_LENGHT 18

#pragma mark **----键盘代理方法
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *new = [textField.text stringByReplacingCharactersInRange:range withString:string];
    NSInteger res;
    if (textField.tag==11) {
        res= TEXT_MAXLENGTH-[new length];
        
    }
    if (textField.tag==20) {
        res= PASS_LENGHT-[new length];
        
        
    }else
    {
        res= CODE_LENGHT-[new length];
        
    }
    if(res >= 0){
        return YES;
    }
    else{
        NSRange rg = {0,[string length]+res};
        if (rg.length>0) {
            NSString *s = [string substringWithRange:rg];
            [textField setText:[textField.text stringByReplacingCharactersInRange:range withString:s]];
        }
        return NO;
    }
    
}

@end
