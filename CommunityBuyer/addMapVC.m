//
//  addMapVC.m
//  YiZanService
//
//  Created by zzl on 15/3/23.
//  Copyright (c) 2015年 zywl. All rights reserved.
//

#import "addMapVC.h"
#import <QMapKit/QMapKit.h>
#import "IQKeyboardManager.h"
#import "searchInMap.h"
#import "notifNotInPoly.h"
#import "MapView.h"
#import "UITableView+DataSourceBlocks.h"
#import "MapCell.h"
#import "TableViewWithBlock.h"
@class TableViewWithBlock;


@interface addMapVC ()<QMapViewDelegate,UITextFieldDelegate>

@end

@implementation addMapVC
{
    QMapView *  _viewmapq;
    UIView*     _searchView;
    UIView*     _detailView;
    
    UIButton*   _searchbt;
    UITextField*    _intputdetail;
    
    QPointAnnotation*   _userselect;
    QPointAnnotation*   _userloc;
    
    CLLocationCoordinate2D  _lllll;
    
    NSArray*                _allpolys;//SOnePoly
    
    BOOL isOpened1;
    BOOL isOpened2;
    BOOL isOpened3;
    
    MapView *_mapView;
    
    SCity *_province;
    SCity *_city;
    SCity *_area;
    
    NSArray *pArry;
    NSArray *cityAry;
    NSArray *areaAry;
    
    
    
}
-(void)dealloc
{
    if( _allpolys.count )
    {
        for ( SOnePoly * one in _allpolys ) {
            if( one.mpbuffer != NULL)
                free( one.mpbuffer );
        }
    }
    _allpolys = nil;
    
}


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
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[IQKeyboardManager sharedManager] setEnable:NO];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:NO];
}

- (void)viewDidLoad {
    
    self.hiddenTabBar = YES;
    self.mPageName = _mJustSelect ? @"选择地址" : @"添加地址";
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    self.Title = self.mPageName;
    

    
    _viewmapq = [[QMapView alloc]initWithFrame:CGRectMake(0, 64, DEVICE_Width, DEVICE_InNavBar_Height-50)];
    _viewmapq.delegate = self;
    _viewmapq.showsUserLocation = YES;
   
    UILongPressGestureRecognizer* guest = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(mapLongPressed:)];
    [_viewmapq addGestureRecognizer:guest];
    [self.view addSubview:_viewmapq];
    
    [self addOver];
    
//    [self setSearchBtText:nil];
    
    _userselect = [[QPointAnnotation alloc] init];
    _userselect.title    = @"选择地址";
    _userselect.subtitle = nil;
//    [SVProgressHUD showWithStatus:@"正在获取位置信息" maskType:SVProgressHUDMaskTypeClear];
    
    
    
  
    
}

-(void)mapLongPressed:(UILongPressGestureRecognizer*)sender
{
    if( sender.state == UIGestureRecognizerStateBegan )
    {
        CGPoint p = [sender locationInView:_viewmapq];
        
        [_viewmapq removeAnnotation:_userselect];
        CLLocationCoordinate2D lll = [_viewmapq convertPoint:p toCoordinateFromView:_viewmapq];
        if( _allpolys.count && ![SOnePoly isInPoly:_allpolys nowll:lll] )
        {
            [notifNotInPoly showInVC:self];
            return;
        }
        _userselect.coordinate = lll;
        [_viewmapq addAnnotation:_userselect];
        [self updateSelectPoint];
    }
    
}


-(void)updateSelectPoint
{
    [SVProgressHUD showWithStatus:@"正在获取位置信息" maskType:SVProgressHUDMaskTypeClear];

    [SAppInfo getPointAddress:_userselect.coordinate.longitude lat:_userselect.coordinate.latitude block:^(NSString *address,NSString* city, NSString *err) {
        
        if( err )
        {
            [SVProgressHUD showErrorWithStatus:err];
        }
        else
        {
            int64_t delayInSeconds = 1.0*1.15f;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                [SVProgressHUD dismiss];
                
            });
            
            _userselect.subtitle = address;
           _mapView.mDetailTF.text = address;
        }
        
    }];
}
- (void)mapView:(QMapView *)mapView annotationView:(QAnnotationView *)view didChangeDragState:(QAnnotationViewDragState)newState
   fromOldState:(QAnnotationViewDragState)oldState
{
    if( QAnnotationViewDragStateEnding == newState )
    {//拖动了
        [self updateSelectPoint];
    }
}

- (void)mapView:(QMapView *)mapView annotationView:(QAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
//    [self setSearchBtText:[view.annotation subtitle]];
}
- (QAnnotationView *)mapView:(QMapView *)mapView viewForAnnotation:(id<QAnnotation>)annotation
{
    if ([annotation isKindOfClass:[QPointAnnotation class]])
    {
        static NSString *pointReuseIndetifier = @"pointReuseIndetifier";
        QPinAnnotationView *annotationView = (QPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndetifier];
        
        if (annotationView == nil)
        {
            annotationView = [[QPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndetifier];
        }
        
        BOOL bloc = ![[annotation title] isEqualToString:@"选择地址"];
        
        annotationView.animatesDrop     = YES;
        annotationView.draggable        = !bloc;
        annotationView.canShowCallout   = YES;
        
        annotationView.pinColor =  bloc ? QPinAnnotationColorRed:QPinAnnotationColorGreen;
        annotationView.leftCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeContactAdd];
        return annotationView;
    }
    
    return nil;
}

-(void)mapView:(QMapView *)mapView didUpdateUserLocation:(QUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation
{
    mapView.showsUserLocation = NO;
    
    if( _lllll.latitude != 0.0f && _lllll.longitude != 0.0f)
        [mapView setCenterCoordinate:_lllll zoomLevel:15.0f animated:YES];
    else
        [mapView setCenterCoordinate:userLocation.location.coordinate zoomLevel:15.0f animated:YES];

    /* Red .*/
    _userloc = [[QPointAnnotation alloc] init];
    _userloc.coordinate =userLocation.location.coordinate;
    _userloc.title    = @"定位地址";
    _userloc.subtitle = [NSString stringWithFormat:@"{%f, %f}", _userloc.coordinate.latitude, _userloc.coordinate.longitude];
    
    [mapView addAnnotation:_userloc];
//    [SAppInfo getPointAddress:_userloc.coordinate.longitude lat:_userloc.coordinate.latitude block:^(NSString *address, NSString *err) {
//        if( err )
//        {
//            [SVProgressHUD showErrorWithStatus:err];
//        }
//        else
//        {
//            
//            int64_t delayInSeconds = 1.0*0.7f;
//            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
//            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
//                [SVProgressHUD dismiss];
//            });
//            
//            _userloc.subtitle = address;
//            [self setSearchBtText:address];
//        }
//        
//    }];
    
}
-(void)mapView:(QMapView *)mapView didFailToLocateUserWithError:(NSError *)error
{
    if( error.code == 1 )
    {
        [SVProgressHUD showErrorWithStatus:@"定位权限失败"];
    }
    else
    {
        [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"定位失败:%@",error.description]];
    }
}

- (QOverlayView *)mapView:(QMapView *)mapView viewForOverlay:(id <QOverlay>)overlay
{
    if ([overlay isKindOfClass:[QPolygon class]])
    {
        QPolygonView *polygonView = [[QPolygonView alloc] initWithPolygon:overlay];
        polygonView.lineWidth   = 1;
        polygonView.strokeColor = [UIColor colorWithRed:0.949 green:0.373 blue:0.565 alpha:1.000];
        polygonView.fillColor   = [UIColor colorWithRed:0.949 green:0.373 blue:0.565 alpha:0.630];
        
        
        return polygonView;
    }
    return nil;
}

- (void)ProvinceClick:(UIButton *)sender{

    if (isOpened1) {
        
        
        
        [UIView animateWithDuration:0.3 animations:^{
            
            CGRect frame=_mapView.mProviceTB.frame;
            
            frame.size.height=0;
            [_mapView.mProviceTB setFrame:frame];
            
            
            
        } completion:^(BOOL finished){

                
            isOpened1=NO;
            
            

        }];
        
        

        
    }else{
        
        _mapView.mProviceTB.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        
        
        [UIView animateWithDuration:0.3 animations:^{
            
            
         
            CGRect frame=_mapView.mProviceTB.frame;
            
            if (pArry.count*44 < 150) {
                frame.size.height=pArry.count*44;
            }else{
                frame.size.height=150;
            }
            
            [_mapView.mProviceTB setFrame:frame];
            
        } completion:^(BOOL finished){
            
            isOpened1=YES;

        }];
        
        
    }

}

- (void)CityClick:(UIButton *)sender{
    
    if (!_province) {
        
        [SVProgressHUD showErrorWithStatus:@"请先选择省份"];
        return;
    }
    
    
    
    if (isOpened2) {
        
        
        
        [UIView animateWithDuration:0.3 animations:^{
            
            CGRect frame=_mapView.mCityTB.frame;
            
            frame.size.height=0;
            
            [_mapView.mCityTB setFrame:frame];
            
            
        } completion:^(BOOL finished){
            
            isOpened2=NO;
        }];
    }else{
        _mapView.mCityTB.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        
        [UIView animateWithDuration:0.3 animations:^{
            
            
            CGRect frame=_mapView.mCityTB.frame;
            
            if (cityAry.count*44 < 150) {
                
                frame.size.height=cityAry.count*44;
                
            }else{
                frame.size.height=150;
            }
           
            [_mapView.mCityTB setFrame:frame];
            
        } completion:^(BOOL finished){
            
            isOpened2=YES;
        }];
        
        
    }

    
}
- (void)AreaClick:(UIButton *)sender{
    
    
    if (!_city) {
        
        [SVProgressHUD showErrorWithStatus:@"请先选择城市"];
        return;
    }
    
    
    
    
    
    if (isOpened3) {
        
        
        
        [UIView animateWithDuration:0.3 animations:^{
            
            CGRect frame=_mapView.mAreaTB.frame;
            
            frame.size.height=0;
            [_mapView.mAreaTB setFrame:frame];
            
            
            
        } completion:^(BOOL finished){
            
            isOpened3=NO;
        }];
    }else{
        
        _mapView.mAreaTB.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        [UIView animateWithDuration:0.3 animations:^{
            
            
            CGRect frame=_mapView.mAreaTB.frame;
            
            
            if (areaAry.count*44 < 150) {
                frame.size.height=areaAry.count*44;
            }else{
                frame.size.height=150;
            }
            
            [_mapView.mAreaTB setFrame:frame];
            
            
        } completion:^(BOOL finished){
            
            isOpened3=YES;
        }];
        
        
    }

}

-(void)addOver
{
    
    _mapView = [MapView shareView];
    CGRect rect = _mapView.frame;
    rect.origin.y = 64;
    rect.size.height = 228;
    rect.size.width = DEVICE_Width;
    _mapView.frame = rect;
    [self.view addSubview:_mapView];
    _mapView.mBottomHeight.constant=0;
    
    _mapView.mProvinceView.layer.masksToBounds = YES;
    _mapView.mProvinceView.layer.cornerRadius = 5;
    _mapView.mProvinceView.layer.borderWidth = 1;
    _mapView.mProvinceView.layer.borderColor = COLOR(201, 202, 198).CGColor;
    
    _mapView.mCityView.layer.masksToBounds = YES;
    _mapView.mCityView.layer.cornerRadius = 5;
    _mapView.mCityView.layer.borderWidth = 1;
    _mapView.mCityView.layer.borderColor = COLOR(201, 202, 198).CGColor;
    
    _mapView.mAreaView.layer.masksToBounds = YES;
    _mapView.mAreaView.layer.cornerRadius = 5;
    _mapView.mAreaView.layer.borderWidth = 1;
    _mapView.mAreaView.layer.borderColor = COLOR(201, 202, 198).CGColor;
    
    _mapView.mDetailView.layer.masksToBounds = YES;
    _mapView.mDetailView.layer.cornerRadius = 5;
    _mapView.mDetailView.layer.borderWidth = 1;
    _mapView.mDetailView.layer.borderColor = COLOR(201, 202, 198).CGColor;
    
    [_mapView.mProvinceBT addTarget:self action:@selector(ProvinceClick:) forControlEvents:UIControlEventTouchUpInside];
     [_mapView.mCityBT addTarget:self action:@selector(CityClick:) forControlEvents:UIControlEventTouchUpInside];
     [_mapView.mAreaBT addTarget:self action:@selector(AreaClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self loadTableView];

    
    
    //底部的保存按钮
    UIView* bootom = [[UIView alloc]initWithFrame:CGRectMake(0,DEVICE_Height - 50.0f, DEVICE_Width, 50.f)];
    UIButton * savebt = [[UIButton alloc]initWithFrame:CGRectMake(16, 3, DEVICE_Width - 16*2, 50-3*2)];
    savebt.layer.masksToBounds = YES;
    savebt.layer.cornerRadius = 5;
    savebt.backgroundColor = COLOR(67, 161, 243);
    if( _mJustSelect )
        [savebt setTitle:@"确定" forState:UIControlStateNormal];
    else
        [savebt setTitle:@"保存" forState:UIControlStateNormal];
    
    savebt.titleLabel.font = [UIFont systemFontOfSize:16.0f];
    [savebt addTarget:self action:@selector(savebtClicked:) forControlEvents:UIControlEventTouchUpInside];
    [bootom addSubview:savebt];
    UIImageView* lines = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, DEVICE_Width, 1.0f)];
    lines.image = [UIImage imageNamed:@"disline.png"];
    [bootom addSubview:lines];
    bootom.backgroundColor = [UIColor whiteColor];
    
    if( _mItRegions.count )
        [self addRegions];
    
    [self.view addSubview:_searchView];
    [self.view addSubview:_detailView];
    [self.view addSubview:bootom];
    
}

- (void)loadTableView{
    
    
    pArry = [GInfo shareClient].mSupCitys;
    
    
    isOpened1=NO;
    
    [_mapView.mProviceTB initTableViewDataSourceAndDelegate:^(UITableView *tableView,NSInteger section){
        
        NSInteger num = [pArry count];
        return num;
        
    } setCellForIndexPathBlock:^(UITableView *tableView,NSIndexPath *indexPath){
        MapCell *cell=[tableView dequeueReusableCellWithIdentifier:@"MapCell"];
        if (!cell) {
            cell=[[[NSBundle mainBundle]loadNibNamed:@"MapCell" owner:self options:nil]objectAtIndex:0];
            [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
        }
        
        SCity *province = [pArry objectAtIndex:indexPath.row];
        
        [cell.mlb setText:province.mName];
        return cell;
    } setDidSelectRowBlock:^(UITableView *tableView,NSIndexPath *indexPath){
        MapCell *cell=(MapCell*)[tableView cellForRowAtIndexPath:indexPath];
         SCity *province = [pArry objectAtIndex:indexPath.row];
        _mapView.mProvincelb.text=cell.mlb.text;
        _province = province;
        cityAry = _province.mSubs;
        [_mapView.mCityTB reloadData];
        _mapView.mCitylb.text = @"所在城市";
        _mapView.mArealb.text = @"所在区域";
        _city = nil;
        _area = nil;
        
        
        [UIView animateWithDuration:0.3 animations:^{
            
            CGRect frame=_mapView.mProviceTB.frame;
            
            frame.size.height=0;
            [_mapView.mProviceTB setFrame:frame];
            
        } completion:^(BOOL finished){
            
            isOpened1=NO;
        }];
        
        [UIView animateWithDuration:0.3 animations:^{
            
            CGRect frame=_mapView.mCityTB.frame;
            
            frame.size.height=0;
            
            [_mapView.mCityTB setFrame:frame];
            
            
        } completion:^(BOOL finished){
            
            isOpened2=NO;
        }];
        
        [UIView animateWithDuration:0.3 animations:^{
            
            CGRect frame=_mapView.mAreaTB.frame;
            
            frame.size.height=0;
            [_mapView.mAreaTB setFrame:frame];
            
            
            
        } completion:^(BOOL finished){
            
            isOpened3=NO;
        }];
        
    }];
    
    
    _mapView.mProviceTB.layer.masksToBounds = YES;
    _mapView.mProviceTB.layer.cornerRadius = 5;
    [_mapView.mProviceTB.layer setBorderColor:COLOR(201, 202, 198).CGColor];
    [_mapView.mProviceTB.layer setBorderWidth:1];
    
    
    [_mapView.mCityTB initTableViewDataSourceAndDelegate:^(UITableView *tableView,NSInteger section){
        
        NSInteger num = [cityAry count];
        return num;
        
    } setCellForIndexPathBlock:^(UITableView *tableView,NSIndexPath *indexPath){
        MapCell *cell=[tableView dequeueReusableCellWithIdentifier:@"MapCell"];
        if (!cell) {
            cell=[[[NSBundle mainBundle]loadNibNamed:@"MapCell" owner:self options:nil]objectAtIndex:0];
            [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
        }
        
        SCity *city = [cityAry objectAtIndex:indexPath.row];
        
        [cell.mlb setText:city.mName];
        return cell;
    } setDidSelectRowBlock:^(UITableView *tableView,NSIndexPath *indexPath){
        MapCell *cell=(MapCell*)[tableView cellForRowAtIndexPath:indexPath];
        
        SCity *city = [cityAry objectAtIndex:indexPath.row];
        _mapView.mCitylb.text=cell.mlb.text;
        _city = city;
        areaAry = _city.mSubs;
        [_mapView.mAreaTB reloadData];
        _mapView.mArealb.text = @"所在区域";
        _area = nil;
        
        [UIView animateWithDuration:0.3 animations:^{
            
            CGRect frame=_mapView.mCityTB.frame;
            
            frame.size.height=0;
            [_mapView.mCityTB setFrame:frame];
            
        } completion:^(BOOL finished){
            
            isOpened2=NO;
        }];
        
        [UIView animateWithDuration:0.3 animations:^{
            
            CGRect frame=_mapView.mAreaTB.frame;
            
            frame.size.height=0;
            [_mapView.mAreaTB setFrame:frame];
            
            
            
        } completion:^(BOOL finished){
            
            isOpened3=NO;
        }];
        
        if( areaAry.count == 0 ){
            
            [self getAdressInfo];
            _mapView.mAreaBT.selected = NO;
        }//如果没有区县,,,{}
        
        
    }];
    
    
    _mapView.mCityTB.layer.masksToBounds = YES;
    _mapView.mCityTB.layer.cornerRadius = 5;
    [_mapView.mCityTB.layer setBorderColor:COLOR(201, 202, 198).CGColor];
    [_mapView.mCityTB.layer setBorderWidth:1];
    
    
    [_mapView.mAreaTB initTableViewDataSourceAndDelegate:^(UITableView *tableView,NSInteger section){
        
        NSInteger num = [areaAry count];
        return num;
        
    } setCellForIndexPathBlock:^(UITableView *tableView,NSIndexPath *indexPath){
        MapCell *cell=[tableView dequeueReusableCellWithIdentifier:@"MapCell"];
        if (!cell) {
            cell=[[[NSBundle mainBundle]loadNibNamed:@"MapCell" owner:self options:nil]objectAtIndex:0];
            [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
        }
        SCity *area = [areaAry objectAtIndex:indexPath.row];
        [cell.mlb setText:area.mName];
        return cell;
    } setDidSelectRowBlock:^(UITableView *tableView,NSIndexPath *indexPath){
        MapCell *cell=(MapCell*)[tableView cellForRowAtIndexPath:indexPath];
        SCity *area = [areaAry objectAtIndex:indexPath.row];
        _mapView.mArealb.text=cell.mlb.text;
        _area = area;
        [UIView animateWithDuration:0.3 animations:^{
            
            CGRect frame=_mapView.mAreaTB.frame;
            
            frame.size.height=0;
            [_mapView.mAreaTB setFrame:frame];
            
        } completion:^(BOOL finished){
            
            isOpened3=NO;
        }];
        
        [self getAdressInfo];
        
    }];
    
    
    _mapView.mAreaTB.layer.masksToBounds = YES;
    _mapView.mAreaTB.layer.cornerRadius = 5;
    [_mapView.mAreaTB.layer setBorderColor:COLOR(201, 202, 198).CGColor];
    [_mapView.mAreaTB.layer setBorderWidth:1];

    
}
-(void)getAdressInfo
{
    
    //搜索当前 位置的坐标,,设置地图,,
    NSString* addd = [NSString stringWithFormat:@"%@%@%@",_province.mName,_city.mName, _area.mName.length?_area.mName:@"" ];
    _mapView.mDetailTF.text = addd;

    [SVProgressHUD showWithStatus:@"正在获取位置信息" maskType:SVProgressHUDMaskTypeClear];
    [SAppInfo getAdressPoint:addd block:^(float lng, float lat, NSString *err) {
        
        
        if(err )
            [SVProgressHUD showErrorWithStatus: err];
        else
        {
            int64_t delayInSeconds = 1.0*0.7f;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                [SVProgressHUD dismiss];
            });
            
            [_viewmapq setCenterCoordinate:CLLocationCoordinate2DMake(lat, lng) zoomLevel:15.0f animated:YES];
            [_viewmapq removeAnnotation:_userloc];
            
            /* Red .*/
            _userloc = [[QPointAnnotation alloc] init];
            _userloc.coordinate = CLLocationCoordinate2DMake(lat, lng);
            _userloc.title    = @"区间地址";
            _userloc.subtitle = addd;
            
            [_viewmapq addAnnotation:_userloc];
        }
    }];
}
-(void)addRegions
{
    
    BOOL bbb = NO;
    float latmin = CGFLOAT_MAX;
    float latmax = CGFLOAT_MIN;
    
    float lngmin = CGFLOAT_MAX;
    float lngmax = CGFLOAT_MIN;
    

    NSMutableArray* tmparrr = NSMutableArray.new;
    
    for( NSArray* onedistrict in _mItRegions )
    {
        if( onedistrict.count == 0 ) continue;
        int index = 0;
        CLLocationCoordinate2D* pbuffer = malloc( sizeof(CLLocationCoordinate2D) * onedistrict.count );
        for ( id onexy in onedistrict ) {
            
            pbuffer[index].latitude = [[onexy objectForKey:@"x"] floatValue];
            pbuffer[index].longitude = [[onexy objectForKey:@"y"] floatValue];
            
            if( !bbb )
            {
                if( pbuffer[index].latitude > latmax )
                    latmax = pbuffer[index].latitude;
                if( pbuffer[index].latitude < latmin )
                    latmin = pbuffer[index].latitude;
                
                if( pbuffer[index].longitude > lngmax )
                    lngmax = pbuffer[index].longitude;
                if( pbuffer[index].longitude < lngmin )
                    lngmin = pbuffer[index].longitude;
            }
            index +=1;
        }
        
        QPolygon* ff = [QPolygon polygonWithCoordinates:pbuffer count:onedistrict.count];
        [_viewmapq addOverlays:@[ff]];
        
        SOnePoly* onepy = SOnePoly.new;
        onepy.mpbuffer = pbuffer;
        onepy.mcount = onedistrict.count;
        
        [tmparrr addObject: onepy];
        
        bbb = YES;
    }
    
    _allpolys = tmparrr;
    
    _lllll = CLLocationCoordinate2DMake( ((latmax - latmin ) / 2 ) + latmin , (lngmax - lngmin) / 2 +  lngmin  );
    
}
-(void)savebtClicked:(UIButton*)sender
{
    //保存,,,就获取_searchbt的值,和对应的坐标
    NSString* addr = [_searchbt titleForState:UIControlStateNormal];
    float lng = 0.0f;
    float lat = 0.0f;
    if( [_userselect.subtitle isEqualToString: addr] )
    {
        lng = _userselect.coordinate.longitude;
        lat = _userselect.coordinate.latitude;
    }
    else if ( [_userloc.subtitle isEqualToString:addr] )
    {
        lng = _userloc.coordinate.longitude;
        lat = _userloc.coordinate.latitude;
    }
    if( _intputdetail.text )
    {
        addr = [NSString stringWithFormat:@"%@ %@",addr,_intputdetail.text];
    }
    
    if( _mJustSelect )
    {
        SAddress* retit = SAddress.new;
        retit.mAddress = addr;
        retit.mlat = lat;
        retit.mlng = lng;
        if( _itblock )
            _itblock( retit );
        [self popViewController_2];
    }
    else
    {
        if( [SUser isNeedLogin] )
        {
            [SVProgressHUD showErrorWithStatus:@"请先登录"];
            return;
        }
        float lat = _userloc.coordinate.latitude;
        float lng = _userloc.coordinate.longitude;
        if( _userselect.coordinate.latitude != 0.0f && _userselect.coordinate.longitude != 0.0f )
        {
            lat = _userselect.coordinate.latitude;
            lng = _userselect.coordinate.longitude;
        }
        
        [SVProgressHUD showWithStatus:@"正在保存..." maskType:SVProgressHUDMaskTypeClear];
        /*
        [[SUser currentUser]addAddress:_mapView.mDetailTF.text provid:_province.mId cityid:_city.mId areaid:_area.mId lat:
                                   lat lng:lng block:^(SResBase *resb, SAddress *retobj) {
            
            if( resb.msuccess )
            {
                if( resb.mmsg )
                    [SVProgressHUD showSuccessWithStatus:resb.mmsg];
                else
                    [SVProgressHUD dismiss];
                [self popViewController];
                if( _itblock )
                    _itblock( retobj );
            }
            else
            {
                [SVProgressHUD showErrorWithStatus:resb.mmsg];
            }
        }];
         */
    }
}
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if( textField.text.length < 80 ){
        return YES;
    }
    else
    {
        [SVProgressHUD showErrorWithStatus:@"最多只能输入80个字符"];
        return NO;
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
