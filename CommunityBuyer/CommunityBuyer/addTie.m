//
//  addTie.m
//  CommunityBuyer
//
//  Created by zzl on 15/12/31.
//  Copyright © 2015年 zdq. All rights reserved.
//

#import "addTie.h"
#import "IQKeyboardManager.h"
#import "IQTextView.h"
#import "ZWSideBtImg.h"
#import "CTAssetsPickerController.h"
#import "AddressVC.h"
@interface addTie ()<ZWSideBtImgDelegate,UIActionSheetDelegate,CTAssetsPickerControllerDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIAlertViewDelegate>

@end

@implementation addTie
{
    NSMutableArray* _allselectimgs;
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
    // Do any additional setup after loading the view from its nib.
    self.Title = self.mPageName = self.mtagPost == nil ? @"发帖" : @"编辑帖子";
    self.rightBtnTitle = self.mtagPost == nil ? @"发布":@"保存";
    
    self.mcontent.placeholder = @"请填写内容";
    [self.mcontent setHolderToTop];
    
    _allselectimgs = NSMutableArray.new;
    
    if( self.mtagPost == nil )
        self.mtagPost = SForumPosts.new;
    else
    {//如果本来就有,那么需要把之前的图片转移过来
        if( self.mtagPost.mImagesArr.count )
            [_allselectimgs addObjectsFromArray: self.mtagPost.mImagesArr];
    }
    //如果没有主题,就弄一个,,
    if( self.mtagPost.mPlate == nil )
        self.mtagPost.mPlate = self.mtagPlate;
    
    [self updatePage];
    
}
-(void)rightBtnTouched:(id)sender
{
    //提交保存
    if( self.mtitl.text.length == 0 )
    {
        [SVProgressHUD showErrorWithStatus:@"请先输入标题"];
        return;
    }
    if( self.mcontent.text.length == 0 )
    {
        [SVProgressHUD showErrorWithStatus:@"请先输入内容"];
        return;
    }
    if( self.mtitl.text.length > 50 )
    {
        [SVProgressHUD showErrorWithStatus:@"标题不得超过50个字"];
        return;
    }
    if( self.mcontent.text.length > 30000 )
    {
        [SVProgressHUD showErrorWithStatus:@"帖子内容不得超过30000个字"];
        return;
    }
    
    self.mtagPost.mTitle = self.mtitl.text;
    self.mtagPost.mContent = self.mcontent.text;
    
    
    [SVProgressHUD showWithStatus:@"操作中..." maskType:SVProgressHUDMaskTypeClear];
    [self.mtagPost submitPost:^(SResBase *resb) {
       
        if( resb.msuccess )
        {
            [SVProgressHUD dismiss];
            UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"成功提示" message:resb.mmsg delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
        else
        {
            [SVProgressHUD showErrorWithStatus:resb.mmsg];
        }
    }];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self leftBtnTouched:nil];
}

-(void)updatePage
{
    
    self.msendto.text = self.mtagPost.mPlate.mName;
    self.mtitl.text = self.mtagPost.mTitle;
    self.mcontent.text = self.mtagPost.mContent;
    
    [self updateImgPart];
    
    [self updateBottomAddress];
    
    
}
-(void)updateImgPart
{
    
    BOOL bshowddd = NO;
    
    for ( int j = 0 ; j < 4 ; j ++) {
        ZWSideBtImg* one = [self.mimagewapre viewWithTag:j+1];
        one.mdelegate = self;
        if( j < self.mtagPost.mImagesArr.count )
        {
            NSString* oneobj = self.mtagPost.mImagesArr[j];
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
-(void)updateBottomAddress
{
    if( self.mtagPost.mAddress  )
    {
        self.mname.text = self.mtagPost.mAddress.mName;
        self.maddr.text = self.mtagPost.mAddress.mAddress;
        self.mtel.text = self.mtagPost.mAddress.mMobile;
        
        self.mwaperhi.constant = 135;
        
        self.maddedwaper.hidden = NO;
    }
    else
    {
        self.mwaperhi.constant = 85;
        self.maddedwaper.hidden = YES;
    }
}
-(void)btclicked:(UIButton*)bt imagetag:(ZWSideBtImg*)imagetag
{
    [_allselectimgs removeObjectAtIndex: imagetag.tag-1];
    
    self.mtagPost.mImagesArr = _allselectimgs;
    
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
    
    self.mtagPost.mImagesArr = _allselectimgs;
    [self updateImgPart];
    
}


//相册选择的
- (void)assetsPickerController:(CTAssetsPickerController *)picker didFinishPickingAssets:(NSArray *)assets
{
    for (  ALAsset * one in assets  )
    {
        [_allselectimgs addObject:[UIImage imageWithCGImage: [[one defaultRepresentation] fullScreenImage] ]];
    }
    self.mtagPost.mImagesArr = _allselectimgs;

    [self updateImgPart];
}

//通过相册拍照的
-(void)assetsPickerControllerDidCamera:(CTAssetsPickerController *)picker imgage:(UIImage*)image
{
    if (_allselectimgs.count < 4 && image) {
        [_allselectimgs addObject:image];
        
        self.mtagPost.mImagesArr = _allselectimgs;
        [self updateImgPart];
    }
}

- (IBAction)addclicked:(id)sender {
    
    UIStoryboard *storyboard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    AddressVC *viewController = [storyboard instantiateViewControllerWithIdentifier:@"AddressVC"];
    viewController.mShowlocself = NO;
    viewController.itblock = ^(SAddress* retobj){
        
        if( retobj )
        {
            self.mtagPost.mAddress = retobj;
            [self updateBottomAddress];
        }
        
    };
    [self pushViewController:viewController];
}

- (IBAction)delclicked:(id)sender {
    
    self.mtagPost.mAddress = nil;
    [self updateBottomAddress];

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
