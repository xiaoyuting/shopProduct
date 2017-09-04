//
//  AddressTableview.m
//  UserdCarApp
//
//  Created by ljg on 14-10-29.
//  Copyright (c) 2014年 allran.mine. All rights reserved.
//

#import "AddressTableview.h"
#import "MMLocationManager.h"

@implementation AddressTableview
{
    NSMutableArray *keyArray;
    NSMutableDictionary* alldat;
    NSMutableArray* alltitiel;
    NSString *nowStates;
    
    SCity*  _gpscity;
}
AddressTableview *tempView;
-(AddressTableview *)initWithFrame:(CGRect )rect
{
    self = [super initWithFrame:rect];
    if (self)
    {
  //  self = [[AddressTableview alloc]initWithFrame:rect];
        self.delegate = self;
        self.dataSource = self;
        nowStates = @"正在定位...";
        [self reloadData];
        [self getData];
    }
    return self;

}
+(void)showAddressTabeleinView:(UIView *)view StartPoint:(float)startpoint height:(float)height delegate:(id<AddressDelegate>)addrDelegate
{

    AddressTableview * addressTableview = [[AddressTableview alloc]initWithFrame:CGRectMake(0, startpoint-height, DEVICE_Width, height-startpoint+20)];
    addressTableview.addrDelegate  = addrDelegate;
    //  addressTableview.delegate = delegate;
    //  addressTableview.dataSource = dataSource;
    [view addSubview:addressTableview];
    //   [addressTableview reloadData];
    [view bringSubviewToFront:addressTableview];
    [addressTableview SetCurrentAddressTaleview:addressTableview];
    [UIView animateWithDuration:0.4 animations:^{
        CGRect rect = addressTableview.frame;
        rect.origin.y+=height;
        addressTableview.frame = rect;
    }];
}
-(void)SetCurrentAddressTaleview:(AddressTableview *)view
{
    tempView =view;
}


+(AddressTableview*)currentAddressTableView
{
    return tempView;
}
+(void)hideAddressTableView
{

    __block AddressTableview *tableview = [AddressTableview currentAddressTableView];
    [UIView animateWithDuration:0.3 animations:^{
        CGRect rect = tableview.frame;
        rect.origin.y-=DEVICE_InNavTabBar_Height;
        tableview.frame = rect;
    }completion:^(BOOL finished) {
        [tableview removeFromSuperview];
        tableview = nil;
    }];
}


-(void)getData
{
    [[MMLocationManager shareLocation] getAddress:^(NSString *addressString) {
        
        nowStates = addressString;
        for (SCity *acity in [GInfo shareClient].mSupCitys) {
            if ([acity.mName isEqualToString:addressString]) {
                _gpscity = acity;
                
                //如果当前没有选择其他,就把定位的设置成当前的,
                if ([SAppInfo shareClient].mSelCity.length==0||[SAppInfo shareClient].mSelCity==nil) {
                    [SAppInfo shareClient].mSelCity = acity.mName;
                    [SAppInfo shareClient].mCityId = acity.mId;
                    acity.mIsDefault = YES;
                    [[SAppInfo shareClient]updateAppInfo];
                }
            }
        }
        [self reloadData];
        
    }];

}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView              // Default is 1 if not implemented
{
    return 2;
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    //return [keyArray objectAtIndex:section];
    if (section == 0) {
        return @"GPS定位城市";
    }
    else
    {
        return @"已开通服务城市";
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }
    else
        return [GInfo shareClient].mSupCitys.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {

    UILabel *myLabel = [[UILabel alloc] init];
    myLabel.frame = CGRectMake(10, 0, DEVICE_Width, 30);
    myLabel.font = [UIFont boldSystemFontOfSize:18];
    myLabel.text = [self tableView:tableView titleForHeaderInSection:section];

    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = ColorRGB(238, 234, 233);

    [headerView addSubview:myLabel];

    return headerView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *TableSampleIdentifier = @"TableSampleIdentifier";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                             TableSampleIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:TableSampleIdentifier];
    }
    
    cell.tintColor = COLOR(25, 188, 125);

    if ([indexPath section] == 0) {
        cell.textLabel.text = nowStates;
        if( _gpscity.mIsDefault )
        {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        else
        {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }
    else
    {
        SCity *city = [[GInfo shareClient].mSupCitys objectAtIndex:indexPath.row];
        if ([SAppInfo shareClient].mSelCity.length!=0) {

            if (city.mId ==[SAppInfo shareClient].mCityId) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;

            }
            else
            {
                cell.accessoryType = UITableViewCellAccessoryNone;

            }
        }
        else
        {
            if (city.mIsDefault) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            }
            else
            {
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
        }
        cell.textLabel.text = city.mName;

    }
//    NSArray* arr = ((Qu_CarAreas*) [alldat objectAtIndex:indexPath.section]).q_citys;
//    Qu_CarAreas *car = [arr objectAtIndex:row];
//    cell.textLabel.text = car.q_name;
    return cell;
}

//// 刷新完毕就会调用
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return keyArray;
}
-(NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    return [alltitiel indexOfObject:title];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //   return 500;
    return 44;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    if (indexPath.section == 0)
    {
        
        if( _gpscity == nil )
        {
            [SVProgressHUD showErrorWithStatus:@"该城市暂位开通服务"];
            return;
        }
        
        _gpscity.mIsDefault = YES;
        [SAppInfo shareClient].mSelCity = _gpscity.mName;
        [SAppInfo shareClient].mCityId = _gpscity.mId;
        [[SAppInfo shareClient]updateAppInfo];
        
    }
    else
    {
        
        SCity *city = [[GInfo shareClient].mSupCitys objectAtIndex:indexPath.row];
        city.mIsDefault = YES;
        if( city.mId != _gpscity.mId )
        {
            _gpscity.mIsDefault = NO;
        }
        [SAppInfo shareClient].mSelCity = city.mName;
        [SAppInfo shareClient].mCityId = city.mId;
        [[SAppInfo shareClient]updateAppInfo];
        
    }
    
    [self.addrDelegate tableViewCellDidSelectAddress];
    [AddressTableview hideAddressTableView];
    
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
