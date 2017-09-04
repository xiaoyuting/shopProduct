//
//  DatePicker.h
//  JiaZhengBuyer
//
//  Created by 周大钦 on 15/7/20.
//  Copyright (c) 2015年 zdq. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol postAction<NSObject>

-(void)tapActionSelector;

@end

@interface DatePicker : UIView

@property (strong, nonatomic) UIDatePicker* m_pDate;
@property (strong, nonatomic) UILabel* m_pTextDate;
@property (strong, nonatomic) NSDateFormatter *dateFormatter;
@property (nonatomic)BOOL boolPuanDuanShiJian;
@property (nonatomic,weak) id<postAction> delegate;
-(void)SetTextFieldDate:(UILabel *)textLabel;
- (void)showInView:(UIView *) view;
- (void) setDatePickerType:(UIDatePickerMode)datePickerType dateFormat:(NSString *)dateFormat;

- (void)datePickerValue;
-(void)SetPanDuan:(BOOL)panduan;

@end
