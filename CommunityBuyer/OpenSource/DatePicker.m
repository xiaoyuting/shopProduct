//
//  DatePicker.m
//  JiaZhengBuyer
//
//  Created by 周大钦 on 15/7/20.
//  Copyright (c) 2015年 zdq. All rights reserved.
//

#import "DatePicker.h"

@implementation DatePicker

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setFrame:CGRectMake(0, 0, DEVICE_Width, 45+216)];
        
        _m_pDate = [[UIDatePicker alloc] initWithFrame:CGRectMake(0.0,45.0,0.0,0.0)];
        //        中文显示
        NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CH"];
        _m_pDate.locale = locale;
        
        _dateFormatter = [[NSDateFormatter alloc] init];
        
        //最小时间延后15分钟
        NSDate *date = [NSDate date];
        
        int time = [date timeIntervalSince1970];
        time = time-3600*8+800;
        
        NSDate *miniDate = [Util dateWithInt:time];
        _m_pDate.minimumDate = miniDate; 
        
        [self addSubview:_m_pDate];
        
        UIImage* imagePicker = [UIImage imageNamed:@"dingbu.png"];
        imagePicker = [imagePicker stretchableImageWithLeftCapWidth:floorf(imagePicker.size.width/2) topCapHeight:floorf(imagePicker.size.height/2)];
        UIImageView* pImageViewBg = [[UIImageView alloc] initWithImage:imagePicker];
    
        [pImageViewBg setFrame:CGRectMake(0, 0, DEVICE_Width, 45)];
        [self addSubview:pImageViewBg];
        //  [pImageViewBg release];
        
        //添加一个按钮确定选择
        UIImage *imageQueding = [UIImage imageNamed:@"Btn@2x.png"];
        
        
        UIButton *pButtonPicker = [UIButton buttonWithType:UIButtonTypeCustom];
        [pButtonPicker setBackgroundImage:imageQueding forState:UIControlStateNormal];
        [pButtonPicker setTitle:@"确定" forState:UIControlStateNormal];
        [pButtonPicker addTarget:self action:@selector(ButtondownQueDing:) forControlEvents:UIControlEventTouchUpInside];
        [pButtonPicker setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [pButtonPicker setFrame:CGRectMake(DEVICE_Width-100, 2, 70, 40)];
        [self addSubview:pButtonPicker];
        //添加一个取消按钮
        UIImage *imageQuXiao = [UIImage imageNamed:@"Btn@2x.png"];
        
        UIButton *pButtonPickerQuXiao = [UIButton buttonWithType:UIButtonTypeCustom];
        [pButtonPickerQuXiao setBackgroundImage:imageQuXiao forState:UIControlStateNormal];
        [pButtonPickerQuXiao setTitle:@"取消" forState:UIControlStateNormal];
        [pButtonPickerQuXiao addTarget:self action:@selector(ButtondownQuXiao:) forControlEvents:UIControlEventTouchUpInside];
        [pButtonPickerQuXiao setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [pButtonPickerQuXiao setFrame:CGRectMake(10, 2, 70, 40)];
        [self addSubview:pButtonPickerQuXiao];
        
    }
    return self;
}
//设置显示类型和时间格式
- (void) setDatePickerType:(UIDatePickerMode)datePickerType dateFormat:(NSString *)dateFormat
{
    _m_pDate.datePickerMode = datePickerType;
    //    显示格式
    [_dateFormatter setDateFormat:dateFormat];
    
 
    
}
-(void)ButtondownQueDing:(id)sender
{
    NSDate *selectTime = [_m_pDate date];
        
    NSString *date = [_dateFormatter stringFromDate:selectTime];
    self.m_pTextDate.text = date;
    self.m_pTextDate.textColor = [UIColor blackColor];
    
    [self setHidden:YES];
   
}
-(void)SetPanDuan:(BOOL)panduan
{
    self.boolPuanDuanShiJian = panduan;
}

-(void)ButtondownQuXiao:(id)sender
{
    [self setHidden:YES];
}


-(void)SetTextFieldDate:(UILabel *)textLabel
{
    self.m_pTextDate = textLabel;
}
- (void)showInView:(UIView *) view
{
   
    self.frame = CGRectMake(0, DEVICE_InNavBar_Height-216+20, DEVICE_Width, 216+45);
    
    [view addSubview:self];
    
}


@end
