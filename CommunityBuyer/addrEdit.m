//
//  addrEdit.m
//  CommunityBuyer
//
//  Created by zzl on 15/9/24.
//  Copyright © 2015年 zdq. All rights reserved.
//

#import "addrEdit.h"
#import "fix_searchInMap.h"
#import "dateModel.h"
#import "AddAddressVC.h"
#define MAX_STARWORDS_LENGTH 10
@interface addrEdit ()<UITextFieldDelegate>

@end

@implementation addrEdit
{
    SAddress*   _msubmit;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[IQKeyboardManager sharedManager] setEnable:YES];
    [[IQKeyboardManager sharedManager]setEnableAutoToolbar:YES];
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    [[IQKeyboardManager sharedManager] setEnable:NO];
    [[IQKeyboardManager sharedManager]setEnableAutoToolbar:NO];
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = NO;
    
    [_mname resignFirstResponder];
    [_mtel resignFirstResponder];
    [_mdetail resignFirstResponder];
    
}

- (void)viewDidLoad {
    self.hiddenTabBar = YES;
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _msubmit = SAddress.new;
    if( _mHaveAddr )
    {
        self.mname.text = _mHaveAddr.mName;
        self.mtel.text = _mHaveAddr.mMobile;
        self.maddr.text = _mHaveAddr.mDetailAddress;
        self.maddr.textColor = [UIColor blackColor];
        self.mdetail.text = _mHaveAddr.mDoorplate;
        self.mPageName = @"编辑收货地址";
        
        _msubmit.mAddress = _mHaveAddr.mAddress;
        _msubmit.mlat = _mHaveAddr.mlat;
        _msubmit.mlng = _mHaveAddr.mlng;
        
    }
    else
    {
        self.mPageName = @"新增收货地址";
    }
    
    self.Title = self.mPageName;

    
    _mname.delegate = self;
    _mtel.delegate = self;
    _mdetail.delegate = self;
    self.rightBtnImage = [UIImage imageNamed:@"gougou"];
    
//
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(TextChange) name:UITextFieldTextDidChangeNotification object:nil];
 
}

- (void)TextChange{

    if([_mname isEditing])
        [self TextChange:_mname length:10];
    if([_mdetail isEditing])
        [self TextChange:_mdetail length:250];
}

- (void)TextChange:(UITextField *)textfield length:(int)length{

    NSString *toBeString = textfield.text;
    
    //获取高亮部分
    UITextRange *selectedRange = [textfield markedTextRange];
    UITextPosition *position = [textfield positionFromPosition:selectedRange.start offset:0];
    
    // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
    if (!position)
    {
        if (toBeString.length > length)
        {
            NSRange rangeIndex = [toBeString rangeOfComposedCharacterSequenceAtIndex:length];
            if (rangeIndex.length == 1)
            {
                textfield.text = [toBeString substringToIndex:length];
            }
            else
            {
                NSRange rangeRange = [toBeString rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, length)];
                textfield.text = [toBeString substringWithRange:rangeRange];
            }
        }
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{

    if(string.length == 0)
        return YES;
    if (textField == _mtel && _mtel.text.length>=11) {
        return NO;
    }
    
    return YES;
}


-(void)rightBtnTouched:(id)sender{
    
    if( self.mname.text.length == 0)
    {
        [SVProgressHUD showErrorWithStatus:@"请输入正确收货人名字"];
        return;
    }
    
    if( self.mtel.text.length == 0)
    {
        [SVProgressHUD showErrorWithStatus:@"请输入合法收货人电话"];
        return;
    }
    
    if( self.maddr.text.length == 0)
    {
        [SVProgressHUD showErrorWithStatus:@"请先选择地址区域"];
        return;
    }
    
    if( self.mdetail.text.length == 0)
    {
        [SVProgressHUD showErrorWithStatus:@"请输入合法详细地址"];
        return;
    }
    
    _msubmit.mId = _mHaveAddr.mId;
    _msubmit.mName = self.mname.text;
    _msubmit.mMobile = self.mtel.text;
    _msubmit.mDoorplate = self.mdetail.text;
    _msubmit.mMapPoint = _mHaveAddr.mMapPoint;
    _msubmit.mDetailAddress = _mHaveAddr.mDetailAddress;
    
    __weak addrEdit* rself = self;
    [SVProgressHUD showWithStatus:@"操作中..." maskType:SVProgressHUDMaskTypeClear];
    [_msubmit addOneAddress:^(SResBase *resb, SAddress *retobj) {
        if( resb.msuccess )
        {
            _msubmit =  retobj;
            [SVProgressHUD showSuccessWithStatus:resb.mmsg];
            if( rself.itblock )
                rself.itblock( retobj );
            [rself leftBtnTouched:nil];
        }
        else
            [SVProgressHUD showErrorWithStatus:resb.mmsg];
    }];
    
    
}
- (IBAction)addrTouchDown:(id)sender {
    searchInMap* vc = [[searchInMap alloc]init];
//    vc.mNowAddr = _mHaveAddr.mAddress;
//    vc.mLat = _mHaveAddr.mlat;
//    vc.mLng = _mHaveAddr.mlng;
//    
//    vc.itblock = ^(NSString* add,float lng,float lat){
//        
//        _msubmit.mAddress = add;
//        _msubmit.mlat = lat;
//        _msubmit.mlng = lng;
//        self.maddr.text = add;
//    };
//    [self pushViewController:vc];
    
    AddAddressVC *aa = [[AddAddressVC alloc] initWithNibName:@"AddAddressVC" bundle:nil];
    aa.mAddress = _mHaveAddr;
    
    aa.block = ^(SAddress *addres){
        
        if (addres) {
            
            _msubmit.mId = _mHaveAddr.mId;
            _msubmit.mDetailAddress = addres.mTitle;
            _msubmit.mMapPoint = addres.mMapPoint;
            _msubmit.mlat = addres.mlat;
            _msubmit.mlng = addres.mlng;
            self.maddr.text = addres.mTitle;
            self.maddr.textColor = [UIColor blackColor];
            
            _mHaveAddr = _msubmit;
        }
    };
    
    [self pushViewController:aa];
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
