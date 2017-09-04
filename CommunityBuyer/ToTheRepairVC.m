//
//  ToTheRepairVC.m
//  CommunityBuyer
//
//  Created by zy _cheng_mac on 16/1/21.
//  Copyright © 2016年 zdq. All rights reserved.
//

#import "ToTheRepairVC.h"
#import "ClassChooseCell.h"
#import "IQTextView.h"
#import "ZWSideBtImg.h"
#import "CTAssetsPickerController.h"
@interface ToTheRepairVC ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate,CTAssetsPickerControllerDelegate,ZWSideBtImgDelegate,UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate>{
    
    NSArray *classArray;
    UIView *_bgview;
    SRepairType* _selectttype;
    NSMutableArray* _allselectimgs;
}

@end

@implementation ToTheRepairVC

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
    self.mPageName = @"故障报修";
    self.Title = self.mPageName;
    _isShow=NO;
    //类型数组
    _allselectimgs  = NSMutableArray.new;
    
    self.mIntro.placeholder = @"请输入故障描述";
    [self.mIntro setHolderToTop];
    [self updateImgPart];

    [SVProgressHUD showWithStatus:@"加载中..." maskType:SVProgressHUDMaskTypeClear];
    [SRepairType getRepairTypes:^(SResBase *resb, NSArray *all) {
        
        if( resb.msuccess && all.count > 0 )
        {
            [SVProgressHUD dismiss];
            classArray = all;
            _selectttype = all[0];
            [_mFacilities setTitle:_selectttype.mName forState:UIControlStateNormal];
            [self updatePage];
        }
        else
        {
            [SVProgressHUD showErrorWithStatus:resb.mmsg];
            [self performSelector:@selector(leftBtnTouched:) withObject:nil afterDelay:0.85f];
        }
        
    }];
    
}

-(void)updatePage
{
    
    [self initbackview];
    self.mName.text = self.mtagDistrict.mName;
    
    [self updateImgPart];
    
}

//初始化选择类型view以及黑色透明背景
- (void)initbackview{
    
    _mClassTable = [[UITableView alloc] initWithFrame:CGRectMake(0, DEVICE_Height, DEVICE_Width, classArray.count*60) style:UITableViewStylePlain];
    
    _mClassTable.delegate=self;
    _mClassTable.dataSource=self;
    
    
    UINib *nib=[UINib nibWithNibName:@"ClassChooseCell" bundle:nil];
    [_mClassTable registerNib:nib forCellReuseIdentifier:@"cell"];
    
    [self.view addSubview:_mClassTable];

    
//    _bgview = [[UIView alloc] initWithFrame:CGRectMake(0, DEVICE_NavBar_Height, DEVICE_Width, DEVICE_Height)];
    _bgview = [[UIView alloc] initWithFrame:CGRectMake(0, 188, DEVICE_Width, DEVICE_Height)];
    _bgview.backgroundColor = [UIColor blackColor];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenTable)];
    _bgview.userInteractionEnabled = YES;
    [_bgview addGestureRecognizer:tap];
    
    _bgview.alpha = 0.5;
    
}

-(void)btclicked:(UIButton*)bt imagetag:(ZWSideBtImg*)imagetag
{
    [_allselectimgs removeObjectAtIndex: imagetag.tag-1];
    
    [self updateImgPart];
}

-(void)imgclicked:(ZWSideBtImg*)imagetag
{
    UIActionSheet* vc = [[UIActionSheet alloc] initWithTitle:@"选择图片" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"拍照" otherButtonTitles:@"相册", nil];
    vc.tag=  imagetag.tag;
    [vc showInView:self.view];
    
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ( buttonIndex == 1 ) {
        //相册
        
        CTAssetsPickerController *picker = [[CTAssetsPickerController alloc] init];
        picker.maximumNumberOfSelection = 4 - _allselectimgs.count;
        picker.assetsFilter = [ALAssetsFilter allPhotos];
        picker.delegate = self;
        [self presentViewController:picker animated:YES completion:NULL];
        
    }
    else if( buttonIndex == 0)
    {//拍照
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePicker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        imagePicker.allowsEditing =NO;
        
        [self presentViewController:imagePicker animated:YES completion:NULL];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    UIImage* tempimage1 = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    [_allselectimgs addObject: tempimage1];
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
    [self updateImgPart];
    
}


//相册选择的
- (void)assetsPickerController:(CTAssetsPickerController *)picker didFinishPickingAssets:(NSArray *)assets
{
    for (  ALAsset * one in assets  )
    {
        [_allselectimgs addObject:[UIImage imageWithCGImage: [[one defaultRepresentation] fullScreenImage] ]];
    }
    
    [self updateImgPart];
}

//通过相册拍照的
-(void)assetsPickerControllerDidCamera:(CTAssetsPickerController *)picker imgage:(UIImage*)image
{
    if (_allselectimgs.count < 4 && image) {
        [_allselectimgs addObject:image];
        
        [self updateImgPart];
    }
}

-(void)updateImgPart
{
    BOOL bshowddd = NO;
    
    for ( int j = 0 ; j < 4 ; j ++) {
        ZWSideBtImg* one = [self.mimgwaper viewWithTag:j+1];
        one.mdelegate = self;
        if( j < _allselectimgs.count )
        {
            NSString* oneobj = _allselectimgs[j];
            one.mbShowBt = YES;
            if( [oneobj isKindOfClass: [NSString class]] )
            {
                [one sd_setImageWithURL:[NSURL URLWithString:oneobj] placeholderImage:[UIImage imageNamed:@"DefaultImg"]];
            }
            else if( [oneobj isKindOfClass:[UIImage class]] )
            {
                one.image = (UIImage*)oneobj;
            }
            one.hidden = NO;
        }
        else
        {
            if( !bshowddd )
            {
                bshowddd = YES;
                one.image = [UIImage imageNamed:@"bg_addimg"];
                one.hidden = NO;
                one.mbShowBt = NO;
            }else
                one.hidden = YES;
        }
    }
}

//提交
- (IBAction)submitRepair:(id)sender {
    
    if( self.mIntro.text.length ==0  )
    {
        [SVProgressHUD showErrorWithStatus:@"请先输入故障描述"];
        return;
    }
    
    SRepair* submitobj = SRepair.new;
    submitobj.mContent = self.mIntro.text;
    submitobj.mDistrictId = self.mtagDistrict.mId;
    submitobj.mImages = _allselectimgs;
    submitobj.mTypeid = _selectttype.mId;
    
    [SVProgressHUD showWithStatus:@"操作中..." maskType:SVProgressHUDMaskTypeClear];
    [submitobj submitRepair:^(SResBase *resb) {
        
        if( resb.msuccess )
        {
            [SVProgressHUD showSuccessWithStatus:resb.mmsg];
            [self performSelector:@selector(leftBtnTouched:) withObject:nil afterDelay:0.85f];
        }
        else
        {
            [SVProgressHUD showErrorWithStatus:resb.mmsg];
        }
        
    }];
    
    
}
//显示故障类型
- (IBAction)chooseFacilities:(id)sender {
    
    if(_isShow){
        [self hiddenTable];
        
    }else{
        [self showTable];
            }
    
}
//显示选择类型table
- (void)showTable{
    
    [self.view addSubview:_bgview];
    [self.view bringSubviewToFront:_mClassTable];
    _isShow=YES;
    _mClassTable.frame=CGRectMake(0, 188, DEVICE_Width, classArray.count*60);


}
//隐藏选择类型table
- (void)hiddenTable{
    [_bgview removeFromSuperview];
    _isShow=NO;
    _mClassTable.frame=CGRectMake(0, DEVICE_Height, DEVICE_Width, classArray.count*60);

    
}

#pragma UItabledelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    

    SRepairType* oneobj = classArray[ indexPath.row];
    
    ClassChooseCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    cell.mText.text= oneobj.mName;

    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return classArray.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   
    SRepairType* oneobj = classArray[ indexPath.row];
    _selectttype = oneobj;
    [_mFacilities setTitle:oneobj.mName forState:UIControlStateNormal];
    [self hiddenTable];
    
}
@end
