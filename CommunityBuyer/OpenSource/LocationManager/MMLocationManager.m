//
//  MMLocationManager.m
//  MMLocationManager
//
//  Created by Chen Yaoqiang on 13-12-24.
//  Copyright (c) 2013年 Chen Yaoqiang. All rights reserved.
//

#import "MMLocationManager.h"

@interface MMLocationManager ()<CLLocationManagerDelegate>

@property (nonatomic, strong) LocationBlock locationBlock;
@property (nonatomic, strong) NSStringBlock cityBlock;
@property (nonatomic, strong) NSStringBlock addressBlock;
@property (nonatomic, strong) LocationErrorBlock errorBlock;
@property (nonatomic,strong)CLLocationManager *locationManager;
@end

@implementation MMLocationManager

+ (MMLocationManager *)shareLocation;
{
    static dispatch_once_t pred = 0;
    __strong static id _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] init];
    });
    return _sharedObject;
}

- (id)init {
    self = [super init];
    if (self) {
        NSUserDefaults *standard = [NSUserDefaults standardUserDefaults];
        
        float longitude = [standard floatForKey:MMLastLongitude];
        float latitude = [standard floatForKey:MMLastLatitude];
        self.longitude = longitude;
        self.latitude = latitude;
        self.lastCoordinate = CLLocationCoordinate2DMake(longitude,latitude);
        self.lastCity = [standard objectForKey:MMLastCity];
        self.lastAddress=[standard objectForKey:MMLastAddress];
    }
    return self;
}

- (void) getLocationCoordinate:(LocationBlock) locaiontBlock
{
    self.locationBlock = [locaiontBlock copy];
    [self startLocation];
}

- (void) getLocationCoordinate:(LocationBlock) locaiontBlock  withAddress:(NSStringBlock) addressBlock
{
    self.locationBlock = [locaiontBlock copy];
    self.addressBlock = [addressBlock copy];
    [self startLocation];
}

- (void) getAddress:(NSStringBlock)addressBlock
{
    self.addressBlock = [addressBlock copy];
   // addressBlock(@"");
    [self startLocation];
}

- (void) getCity:(NSStringBlock)cityBlock
{
    self.cityBlock = [cityBlock copy];
    [self startLocation];
}

- (void) getCity:(NSStringBlock)cityBlock error:(LocationErrorBlock) errorBlock
{
    self.cityBlock = [cityBlock copy];
    self.errorBlock = [errorBlock copy];
    [self startLocation];
}
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    [self stopLocation];
    self.locationManager = nil;
    CLLocation* location = [locations lastObject];

    self.lastCoordinate = location.coordinate;

    NSUserDefaults *standard = [NSUserDefaults standardUserDefaults];

    [standard setObject:@(self.lastCoordinate.longitude) forKey:MMLastLongitude];
    [standard setObject:@(self.lastCoordinate.latitude) forKey:MMLastLatitude];

    CLGeocoder *clGeoCoder = [[CLGeocoder alloc] init];
    CLGeocodeCompletionHandler handle = ^(NSArray *placemarks,NSError *error)
    {
        for (CLPlacemark * placeMark in placemarks)
        {
            NSDictionary *addressDic=placeMark.addressDictionary;

            NSString *state=[addressDic objectForKey:@"State"];
            NSString *city=[addressDic objectForKey:@"City"];
            NSString *subLocality=[addressDic objectForKey:@"SubLocality"];
            NSString *street=[addressDic objectForKey:@"Street"];
            NSString *thoroughfare=[addressDic objectForKey:@"Thoroughfare"];

            self.lastCity = city;
            NSMutableString *str = [[NSMutableString alloc] init];
            if (state.length > 0)
                [str appendString:state];
            if (city.length > 0)
                [str appendString:city];
            if (subLocality.length > 0)
                [str appendString:subLocality];
            if (street.length > 0)
                [str appendString:street];
            else if (thoroughfare.length > 0)
                [str appendString:thoroughfare];

            /**
            self.lastAddress = str;
            **/
            //self.lastAddress=[NSString stringWithFormat:@"%@%@%@%@",state,city,subLocality,street];
        self.lastAddress = state;
            [standard setObject:self.lastCity forKey:MMLastCity];
            [standard setObject:self.lastAddress forKey:MMLastAddress];

        }

        if (_cityBlock) {
            _cityBlock(_lastCity);
            _cityBlock = nil;
        }

        if (_locationBlock) {
            _locationBlock(_lastCoordinate);
            _locationBlock = nil;
        }

        if (_addressBlock) {
            _addressBlock(_lastAddress);
            _addressBlock = nil;
        }
    };
    [[NSUserDefaults standardUserDefaults] synchronize];

    [clGeoCoder reverseGeocodeLocation:location completionHandler:handle];

//    _mlongit = l.coordinate.longitude;
//    _mlat = l.coordinate.latitude;

}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    if (_cityBlock) {
        _cityBlock(@"定位失败");
        _cityBlock = nil;
    }
    if (_addressBlock) {
        _addressBlock(@"定位失败");
        _addressBlock = nil;
    }

//    if( error.code == 1 )
//        _itblock(@"您拒绝了获取位置,请到 [设置]=>[隐私]=>[定位服务] 打开 周末指南 定位权限",0);
//    else
//        _itblock(@"定位失败!",0);
}
- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    CLLocation * newLocation = userLocation.location;
    self.lastCoordinate=mapView.userLocation.location.coordinate;
    
    NSUserDefaults *standard = [NSUserDefaults standardUserDefaults];
    
    [standard setObject:@(self.lastCoordinate.longitude) forKey:MMLastLongitude];
    [standard setObject:@(self.lastCoordinate.latitude) forKey:MMLastLatitude];
    
    CLGeocoder *clGeoCoder = [[CLGeocoder alloc] init];
    CLGeocodeCompletionHandler handle = ^(NSArray *placemarks,NSError *error)
    {
        for (CLPlacemark * placeMark in placemarks)
        {
            NSDictionary *addressDic=placeMark.addressDictionary;
            
            NSString *state=[addressDic objectForKey:@"State"];
            NSString *city=[addressDic objectForKey:@"City"];
            NSString *subLocality=[addressDic objectForKey:@"SubLocality"];
            NSString *street=[addressDic objectForKey:@"Street"];
            NSString *thoroughfare=[addressDic objectForKey:@"Thoroughfare"];
            
            self.lastCity = city;
            NSMutableString *str = [[NSMutableString alloc] init];
            if (state.length > 0)
                [str appendString:state];
            if (city.length > 0)
                [str appendString:city];
            if (subLocality.length > 0)
                [str appendString:subLocality];
            if (street.length > 0)
                [str appendString:street];
            else if (thoroughfare.length > 0)
                [str appendString:thoroughfare];
            
            self.lastAddress = str;
            //self.lastAddress=[NSString stringWithFormat:@"%@%@%@%@",state,city,subLocality,street];
            
            [standard setObject:self.lastCity forKey:MMLastCity];
            [standard setObject:self.lastAddress forKey:MMLastAddress];
            
            [self stopLocation];
        }
        
        if (_cityBlock) {
            _cityBlock(_lastCity);
            _cityBlock = nil;
        }
        
        if (_locationBlock) {
            _locationBlock(_lastCoordinate);
            _locationBlock = nil;
        }
        
        if (_addressBlock) {
            _addressBlock(_lastAddress);
            _addressBlock = nil;
        }
    };
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [clGeoCoder reverseGeocodeLocation:newLocation completionHandler:handle];
}

-(void)startLocation
{
    if (_mapView) {
        _mapView = nil;
    }
    
    _mapView = [[MKMapView alloc] init];
    _mapView.delegate = self;
    self.locationManager = [[CLLocationManager alloc] init];

    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    if([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)])
        [self.locationManager requestWhenInUseAuthorization];

    [self.locationManager startUpdatingLocation];
    _mapView.showsUserLocation = YES;
}

-(void)stopLocation
{
    _mapView.showsUserLocation = NO;
    [self.locationManager stopUpdatingLocation];
    _mapView = nil;
}

- (void)mapView:(MKMapView *)mapView didFailToLocateUserWithError:(NSError *)error
{
    [self stopLocation];
}

@end
