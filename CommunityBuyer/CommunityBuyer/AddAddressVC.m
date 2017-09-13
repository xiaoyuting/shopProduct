//
//  AddAddressVC.m
//  MeiRongBuyer
//
//  Created by 周大钦 on 16/1/7.
//  Copyright © 2016年 zdq. All rights reserved.
//

#import "AddAddressVC.h"
#import "AddAddressCell.h"
#import "SearchAddressVC.h"

#define SIZE 20

@interface AddAddressVC ()<QMapViewDelegate,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,SearchAddressDelegate>{

    QMapView *_mapView;
    QPointAnnotation *_userloc;
    
    NSMutableArray *_neararry;
    NSMutableArray *_searcharry;
    
    BOOL flag;
    
    int _page;
    float _templat;
    float _templng;
}

@end

@implementation AddAddressVC

- (void)viewDidLoad {
    self.hiddenTabBar = YES;
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.mPageName = @"选择地址";
    self.Title = self.mPageName;
    
    _mSearchView.layer.masksToBounds = YES;
    _mSearchView.layer.borderColor = M_LINECO.CGColor;
    _mSearchView.layer.borderWidth = 0.8;
    _mSearchView.layer.cornerRadius = 5;
    
    _mTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _mTableView.delegate = self;
    _mTableView.dataSource = self;
    _mTableView.tableFooterView.frame = CGRectZero;
    
    UINib *nib = [UINib nibWithNibName:@"AddAddressCell" bundle:nil];
    [_mTableView registerNib:nib forCellReuseIdentifier:@"cell1"];
    
    self.tableView = _mTableView;
    self.haveFooter = YES;
    self.haveHeader = NO;

    
    _mapView = [[QMapView alloc] initWithFrame:self.mMapView.bounds];
    _mapView.delegate = self;
    _mapView.showsUserLocation = YES;
    
    
    [self.mMapView addSubview:_mapView];
//    [_mapView setZoomLevel:11.01];
  
    _neararry = NSMutableArray.new;
    _searcharry = NSMutableArray.new;
    
    [_mMapView bringSubviewToFront:_mSearchView];
    [_mMapView bringSubviewToFront:_mImg];
    
    self.rightBtnImage = [UIImage imageNamed:@"gougou"];
    
    _page = 1;
}

- (void)footetBeganRefresh{

    _page++;
    
    [self searchNearby:_templat lng:_templng];

}

- (void)rightBtnTouched:(id)sender{

    
    if (_neararry.count>0) {
        
        SAddress *address = [_neararry objectAtIndex:0];
        
        if (_block) {
            _block(address);
        }
        [self popViewController];

    }else{
        
        [SVProgressHUD showErrorWithStatus:@"当前位置为空!"];
    }
    
    
}


- (void)mapViewWillStartLocatingUser:(QMapView *)mapView
{
    //获取开始定位的状态
}

- (void)mapViewDidStopLocatingUser:(QMapView *)mapView
{
    //获取停止定位的状态
}

- (void)mapView:(QMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    
    if (!flag) {
        return;
    }
    NSLog(@"xxxxxxx:%f,%f",mapView.centerCoordinate.latitude,mapView.centerCoordinate.longitude);
    
    [SVProgressHUD showWithStatus:@"加载中..." maskType:SVProgressHUDMaskTypeClear];
    float   llllllat =  mapView.centerCoordinate.latitude;
    float   llllllng =  mapView.centerCoordinate.longitude;
    
    _page = 1;
    [self searchNearby:llllllat lng:llllllng];
  
}

- (void)mapView:(QMapView *)mapView didUpdateUserLocation:(QUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation
{
    _mapView.showsUserLocation = NO;
    //刷新位置
    /* Red .*/
    _userloc = [[QPointAnnotation alloc] init];
    
    _userloc.coordinate =userLocation.location.coordinate;
    _userloc.title    = @"Red";
    
    if (_mAddress) {
        _userloc.coordinate = CLLocationCoordinate2DMake(_mAddress.mlat, _mAddress.mlng);
    }
    _userloc.subtitle = [NSString stringWithFormat:@"{%f, %f}", _userloc.coordinate.latitude, _userloc.coordinate.longitude];
    
//    NSString *point = [NSString stringWithFormat:@"%@(%f,%f,1000)",@"nearby", _userloc.coordinate.latitude, _userloc.coordinate.longitude];
    
    [self searchNearby:_userloc.coordinate.latitude lng:_userloc.coordinate.longitude];
    
//    [_mapView addAnnotation:_userloc];
     [_mapView setCenterCoordinate:_userloc.coordinate zoomLevel:100.0f animated:YES];

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
        
        annotationView.animatesDrop     = YES;
        annotationView.draggable        = YES;
        annotationView.canShowCallout   = YES;
        
        annotationView.pinColor = QPinAnnotationColorRed;
        annotationView.leftCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        return annotationView;
    }
    
    return nil;
}

- (void)searchNearby:(float)lat lng:(float)lng{
    
    NSString *point = [NSString stringWithFormat:@"%@(%f,%f,1000)",@"nearby", lat, lng];
    _templat = lat;
    _templng = lng;
    
    if (_page == 1) {
        [_neararry removeAllObjects];
    }

    NSString* requrl = [NSString stringWithFormat:@"http://apis.map.qq.com/ws/place/v1/search?boundary=%@&page_size=%d&page_index=%d&orderby=_distance&key=%@",point,SIZE,_page,QQMAPKEY];
    
    [SVProgressHUD showWithStatus:@"加载中..." maskType:SVProgressHUDMaskTypeClear];
    [[APIClient sharedClient]GET:requrl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [SVProgressHUD dismiss];
        NSArray* tmpall = [responseObject objectForKey:@"data"];
        if( tmpall.count > 0 )
        {
            for (NSDictionary *dic in tmpall) {
                SAddress *address =  [[SAddress alloc] init];
                address.mTitle = [dic objectForKey:@"title"];
                address.mAddress = [dic objectForKey:@"address"];
                address.mMapPoint = [NSString stringWithFormat:@"%.6f,%.6f",[[[dic objectForKey:@"location"] objectForKey:@"lat"] floatValue],[[[dic objectForKey:@"location"] objectForKey:@"lng"] floatValue]];
                address.mlat = [[[dic objectForKey:@"location"] objectForKey:@"lat"] floatValue];
                address.mlng = [[[dic objectForKey:@"location"] objectForKey:@"lng"] floatValue];
                [_neararry addObject:address];
            }
            
            if (_mAddress) {
                
                BOOL isaddress = NO;
                for (int i = 0;i<_neararry.count;i++) {
                    
                    SAddress *address = [_neararry objectAtIndex:i];
                    
                    if ([address.mTitle isEqualToString:_mAddress.mDetailAddress]) {
                        
                        [_neararry removeObject:address];
                        
                        [_neararry insertObject:address atIndex:0];
                        
                        isaddress = YES;
                    }
                }
                
                //如果 没找到当前地址 则加入当前地址
               
                if (!isaddress && (_mAddress.mlat-lat >= -0.0001 && _mAddress.mlat-lat <= 0.0001 && _mAddress.mlng-lng >= -0.00001 && _mAddress.mlng-lng <= 0.00001)) {
                    
                    SAddress *address = [[SAddress alloc] init];
                    address.mTitle = _mAddress.mDetailAddress;
                    address.mAddress = _mAddress.mDetailAddress;
                    address.mlng = _mAddress.mlng;
                    address.mlat = _mAddress.mlat;
                    address.mMapPoint = _mAddress.mMapPoint;
                    [_neararry insertObject:address atIndex:0];
                    
                }
            }
            
            [self footetEndRefresh];
            
            [self.tableView reloadData];
            
            flag = YES;
        }

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        MLLog(@"search poi err:%@",error);
        [SVProgressHUD showErrorWithStatus:@"检索结果为空"];
        
    }];

}



#pragma mark -- tableviewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView              // Default is 1 if not implemented
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _neararry.count;
    
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    AddAddressCell *cell = (AddAddressCell *)[_mTableView dequeueReusableCellWithIdentifier:@"cell1"];
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_Width, 0.5)];
    line.backgroundColor = M_LINECO;
    
    SAddress *address;
    if (tableView == _mTableView) {
        
        address = [_neararry objectAtIndex:indexPath.row];
    
    }else{
        address = [_searcharry objectAtIndex:indexPath.row];

    }
    
    if (indexPath.row == 0) {
        cell.mTitle.text = [NSString stringWithFormat:@"[当前]%@",address.mTitle];
        cell.mTitle.textColor = [UIColor redColor];
    }else{
        cell.mTitle.text = address.mTitle;
        cell.mTitle.textColor = M_TCO;
    }
    
    cell.mAddress.text = address.mAddress;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SAddress *address;
    
    address = [_neararry objectAtIndex:indexPath.row];
    
    if (_block) {
        _block(address);
    }
    [self popViewController];
    
    
    
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

- (void)resultAddress:(SAddress *)address{
    
    if (_block) {
        
        _block(address);
    }

}

- (IBAction)searchClick:(id)sender {
    
    SearchAddressVC *search = [[SearchAddressVC alloc] initWithNibName:@"SearchAddressVC" bundle:nil];
    search.delegate = self;
    
    search.block = ^(SAddress *address){
    
        if (address) {
            if (_block) {
                
                _block(address);
                
                [self popViewController];
            }
        }
    };
    
    [self pushViewController:search];
}
@end
