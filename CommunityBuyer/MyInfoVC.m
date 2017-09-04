//
//  MyInfoVC.m
//  XiCheBuyer
//
//  Created by 周大钦 on 15/6/25.
//  Copyright (c) 2015年 zdq. All rights reserved.
//

#import "MyInfoVC.h"
#import "RSKImageCropper.h"
#import "IQKeyboardManager.h"
#import "UpdateNameVC.h"
#import "UpdatePwdVC.h"
#import "UpdatePhoneVC.h"

@interface MyInfoVC ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,RSKImageCropViewControllerDelegate,RSKImageCropViewControllerDataSource>{

    UIImage *tempImage;
}

@end

@implementation MyInfoVC


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[IQKeyboardManager sharedManager] setEnable:YES];
    [[IQKeyboardManager sharedManager]setEnableAutoToolbar:YES];
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    
    if ([SUser isNeedLogin]) {
        [self gotoLoginVC];
        return;
    }
    
    [self loadData];
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
    // Do any additional setup after loading the view.
    
    self.mPageName = @"我的账号";
    self.Title = self.mPageName;

    
}

- (void)loadData{

    if(tempImage)
    {
        self.myphotoIV.image = tempImage;
    }else{
        
        [self.myphotoIV sd_setImageWithURL:[NSURL URLWithString:[SUser currentUser].mHeadImgURL] placeholderImage:[UIImage imageNamed:@"defultHead"]];
    }
    
    self.nameTF.text = [SUser currentUser].mUserName;
    self.mPhone.text = [SUser currentUser].mPhone;
    
    
    self.myphotoIV.layer.cornerRadius = 32.5;
    self.myphotoIV.layer.masksToBounds = YES;
    
    
    _mBaocun.layer.masksToBounds = YES;
    _mBaocun.layer.cornerRadius = 3;

}




-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
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
    
    imageCropVC = [[RSKImageCropViewController alloc] initWithImage:photo cropMode:RSKImageCropModeCircle];
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
    return   CGRectMake(self.view.center.x-self.myphotoIV.frame.size.width/2, self.view.center.y-self.myphotoIV.frame.size.height/2, self.myphotoIV.frame.size.width, self.myphotoIV.frame.size.height);
    
}
- (UIBezierPath *)imageCropViewControllerCustomMaskPath:(RSKImageCropViewController *)controller
{
    return [UIBezierPath bezierPathWithRect:CGRectMake(self.view.center.x-self.myphotoIV.frame.size.width/2, self.view.center.y-self.myphotoIV.frame.size.height/2, self.myphotoIV.frame.size.width, self.myphotoIV.frame.size.height)];
    
}
- (void)imageCropViewController:(RSKImageCropViewController *)controller didCropImage:(UIImage *)croppedImage
{
    
    [controller.navigationController popViewControllerAnimated:YES];
    
    tempImage = croppedImage;//[Util scaleImg:croppedImage maxsize:140];
    
    _myphotoIV.image = croppedImage;
    
    [[SUser currentUser] updateUserInfo:self.nameTF.text HeadImg:tempImage block:^(SResBase *resb) {
        if (resb.msuccess) {
            [self showSuccessStatus:@"保存成功"];
            [SUser currentUser].mUserName = self.nameTF.text;
            [SUser currentUser].mHeadImg = tempImage;
        
        }else
        {
            [self showErrorStatus:resb.mmsg];
        }
    }];
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



- (IBAction)BaoCunClick:(id)sender {
    
    NSUserDefaults* def = [NSUserDefaults standardUserDefaults];

    if (self.nameTF.text.length <2||self.nameTF.text.length>30) {
        [SVProgressHUD showErrorWithStatus:@"请输入2-30位昵称"];
        [self.nameTF becomeFirstResponder];
        return;
    }

    else if (!tempImage && [self.nameTF.text isEqualToString:[SUser currentUser].mUserName])
    {
        [self showErrorStatus:@"未作任何修改"];
        return;
    }
    [self.nameTF resignFirstResponder];
    
    [[SUser currentUser] updateUserInfo:self.nameTF.text HeadImg:tempImage block:^(SResBase *resb) {
        if (resb.msuccess) {
            [self showSuccessStatus:@"保存成功"];
            [SUser currentUser].mUserName = self.nameTF.text;
            [SUser currentUser].mHeadImg = tempImage;
            
            [self popViewController];
        }else
        {
            [self showErrorStatus:resb.mmsg];
        }
    }];

}


- (IBAction)mGoPhoneClick:(id)sender {
    
    UpdatePhoneVC *up = [[UpdatePhoneVC alloc] initWithNibName:@"UpdatePhoneVC" bundle:nil];
    [self pushViewController:up];
}

- (IBAction)mGoPwdClick:(id)sender {
    
    UpdatePwdVC *pwd = [[UpdatePwdVC alloc] initWithNibName:@"UpdatePwdVC" bundle:nil];
    [self pushViewController:pwd];
}

- (IBAction)mGoNameClick:(id)sender {
    
    UpdateNameVC *update = [[UpdateNameVC alloc] initWithNibName:@"UpdateNameVC" bundle:nil];
    
    [self pushViewController:update];
}

- (IBAction)getPhotoClick:(id)sender {
    
    UIActionSheet *ac = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从相册中选择", nil];
    ac.tag = 1001;
    [ac showInView:[self.view window]];
}
@end
