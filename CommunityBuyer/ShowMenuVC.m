//
//  ShowMenuVC.m
//  CommunityBuyer
//
//  Created by zy _cheng_mac on 16/1/22.
//  Copyright © 2016年 zdq. All rights reserved.
//

#import "ShowMenuVC.h"
#import "ShowMenuCell.h"

@interface ShowMenuVC ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) UITableView *menutable;
@property (nonatomic,strong) UIView *bgview;

@property (nonatomic,strong) UIView*    maddInView;

@end

@implementation ShowMenuVC

- (void)viewDidLoad {
    [super viewDidLoad];
 
    
}
 
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

+ (ShowMenuVC*)ShowItemMenu:(UIView *)subView dataArr:(NSArray *)dataArr delegate:(id<ChooseMenuDelegate>)delegate
{
    ShowMenuVC *menuVC=nil;
    
    menuVC=[[ShowMenuVC alloc] init];
    menuVC.delegate = delegate;
    
    
    if (dataArr!=nil) {
        
        menuVC.itemData=dataArr;
        
    }
    
    
    menuVC.menutable=[[UITableView alloc] initWithFrame:CGRectMake(DEVICE_Width-150, 64, 140, menuVC.itemData.count*50) style:UITableViewStylePlain];
    
    UINib *nib=[UINib nibWithNibName:@"ShowMenuCell" bundle:nil];
    [menuVC.menutable registerNib:nib forCellReuseIdentifier:@"cell"];
    //让table的分割线从最左端开始绘制
//    menuVC.menutable.separatorInset = UIEdgeInsetsZero;
    menuVC.menutable.layer.borderWidth = 0.7;
    menuVC.menutable.separatorColor = COLOR(217, 215, 214);//设置行间隔边框
    menuVC.menutable.layer.borderColor = COLOR(217, 215, 214).CGColor;//设置列表边框
    

    
    menuVC.menutable.dataSource=menuVC;
    menuVC.menutable.delegate=menuVC;
    
    menuVC.bgview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_Width, DEVICE_Height)];
    menuVC.bgview.backgroundColor = [UIColor blackColor];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:menuVC action:@selector(hiddenTable)];
    menuVC.bgview.userInteractionEnabled = YES;
    [menuVC.bgview addGestureRecognizer:tap];
    
    menuVC.bgview.alpha = 0.1;
    menuVC.maddInView = subView;
    
    [menuVC showIt];
    return menuVC;
}

-(void)showIt
{
    CGRect  f = self.menutable.frame;
    f.origin.y = 64;
    self.menutable.frame = f;
    [self.maddInView addSubview:self.menutable];
    [self.maddInView addSubview:self.bgview];
    [self.maddInView bringSubviewToFront:self.menutable];
}
//隐藏
- (void)hiddenTable{
    
    [self.bgview removeFromSuperview];
    
    [UIView animateWithDuration:0.2 animations:^{
        CGRect  f = self.menutable.frame;
        f.origin.y = 0 - f.size.height;
        self.menutable.frame = f;
    }completion:^(BOOL finished) {
        
        [self.menutable removeFromSuperview];
    }];
}



#pragma UItabledelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ShowMenuCell *cell=[tableView cellForRowAtIndexPath:indexPath];
    OneItem *item=[self.itemData objectAtIndex:indexPath.row];
    if (cell.isSelect) {
        cell.isSelect=NO;
        
        cell.mText.text=item.mNoramlTxt;

        cell.mImage.image=item.mNoramlImg;
    }else{
        cell.isSelect=YES;
        cell.mText.text=item.mSelectTxt;
        
        cell.mImage.image=item.mSelectImg;

    }
    [self chooseMenu:(int)indexPath.row];
      
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ShowMenuCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    OneItem *item=[self.itemData objectAtIndex:indexPath.row];

    if (item.mSelected) {
        cell.mText.text=item.mSelectTxt;
        
        cell.mImage.image=item.mSelectImg;
        cell.isSelect=YES;
    }else{
        cell.mText.text=item.mNoramlTxt;
        
        cell.mImage.image=item.mNoramlImg;
        cell.isSelect=NO;
    }
    
    
   
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.itemData count];
}


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath

{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (void)chooseMenu:(int)index{
    
    [self hiddenTable];
 
    if( self.delegate && [self.delegate respondsToSelector:@selector(chooseMenuService:)] )
    {
        [self.delegate chooseMenuService:index];
    }
    else
    {
      
        if (index == 0) {
            NSLog(@"0");
            
        }else if (index== 1){
             NSLog(@"1");
        }
        else
        {
            NSLog(@"该下标未实现");
        }
    }

}


@end
