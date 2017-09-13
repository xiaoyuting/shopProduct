//
//  TieHeaderVC.h
//  CommunityBuyer
//
//  Created by zzl on 16/2/3.
//  Copyright © 2016年 zdq. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZWImageWaperView;
@class IQTextView;

@interface TieHeaderVC : UIViewController



@property (weak, nonatomic) IBOutlet UIView *mtopuserwaper;
@property (weak, nonatomic) IBOutlet UIImageView *mheadimg;
@property (weak, nonatomic) IBOutlet UILabel *mtitle;
@property (weak, nonatomic) IBOutlet UILabel *mcommname;
@property (weak, nonatomic) IBOutlet UILabel *mtime;

@property (weak, nonatomic) IBOutlet UIView *mmidtiefinowaper;

@property (weak, nonatomic) IBOutlet UILabel *mtietitle;
@property (weak, nonatomic) IBOutlet UILabel *mcontent;

@property (weak, nonatomic) IBOutlet ZWImageWaperView *mimgwaper;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mimgwaperconst;


@property (weak, nonatomic) IBOutlet UIView *mbottominfowaper;



@property (weak, nonatomic) IBOutlet UILabel *mlikecount;
@property (weak, nonatomic) IBOutlet UIImageView *mlikeimg;

@property (weak, nonatomic) IBOutlet UILabel *mchatcount;
@property (weak, nonatomic) IBOutlet UIImageView *mdisimg;

@property (weak, nonatomic) IBOutlet UILabel *mName;
@property (weak, nonatomic) IBOutlet UILabel *mPhone;
- (IBAction)callPhone:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *mAddress;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mAddressHeight;

@property (weak, nonatomic) IBOutlet UIButton *mlikebt;

@property (weak, nonatomic) IBOutlet UIButton *mrebackbt;

@property (weak, nonatomic) IBOutlet UIButton *mtelbt;


@end
