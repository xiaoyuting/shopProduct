//
//  dateModel.h
//  YiZanService
//
//  Created by zzl on 15/3/19.
//  Copyright (c) 2015年 zywl. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <QMapKit/QMapKit.h>

@class SPromotion;
@class SAddress;
@class SCar;
@interface dateModel : NSObject

@end

@interface SAutoEx : NSObject

-(id)initWithObj:(NSDictionary*)obj;

-(void)fetchIt:(NSDictionary*)obj;

@end

//返回通用数据,,,
@interface SResBase : NSObject

@property (nonatomic,assign) int       msuccess;//是否成功了
@property (nonatomic,assign) int        mcode;  //错误码
@property (nonatomic,strong) NSString*  mmsg;   //客户端需要显示的提示信息,正确,失败,根据msuccess判断显示错误还是提示,
@property (nonatomic,strong) NSString*  mdebug;
@property (nonatomic,strong) id         mdata;

-(id)initWithObj:(NSDictionary*)obj;

-(void)fetchIt:(NSDictionary*)obj;

+(SResBase*)infoWithError:(NSString*)error;

@end

@interface SUserState : NSObject

@property (nonatomic,assign)    int    mbHaveNewMsg;

@end

@class SMobile;

@class SSeller;
@class SAuth;
@interface SUser : NSObject

@property (nonatomic,assign) int         mUserId;
@property (nonatomic,strong) NSString*   mPhone;
@property (nonatomic,strong) NSString*   mUserName;
@property (nonatomic,strong) NSString*   mHeadImgURL;
@property (nonatomic,strong) NSString*   mToken;
@property (nonatomic,strong) NSString*   mbalance;
@property (nonatomic,strong) UIImage *   mHeadImg;
@property (nonatomic,strong) SAuth*      mAuth;



//返回当前用户
+(SUser*)currentUser;

//判断是否需要登录
+(BOOL)isNeedLogin;

//退出登陆
+(void)logout;



//发送短信
+(void)sendSM:(NSString*)phone type:(NSString *)type block:(void(^)(SResBase* resb))block;

//登录,密码或者验证码登录
+(void)loginWithPhone:(NSString*)phone psw:(NSString*)psw vcode:(NSString*)vcode block:(void(^)(SResBase* resb, SUser*user))block;

//注册
+(void)regWithPhone:(NSString*)phone psw:(NSString*)psw smcode:(NSString*)smcode  block:(void(^)(SResBase* resb, SUser*user))block;

//重置密码
+(void)reSetPswWithPhone:(NSString*)phone newpsw:(NSString*)newpsw smcode:(NSString*)smcode  block:(void(^)(SResBase* resb, SUser*user))block;


//修改密码
+(void)UpdatePwd:(NSString *)oldPwd newPwd:(NSString *)pwd block:(void(^)(SResBase* resb, SUser*user))block;

//修改电话号码验证旧电话号码
+(void)EverifyMobile:(NSString *)mobile verifyCode:(NSString *)verifyCode block:(void(^)(SResBase* resb,BOOL flag))block;

//修改手机号码
+(void)UpdateMobile:(NSString *)mobile oldMobile:(NSString *)oldMobile verifyCode:(NSString *)verifyCode block:(void(^)(SResBase* resb, SUser*user))block;

//修改用户信息,修改成功会更新对应属性 HeadImg 360x360
-(void)updateUserInfo:(NSString*)name HeadImg:(UIImage*)Head block:(void(^)(SResBase* resb))block;
///会员检查是否注册
- (void)checkReg:(void(^)(SResBase* resb,SSeller* seller))block;

///我要开店
- (void)willCreateStore:(int)mStoreType andLogo:(UIImage*)mLogo andStoreName:(NSString *)mStoreName andCateId:(NSString *)mCateID andAddress:(NSString *)mAddress adressDetail:(NSString *)adressDetail proviceId:(int)proviceId cityId:(int)cityId areaId:(int)areaId mapPosStr:(NSString *)mapPosStr mapPointStr:(NSString *)mapPointStr andMbile:(NSString *)mMobile andName:(NSString *)contacts andIdCard:(NSString *)mIdCard andIdCardImg:(UIImage*)mIdCardImg1 andIdCardImg2:(UIImage *)mIdCardImg2 andLicenceImg:(UIImage *)mLicenceImg andIntroduction:(NSString *)mIntroduction block:(void(^)(SResBase* resb))block;
//获取地址 arr ==> SAddress
-(void)getMyAddress:(void(^)(SResBase* resb,NSArray* arr))block;

//获取我的订单,,
//订单状态 0：全部 1：进行中 2：已完成         all ==> SOderObj
-(void)getMyOrders:(int)type  status:(int)status page:(int)page block:(void(^)(SResBase* resb,NSArray* all,int num))block;
//我收藏的店铺
-(void)getMyFavShop:(int)page block:(void(^)(SResBase* resb,NSArray* arr))block;

//我收藏的商品
-(void)getMyFavGoods:(int)page block:(void(^)(SResBase* resb,NSArray* arr))block;

//消息列表
-(void)getMyMsg:(int)page block:(void(^)(SResBase* resb,NSArray* arr))block;

//是否有消息 消息数 购物车商品数，收藏数，添加地址数
-(void)haveNewMsg:(void(^)(int newMsgCount,int cartGoodsCount,int collectCount,int addressCount,int procount))block;

//获取我的购物车 all ==> SCarSeller
-(void)getMyShopCar:(void(^)(SResBase* resb,NSArray* all))block;

//获取我的优惠卷 status	int	状态 1:已失效 2:可领取 3:未使用
-(void)getMyYouHuiJuan:(int)page status:(int)status sellerId:(int)sellerId money:(double)money block:(void(^)(SResBase* resb,NSArray* all,int cangetcount ))block;

//获取我的第一个可以用的优惠卷
-(void)getMyFirstYouHuiJuan:(void(^)(SResBase* resb ,SPromotion* retobj ))block;

//获取我的帖子 type	int	1 我的帖子，2 我回复的帖子，3 我点赞的帖子
-(void)getMyTie:(int)page type:(int)type block:(void(^)(SResBase* resb,NSArray* all))block;

//获取论坛消息
-(void)getTieMsg:(int)page block:(void(^)(SResBase* resb,NSArray* all))block;

//获取我的小区 all => SDistrict
-(void)getMyDistrict:(void(^)(SResBase* resb,NSArray* all))block;

//是否需要认证
-(BOOL)isNeedAuth;

//是否需要申请门禁功能
-(BOOL)isNeedApply;

//检查身份认证
-(void)checkAuth:(void(^)(SAuth* retobj,SResBase* resb))block;

//是否摇一摇
-(BOOL)isOpenDoorShake:(NSNumber*)setv;

//更新认证信息到存储
-(void)updateAuthInfo:(NSDictionary*)dic;


/**
 *  获取我的余额列表
 */
- (void)getMyYueList:(int)page block:(void(^)(SResBase* resb,NSArray* all))block;

- (void)getbalance:(void (^)(SResBase *resb,NSString *balance))block;


+(void)relTokenWithPush;

+(void)clearTokenWithPush;

+(NSArray*)loadHistoryWaiter;

+(NSArray*)loadHistory;

+(void)clearHistoryWaiter;

+(void)clearHistory;


@end

@class SPayment;
@interface GInfo : NSObject

@property (nonatomic,strong)    NSString*   mGToken;    //全局token
@property (nonatomic,assign)    int         mivint;      //962694
@property (nonatomic,strong)    NSArray*    mSupCitys;  //开通城市 ==> SCity
@property (nonatomic,strong)    NSArray*    mPayment;  //支付信息 ==> SPayment;新版本字段


@property (nonatomic,strong)    NSString*   mAppVersion;
@property (nonatomic,assign)    int        mForceUpgrade;
@property (nonatomic,strong)    NSString*   mAppDownUrl;
@property (nonatomic,strong)    NSString*   mUpgradeInfo;
@property (nonatomic,strong)    NSString*   mServiceTel;
@property (nonatomic,strong)    NSString*   mServiceTime;

@property (nonatomic,strong)    NSString*   mOssid;
@property (nonatomic,strong)    NSString*   mOssKey;
@property (nonatomic,strong)    NSString*   mOssBucket;
@property (nonatomic,strong)    NSString*   mOssHost;

@property (nonatomic,strong)    NSString*   mAboutUrl;          //关于我们Url
@property (nonatomic,strong)    NSString*   mProtocolUrl;       //用户协议Url
@property (nonatomic,strong)    NSString*   mHelpUrl;           //帮助url

@property (nonatomic,strong)    NSString*   mRestaurantTips;    //餐厅订餐说明
@property (nonatomic,strong)    NSString*   mShareQrCodeImage;  //分享二维码图片地址
@property (nonatomic,strong)    NSString*   mShareContent;
@property (nonatomic,strong)    NSString*   mShareTitle;
@property (nonatomic,strong)    NSString*   mshareUrl;
@property (nonatomic,strong)    NSString*   mSystemOrderPass;
@property (nonatomic,strong)    NSString*   mIntroUrl;//优惠券使用说明url

@property (nonatomic,assign)    int         mIsOpenProperty;//是否有开门功能

+(GInfo*)shareClient;

+(void)getGInfoForce:(void(^)(SResBase* resb, GInfo* gInfo))block;

+(void)getGInfo:(void(^)(SResBase* resb, GInfo* gInfo))block;

-(SPayment*)geAiPayInfo;

-(SPayment*)geWxPayInfo;


@end

@interface SProvince : SAutoEx

@property (nonatomic,assign) int mI;
@property (nonatomic,strong) NSString* mN;
@property (nonatomic,strong) NSArray*  mChild;

+ (void)GetProvice:(void(^)(NSArray* all))block;

@end


@interface SCity : NSObject

-(id)initWithObj:(NSDictionary*)obj;

@property (nonatomic,assign)    int         mId;
@property (nonatomic,strong)    NSString*   mName;      //名字
@property (nonatomic,strong)    NSString*   mFirstChar;//拼音首指母
@property (nonatomic,assign)    int        mIsDefault;//是否是默认

@property (nonatomic,strong)    NSArray*    mSubs;// ==> SCity

@end


@interface SWxPayInfo : NSObject

@property (nonatomic,strong) NSString*  mpartnerId;//	string	是			商户号
@property (nonatomic,strong) NSString*  mprepayId;//	string	是			预支付交易会话标识
@property (nonatomic,strong) NSString*  mpackage;//	string	是			扩展字段
@property (nonatomic,strong) NSString*  mnonceStr;//	string	是			随机字符串
@property (nonatomic,assign) int        mtimeStamp;//	int	是			时间戳
@property (nonatomic,strong) NSString*  msign;//	string	是			签名
-(id)initWithObj:(NSDictionary*)obj;

@end


@interface SPayment : NSObject

-(id)initWithObj:(NSDictionary*)obj;


@property (nonatomic,strong)    NSString*   mCode;
@property (nonatomic,strong)    NSString*   mName;
@property (nonatomic,strong)    NSString*   mIconName;
@property (nonatomic,assign)    int        mDefault;

@end


@interface SNotice : SAutoEx

@property (nonatomic,assign)    int         mId;//	int		活动编号
@property (nonatomic,strong)    NSString*   mName;//	string		活动名称
@property (nonatomic,strong)    NSString*   mContent;//	string		内容
@property (nonatomic,assign)    int         mType;//	int		1：外卖2：跑腿3：家政4：汽车5：其他
@property (nonatomic,strong)    NSString*   mServiceRange;//	String		服务范围
@property (nonatomic,strong)    NSString*   mNoticeDate;//	String		活动日期（2012.05.11 – 2012.07.11）


@end

//首页功能分配
@interface SMainFunc : NSObject

@property (nonatomic,assign)    int         mId;
@property (nonatomic,strong)    NSString*   mName;
@property (nonatomic,strong)    NSString*   mImage;
@property (nonatomic,assign)    int         mType;//"点击时处理的类型 1：商户类型 2：服务类型 3：商品详情 4：商家详情 5：URL"
@property (nonatomic,strong)    NSString*   mArg;//"相关参数 根据类型设置 1、商户类型ID 2：服务类型ID 3：商品、服务ID 4：商家ID 5:URL地址"

//获取首页数据 banner ==> SMainFunc, menus ==> SMainFunc, notices ==> SMainFunc, rgoods ==> SGoods , rseller ==> SSeller
+(void)getMainFuncs:(void(^)(SResBase* resb,NSArray* banner,NSArray* menus,NSArray* notices,NSArray* rgoods,NSArray* rseller))block;

@end



//存储一些APP的全局数据
@interface SAppInfo : NSObject<QMapViewDelegate>

@property (nonatomic,strong)    NSString*   mSelCity;//用户选择的城市
@property (nonatomic,assign)    int         mCityId;//用户选择的城市id
@property (nonatomic,strong)    NSString*   mAddr;//当前APP的地址
@property (nonatomic,strong)    NSString*   mCityNow;//APP当前城市
@property (nonatomic,assign)    float       mlng;//当前APP的坐标
@property (nonatomic,assign)    float       mlat;


//用户选择的地址了

//首页选择的地址,,,//和上面有重复了,,以后修改,精简
@property (nonatomic,strong)    SAddress*   mSelectAddrObj;


//支付需要跳出到APP,这里记录回调
@property (nonatomic,strong)    void(^mPayBlock)(SResBase* resb);


-(NSString*)getAppSelectAddrOrLocAddr;

-(float)getAppSelectLatOrLocLat;

-(float)getAppSelectLngOrLocLng;



//修改了属性就调用下这个,
-(void)updateAppInfo;

-(void)getUserLocationQ:(BOOL)bforce block:(void(^)(NSString*err))block;
//定位,,会修改 mAddr mlat mlng
//bforce 是否强制定位,否则是缓存了的
-(void)getUserLocation:(BOOL)bforce block:(void(^)(NSString*err))block;

//根据坐标获取地址
+(void)getPointAddress:(float)lng lat:(float)lat block:(void(^)(NSString* address,NSString* city,NSString*err))block;

//根据地址获取坐标
+(void)getAdressPoint:(NSString*)address block:(void(^)(float lng ,float lat,NSString* err))block;

//获取坐标和当前位置的距离
+(int)calcDist:(float)lat lng:(float)lng;

+(SAppInfo*)shareClient;
///意见反馈
+(void)feedback:(NSString*)content block:(void(^)(SResBase* resb))block;



-(void)willReload;

-(BOOL)canReload;

-(void)reloadReSet;


@end


@interface SAddress: SAutoEx

//获取默认地址
+(SAddress*)loadDefault;

-(id)initWithObj:(NSDictionary*)obj;
-(id)initWithObj:(NSDictionary*)obj bload:(BOOL)bload;
+(void)saveDefault:(SAddress*)obj;


@property   (nonatomic,assign)  int         mId;//	int	编号
@property   (nonatomic,strong)  NSString*   mTitle;
@property   (nonatomic,strong)  NSString*   mAddress;//	string	地址（组装后）,返回
@property   (nonatomic,strong)  NSString*   mName;//	String	收货人
@property   (nonatomic,strong)  NSString*   mMobile;//	String	收货电话
@property   (nonatomic,assign)  int        mIsDefault;//	boolean	是否为默认地址
@property   (nonatomic,assign)  float       mlat;
@property   (nonatomic,assign)  float       mlng;
@property   (nonatomic,strong)  NSString*   mMapPoint;//	String	收货地址坐标(1234,61.23)
@property   (nonatomic,strong)  NSString*   mDetailAddress;//	String	详情地址前段
@property   (nonatomic,strong)  NSString*   mDoorplate;//	String	门牌号




@property   (nonatomic,strong)  NSDictionary*   mdic;
//设置为默认地址
-(void)setThisDefault:(void(^)(SResBase* resb))block;

-(void)delThis:(void(^)(SResBase* resb))block;

//添加地址或者修改一个
-(void)addOneAddress:(void(^)(SResBase* resb,SAddress* retobj))block;

//是否 是一个合法的收货地址
-(BOOL)isVaildAddress;

@end

@interface SStaff : SAutoEx

@property (nonatomic,assign)    int         mId;//	int	ID
@property (nonatomic,strong)    NSString*   mName;//	String	名称
@property (nonatomic,strong)    NSString*   mMobile;//	String	电话

@end

@interface SSeller : SAutoEx

@property (nonatomic,assign)    int         mId;//	int	ID
@property (nonatomic,strong)    NSString*   mName;//	String	名称
@property (nonatomic,strong)    NSString*   mLogo;//	string	图标
@property (nonatomic,assign)    int        mIsCollect;//	int	是否收藏0：未收藏；1：收藏
@property (nonatomic,strong)    NSArray*   mBanner;//	List<Adv>	广告列表
@property (nonatomic,strong)    NSString*   mBusinessHours;//	String	"营业时间8:00 – 23:00"
@property (nonatomic,assign)    int         mIsDelivery;//是否营业 0:商家休息1:商家营业（显示配送时段）
@property (nonatomic,strong)    NSString*   mDeliveryTime;//	String	"配送时间8:00 – 23:00"
@property (nonatomic,strong)    NSString*   mFreight;//	String	配送费，格式化好后返回
@property (nonatomic,strong)    NSString*   mMobile;//	String	电话
@property (nonatomic,strong)    NSString*   mAddress;//	String	地址
@property (nonatomic,strong)    NSString*   mDetail;//	String	商家介绍
@property (nonatomic,assign)    float       mlat;//经度
@property (nonatomic,assign)    float       mlng;//纬度
@property (nonatomic,strong)    NSString*   mDist;
@property (nonatomic,assign)    float       mDeliveryFee;//double	配送费
@property (nonatomic,assign)    float       mServiceFee;//	double	起送费
@property (nonatomic,assign)    int         mCountGoods;
@property (nonatomic,assign)    int         mCountService;
@property (nonatomic,strong)    NSString*   mImage; //商家背景图
@property (nonatomic,assign)    float       mPrice;
@property (nonatomic,strong)    NSString*   mMapPoint;//坐标（12，60）
@property (nonatomic,assign)    float       mScore;
@property (nonatomic,assign)    int         mOrderCount; //销量

//开店用
@property (nonatomic,assign)    int         mIsCheck; //开店状态
@property (nonatomic,strong)    NSString*   mAppurl; //下载地址
@property (nonatomic,assign)    int         mType; //加盟类型
@property (nonatomic,strong)    NSArray*    mCateIds; //经营类型
@property (nonatomic,strong)    NSString*   mIdcardSn;//身份证号码
@property (nonatomic,strong)    NSString*   mIdcardPositiveImg; //身份证正面照
@property (nonatomic,strong)    NSString*   mIdcardNegativeImg; //身份证反面照
@property (nonatomic,strong)    NSString*   mCertificateImg; //营业执照
@property (nonatomic,strong)    NSString*   mBrief; 
@property (nonatomic,strong)    SCity*      mCity; 
@property (nonatomic,strong)    SCity*      mProvince;
@property (nonatomic,strong)    SCity*      mArea;
@property (nonatomic,strong)    NSString*   mMapPointStr;
@property (nonatomic,strong)    NSString*   mAddressDetail;
@property (nonatomic,strong)    NSString*   mMapPosStr;
@property (nonatomic,strong)    NSString*   mContacts; //法人代表
@property (nonatomic,strong)    NSString*   mServiceTel;//服务电话
@property (nonatomic,strong) 	NSString*   mBusinessLicenceImg;//	string	营业执照

//收藏,,自动处理取消还是收藏
-(void)favIt:(void(^)(SResBase* info))block;

//商家详情
-(void)getDetail:(void(^)(SResBase* info))block;

//获取商家列表
//sort	int	"排序方式 0：综合排序 1：销量倒序 2：起送价倒序"
//page	int	当前页码
//type	     int	商户类型ID；0为全部
//keyword	String	搜索关键字
+(void)getAllSeller:(int)sort page:(int)page type:(int)type keyword:(NSString*)keyword block:(void(^)( SResBase* info ,NSArray* all))block;

//获取该商家 商品列表 all ==> SGoodsPack
-(void)getGoods:(void(^)(SResBase* info,NSArray* all))block;

//获取该商家 服务列表
-(void)getServices:(void(^)(SResBase* info,NSArray* all))block;


//allhot 热门的关键字,, allhistory 所有历史搜索关键字
+(void)getSearchKeys:(void(^)(SResBase* info,NSArray*allhot,NSArray* allhistory))block;


+(void)cleanAllKeys;

+(void)getGongGao:(int)sellerId  block:(void(^)( SResBase* info ,NSString* content))block;

//获取物业详情
-(void)getPropDetail:(void(^)(SResBase* info))block;

@end

@interface SGoodsNorms : SAutoEx

@property (nonatomic,assign)    int         mId;//	int	规格编号
@property (nonatomic,assign)    int         mGoodsId;//	int	商品编号
@property (nonatomic,assign)    int         mSellerId;//	int	商家编号
@property (nonatomic,strong)    NSString*   mName;//	string	规格名称
@property (nonatomic,assign)    float       mPrice;//	double	价格
@property (nonatomic,assign)    int         mStock;//	int	商品库存

@property (nonatomic,assign)    int         mCount;//个数,本地需要

@end



@interface SGoods : SAutoEx

@property (nonatomic,assign)    int         mId;//	int	商品ID
@property (nonatomic,strong)    NSString*   mName;//	string	商品名称
@property (nonatomic,assign)    float       mPrice;//	double	价格
@property (nonatomic,strong)    NSArray*    mNorms;//	List<SGoodsNorms>	规格(有规格，默认显示第一个规格价格库存等，无直接显示外层价格)
@property (nonatomic,assign)    int         mStock;//	int	库存数量
@property (nonatomic,assign)    int         mType;//	int	1商品，2服务
@property (nonatomic,assign)    int         mUnit;//	int	0:分钟，1:小时
@property (nonatomic,assign)    int         mDuration;//	int	预约时长
@property (nonatomic,strong)    NSArray*    mImages;//	string	图片
@property (nonatomic,strong)    NSString*   mBrief;//	string	描述
@property (nonatomic,assign)    int         mBuyLimit;//	int	购买限制 0表示不限制，否者表示限制购买的数量
@property (nonatomic,assign)    int         mStatus;//	int	0下架，1上架
@property (nonatomic,assign)    int         mCount;//数量
@property (nonatomic,assign)    int         mNormId;//	选择规格Id
@property (nonatomic,assign)    int        mIscollect;//收藏
@property (nonatomic,strong)    NSString*   mUrl; //详细地址
@property (nonatomic,assign)    int         mSalesCount;//商品列表用

@property (nonatomic,assign)    int         mOrderCount; //销量 收藏用

@property (nonatomic,strong)    NSString*   mLogo;//	string	描述
@property (nonatomic,assign)    BOOL        mIsOpen;

//收藏,,自动处理取消还是收藏
-(void)favIt:(void(^)(SResBase* info))block;

//详情
-(void)getDetail:(void(^)(SResBase* info))block;

//添加到购物车,,数量就是 mCount,normId 规格编号,没有传0 , all ==>SCarSeller
-(void)addToCart:(SGoodsNorms*)normobj block:(void(^)(SResBase* info,NSArray* all))block;

@end

//商品分类对象
@interface SGoodsPack : NSObject

-(id)initWithObj:(NSDictionary*)obj;

@property (nonatomic,assign)    int         mId;//商品分类ID
@property (nonatomic,strong)    NSString*   mName;//商家分类名称
@property (nonatomic,strong)    NSArray*    mGoods;//商品列表 =>SGoods


@end

@interface SCarGoods : SAutoEx

@property (nonatomic,assign)    int         mId;//	int	购物车编号
@property (nonatomic,assign)    int         mGoodsId;//	int	商品ID；(添加购物车时使用)
@property (nonatomic,assign)    int         mNum;//	int	数量；(添加购物车时使用)
@property (nonatomic,strong)    NSString*   mName;//	String	商品名称
@property (nonatomic,strong)    NSString*   mLogo;//	String	图标
@property (nonatomic,assign)    float       mPrice;//	double	价格
@property (nonatomic,strong)    NSString*   mServiceTime;//	String	服务时间(添加购物车时使用,商品不用传)
@property (nonatomic,strong)    NSString*   mNormsId;//	int	规格ID（商品规格）(添加购物车时使用,服务不用传)
@property (nonatomic,assign)    int         mDuration;//	int	时长（分钟）
@property (nonatomic,assign)    int        mIsCollect;//	boolean	收藏状态@end
@property (nonatomic,assign)    int        mIsCheck;
@property (nonatomic,assign)    int         mType;//	int	1商品，2服务

-(void)addToCart:(int)normId block:(void(^)(SResBase* info,NSArray* all))block;


@end


//购物车数据 商家信息
@interface SCarSeller : SAutoEx


//购物车里面的
@property (nonatomic,assign)    int         mId;//
@property (nonatomic,strong)    NSString*   mName;//商家名称
@property (nonatomic,assign)    float       mPrice;//总价
@property (nonatomic,strong)    NSArray*    mCarGoods;//购物车商品列表 ==> SCarGoods
@property (nonatomic,assign)    int         mServiceTime;//服务时间/配送时间
@property (nonatomic,assign)    int        mIsCheck;
@property (nonatomic,assign)    float       mServiceFee;//起送费
@property (nonatomic,assign)    float       mDeliveryFee;//配送费

@property (nonatomic,assign)    int         mCountGoods;
@property (nonatomic,assign)    int         mCountService;


//订单里面的
@property (nonatomic,strong)  NSString* mCommentRemark;// ;// "";
@property (nonatomic,assign)  int       mCommentScore ;// 0;
@property (nonatomic,assign)  int       mCommentTime ;// 0;
@property (nonatomic,assign)  int       mGoodsDuration ;// 0;
@property (nonatomic,assign)  int       mGoodsId ;// 36;
@property (nonatomic,strong)  NSArray* mCartSellers ;//
@property (nonatomic,strong)  NSString* mGoodsName ;// "\U963f\U8428\U5fb7";
@property (nonatomic,strong)  NSString* mGoodsNorms ;// k;
@property (nonatomic,assign)  int       mGoodsNormsId ;// 10;
@property (nonatomic,assign)  int       mSellerId;
@property (nonatomic,assign)  int       mIsRate ;// 0;
@property (nonatomic,assign)  int       mNum ;// 1;
@property (nonatomic,assign)  int       mOrderId ;// 32;

@property (nonatomic,strong)  NSString* mReply;// "";
@property (nonatomic,strong)  NSString* mReplyTime;// 0;
@property (nonatomic,strong)  NSString* mGoodsImages;

//清除购物车所有数据,
+(void)clearCarInfo:(void(^)( SResBase * resb ))block;

//获取购物车商品总数
+(int)allCount:(int)selller;

//获取某商家的某商品购物车详细数据
+(void)getCarInfoWithGoods:(SGoods*)tag;

//获取商家图片
+(NSArray*)getAllGoodsImages:(NSArray*)all;


@end

typedef enum _orderStateNew
{
    ///无
    E_OS_Non                = 000,
    ///等待付款
    E_OS_WaitPayIt          = 100,
    ///付款成功
    E_OS_PaySucsess         = 101,
    ///商家确认并接单
    E_OS_JigouComfirm       = 102,
    ///开始配送
    E_OS_Peison             = 105,
    
    ///会员确认完成
    E_OS_VipComfirmFinish   = 200,
    ///系统自动确认完成
    E_OS_SystemComfirmfinish= 201,
    ///会员取消订单
    E_OS_VipCancelOrder     = 300,
    ///支付超时取消订单
    E_OS_PayTimeOut         = 301,
    ///服务机构拒绝
    E_OS_JigouRefuse        = 302,
    ///服务人员拒绝
    
    ///退款审核中
    E_OS_AuditRefund        = 400,
    ///退款未通过
    E_OS_RefundNotThrought  = 401,
    ///退款处理中
    E_OS_Refunding          = 402,
    ///退款失败
    E_OS_Refundfailure      = 403,
    ///退款成功
    E_OS_RefundSecsess      = 404,
    ///会员删除订单
    E_OS_VipDelOrder        = 500,
    ///服务机构删除订单
    E_OS_JigouDelOrder      = 501,
    
}OrderState;



@class SStaff;
@class SSeller;
@class SShareContent;
@interface SOrderObj : SAutoEx

@property (nonatomic ,copy)   NSString* cardNo;
@property (nonatomic,assign)  int       mId;//	int	编号
@property (nonatomic,strong)  NSString* mSn;//	string	订单号
@property (nonatomic,strong)  NSArray*  mCartSellers;//List<SCarSeller>	商家商品列表
@property (nonatomic,strong)  NSArray*  mGoodsImages;//
@property (nonatomic,strong)  NSString* mAddress;//	String	送货地址
@property (nonatomic,strong)  NSString* mMobile;//收货人电话;
@property (nonatomic,strong)  NSString* mName;//收货人名字
@property (nonatomic,strong)  NSString* mGiftContent;//	String	贺卡内容
@property (nonatomic,strong)  NSString* mInvoiceTitle;//	String	发票抬头
@property (nonatomic,strong)  NSString* mBuyRemark;//	String	订单备注
@property (nonatomic,strong)  NSString* mPayType;//	String	支付方式
@property (nonatomic,strong)  NSString* mFreType;//	String	配送方式
@property (nonatomic,strong)  NSString* mFreTime;//	String	配送时间
@property (nonatomic,strong)  id        mProvince;//	Province	省
@property (nonatomic,strong)  id        mCity;//	City	城市
@property (nonatomic,strong)  id        mArea;//	Area	区
@property (nonatomic,assign)  float     mFreight;//	double	配送费
@property (nonatomic,assign)  float     mTotalFee;//	double	订单总额
@property (nonatomic,assign)  int       mCount;//	int	合计数量
@property (nonatomic,strong)  NSString* mRefuseReason;//	String	拒绝理由
@property (nonatomic,assign)  int       mOrderType;//	int	"订单类型 1:商品 2：服务"
@property (nonatomic,strong)  NSString* mOrderStatusStr;//	String	订单状态，直接显示
@property (nonatomic,strong)  NSString* mCreateTime;//	String	下单时间
@property (nonatomic,assign)  int      mIsCanDelete;//	bool	是否可以删除
@property (nonatomic,assign)  int      mIsCanRate;//	bool	是否可以评价
@property (nonatomic,assign)  int      mIsCanCancel;//	bool	是否可以取消
@property (nonatomic,assign)  int      mIsCanPay;//	bool	是否可以付款
@property (nonatomic,assign)  int      mIsContactCancel; // bool    是否完成订单
@property (nonatomic,assign)  int      mIsCanConfirm;//	bool	是否可以确认订单完成
@property (nonatomic,assign)  int      mIsCanRefund;//	bool	是否可以退款
@property (nonatomic,assign)  int      mIsCanReminder;//是否可以催单
@property (nonatomic,assign)  OrderState mStatus;//int "订单状态
@property (nonatomic,strong)  NSString* mRefundContent; //退款原因
@property (nonatomic,strong)  NSString* mRefundTime; //退款时间
@property (nonatomic,strong)  NSString* mAppTime;
@property (nonatomic,assign)  int       mSellerId;// 商家ID
@property (nonatomic,assign)  int       mSellerType;
@property (nonatomic,strong)  NSString* mSellerName;// 商家名称
@property (nonatomic,strong)  NSString* mSellerTel;// 商家电话
@property (nonatomic,strong)  NSString* mStaffName;// 配送人员名称
@property (nonatomic,strong)  NSString* mStaffMobile;// 配送人员电话
@property (nonatomic,strong)  NSString* mStatusFlowImage;
@property (nonatomic,strong)  NSString* mShopName;

@property (nonatomic,assign)  float     mDiscountFee;//优惠金额
@property (nonatomic,assign)  float     mPayFee;//支付金额

@property (nonatomic,assign)  int       isbalancePay;//是否使用余额支付

@property (nonatomic,assign) float money;//充值金额
@property (nonatomic,strong) NSString *payurl;//充值金额

@property (nonatomic,assign) int    mPromotionIsShow;//是否显示过了,0 没有,1 显示了
@property (nonatomic,assign) float  mPayMoney;//余额已支付金额
@property (nonatomic,strong) NSString * misCanRefundStatusNew;
@property (nonatomic,strong) NSString * mshowImgNew;



//cartIds	 	购物车编号(数组)
//addressId	 	送货地址编号
//giftContent	 	贺卡内容
//invoiceTitle	 	发票抬头
//buyRemark	 	订单备注
//appTime	 	配送时间(商品才传)
//promotionSn 优惠卷
+(void)dealOneOrder:(NSArray*)carids addressId:(int)addressId giftContent:(NSString*)giftContent cardNO:(NSString*)cardNo invoiceTitle:(NSString*)invoiceTitle buyRemark:(NSString*)buyRemark appTime:(NSDate*)appTime  bonelinepay:(int)bonelinepay promotionSnId:(NSString*)promotionSnId block:(void(^)(SResBase* resb,SOrderObj* retobj))block;

//服务订单提交 不需要支付，下单成功后直接跳转至订单详情 itid 服务ID
+(void)dealServiceOneOrder:(int)itid mobileid:(int)mobileid addressid:(int)addressid block:(void(^)( SResBase* resb, SOrderObj* retobj ))block;

//充值
- (void)payIt:(float)money paytype:(NSString *)paytype vc:(UIViewController *)vc block:(void (^)(SResBase *))block;

//支付 paytype 支付方式 ==> SPayment.mName
-(void)payIt:(int)balance choosePaytype:(NSString*)paytype vc:(UIViewController*)vc block:(void(^)(SResBase* resb))block;

//订单详情
-(void)getDetail:(void(^)(SResBase* resb))block type:(NSString *)type;

//取消订单
-(void)cancelThis:(NSString*)remark block:(void(^)(SResBase* resb))block;

//删除订单
-(void)deleteThis:(void(^)(SResBase* resb))block;
//卡卷申请退款
-(void)pullMoney:(NSString *)goodID :(void(^)(SResBase* resb))block;

//卡卷取消申请退款
-(void)cancelPullMoney:(NSString *)goodID :(void(^)(SResBase* resb))block;

//订单确认完成（外卖）
-(void)confirmThis:(void(^)(SResBase* resb))block;

//催单
-(void)cuidanThis:(void(^)(SResBase* resb))block;

//申请退款 refundContentt退款理由
-(void)refundThis:(NSString*)refundContent refundImages:(UIImage*)refundImages block:(void(^)(SResBase* resb))block;


//评价订单
-(void)cmmThis:(NSString*)content star:(int)star imgs:(NSArray*)imgs bno:(int)isAno block:(void(^)(SResBase* resb))block;

/**
 *  分享活动
 *
 *  @param mOrderID 订单id
 *  @param block    返回值
 */
- (void)getActivity:(void(^)(SShareContent *mShare,SResBase* resb))block;


-(void)notShowBigShare;


@end

@interface SOrderRate : SAutoEx


@property (nonatomic,assign) float mStar;             //平均星级
@property (nonatomic,assign) int mTotalCount;       //总评价数
@property (nonatomic,assign) int mGoodCount;        //好评数
@property (nonatomic,assign) int mNeutralCount;     //中评数
@property (nonatomic,assign) int mBadCount;         //差评数


+(void)getRateNum:(int)sellerId block:(void(^)(SResBase* resb,SOrderRate *rate))block;

@end


@interface SOrderRateInfo : SAutoEx

@property (nonatomic,assign)  int       mId;        //int 编号
@property (nonatomic,strong)  NSString* mUserName;  //String;//评价用户昵称
@property (nonatomic,strong)  NSString* mAvatar;   // string;//会员头像
@property (nonatomic,strong)  NSString* mContent;   // string;//评价内容
@property (nonatomic,strong)  NSString* mReply;// string;//商家回复
@property (nonatomic,strong)  NSString* mReplyTime;// String;//"商家评价回复时间2015-07-29"
@property (nonatomic,assign)  int       mStar;//int 评价星级（1-5）
@property (nonatomic,strong)  NSString* mCreateTime;//String;//"创建时间2015-07-29"
@property (nonatomic,assign)  int       mOrderId;
@property (nonatomic,strong)  NSArray*  mImages;//评价图片

//获取评价
//typ 1:好评 2:中评 3:差评 ; arr => SComments1:
//获取评价
+(void)getComments:(int)type page:(int)page sellerId:(int)sellerId block:(void(^)(SResBase* resb,NSArray* arr))block;

@end




@interface SServiceInfo : SAutoEx

@property (nonatomic,assign)  int       mId;//int 编号
@property (nonatomic,strong)  NSString* mName;//string;//名称
@property (nonatomic,assign)  float     mPrice;//price
@property (nonatomic,assign)  int       mDuration;//时长（分钟）
@property (nonatomic,assign)  int      mIsCollect;//收藏状态
@property (nonatomic,strong)  NSArray *mImages;
@property (nonatomic,assign)  int       mNum;//
@property (nonatomic,strong)  NSString* mLogo;
@property (nonatomic,strong)  NSString* mUrl;
@property (nonatomic,assign)  int       mSalesCount;

//收藏,,自动处理取消还是收藏
-(void)favIt:(void(^)(SResBase* info))block;


//获取详情
-(void)getDetail:(void(^)(SResBase* resb))block;

//服务评价列表 allrates ==> SOrderRateInfo
-(void)getRateList:(int)page block:(void(^)(SResBase* resb, NSArray* allrates ))block;

//添加到购物车,,数量就是 mCount,normId 规格编号,没有传0 , all ==>SCarSeller
-(void)addToCart:(NSString*)timestr block:(void(^)(SResBase* info,NSArray* all))block;;


@end







@interface SMessageInfo : NSObject
-(id)initWithAPN:(NSDictionary*)objapn;
-(id)initWithObj:(NSDictionary*)obj;
@property (nonatomic,assign)    int       mId;//int 编号
@property (nonatomic,strong)    NSString *mContent;// string  内容
@property (nonatomic,strong)    NSString *mTitle;// string  标题
@property (nonatomic,strong)    NSString *mCreateTime;//  string  "创建时间2015-08-09"
@property (nonatomic,assign)    int      mIsRead;//  int "是否已读0：已读1：未读"
@property (nonatomic,assign)    int      mType;//  int "消息类型1：普通消息2：html页面，args为url3：订单消息，args为订单id"
@property (nonatomic,strong)    NSString *mArgs;//    参数
@property (nonatomic,assign)    int      mCrateType;// int "消息来源类型0：平台1：商家"


//读这个
-(void)readThis:(void(^)(SResBase* resb))block;

//删除这个
-(void)delThis:(void(^)(SResBase* resb))block;

//阅读,批量,all==nil,表示所有
+(void)readAll:(NSArray*)all block:(void(^)(SResBase* resb))block;

//删除,批量,all==nil,表示所有
+(void)delAll:(NSArray*)all block:(void(^)(SResBase* resb))block;


@end



@interface SSellerCate : SAutoEx

@property (nonatomic,assign)    int         mId;//	int	分类ID
@property (nonatomic,strong)    NSString *  mName;//	String	分类名称
@property (nonatomic,assign)    int         mType;//	int	类型（商品或服务）
@property (nonatomic,assign)    int         mSort;//	int	排序
@property (nonatomic,strong)    NSString *  mLogo;//    图标
@property (nonatomic,strong)    NSArray*    mChilds; //二级分类
@property (nonatomic,assign)    BOOL        mIsCheck;

///是否选择
@property (nonatomic,assign)    int        mSelected;

+(void)getAllCates:(int)sellerid andType:(int)type  block:(void(^)(SResBase* resb,NSArray* all))block;

@end


@interface SForumPlate : SAutoEx

@property (nonatomic,assign)    int         mId;//	int	编号
@property (nonatomic,strong)    NSString *  mName;//	string 板块名称
@property (nonatomic,strong)    NSString *  mIcon;//	string	图片

//
-(void)getThisPosts:(int)page block:(void(^)(SResBase* resb,NSArray* all))block;

//获取所有板块
+(void)getAllPlates:(void(^)(SResBase* resb,NSArray* all))block;


@end

@interface SForumPosts : SAutoEx

@property (nonatomic,assign)    int         mId;//	int	编号
@property (nonatomic,assign)    int         mPid;//	int	0 表示帖子， 大于0回复编号为pid的帖子
@property (nonatomic,strong)    SUser*      mUser;//	User	创建者
@property (nonatomic,strong)    NSString *  mTitle;//	string	标题
@property (nonatomic,strong)    NSString *  mContent;//	string	内容
@property (nonatomic,strong)    NSArray*    mImagesArr;//	List<String>	图片数组
@property (nonatomic,assign)    int         mTop;//	int	0不顶置，1顶置
@property (nonatomic,assign)    int         mHot;//	int	0不热门，1热门
@property (nonatomic,assign)    int         mRateNum;//	int	好评数量
@property (nonatomic,assign)    int         mGoodNum;//	int	点赞数量
@property (nonatomic,strong)    NSString *  mCreateTimeStr;//	string	创建时间
@property (nonatomic,strong)    SAddress *  mAddress;//	Address	地址对象
@property (nonatomic,strong)    SForumPlate *  mPlate;//	Plate	板块信息
@property (nonatomic,assign)    int         mIsCheck;//	int	是否通过审核
@property (nonatomic,strong)    NSArray *   mChilds;//	List<ForumPosts>	帖子回复列表
@property (nonatomic,assign)    int         mIsPraise;//是否点赞
@property (nonatomic,assign)    int         mFlood;//	int	楼层（论坛详情里面的回复有效）
@property (nonatomic,strong)    SForumPosts*mReplyPosts;//	ForumPosts	回复的帖子
@property (nonatomic,strong)    NSString*   mReplyContent;//	string	回复内容（如：引用"153100****8"的回复：）


//提交,保存帖子
-(void)submitPost:(void(^)(SResBase* resb))block;

//搜索帖子,会自动记录搜索的关键字,做为历史记录
+(void)searchPost:(int)page keywords:(NSString*)keywords block:(void(^)(SResBase* resb,NSArray* all))block;

//获取记录记录
+(NSArray*)getHistory;

//删除历史记录
+(void)delThisHistory:(NSString*)keywords;

//获取评论 ==> all
//isLandlord	int	1表示只看楼主 0表示所有
//sort	int	根据时间 （0 升序，1 降序） 排列
-(void)getRebacks:(int)page isLandlord:(int)isLandlord sort:(int)sort block:(void(^)(SResBase* resb,NSArray* all))block;

//删除
-(void)delThis:(void(^)(SResBase* resb))block;

//回复,
-(void)rebackThis:(NSString*)content block:(void(^)(SResBase* resb))block;

//点赞
-(void)goodThis:(void(^)(SResBase* resb))block;

//举报
-(void)reportThis:(NSString*)content block:(void(^)(SResBase* resb))block;


@end

@interface SForumIndex : SAutoEx


@property (nonatomic,assign)    int         mMessagenum;//
@property (nonatomic,assign)    int         mPostsnum;//
@property (nonatomic,strong)    NSArray*    mPlates;//==> SForumPlate
@property (nonatomic,strong)    NSArray*    mPosts;//==> SForumPosts


+(void)getForumIndex:(void(^)(SResBase* resb,SForumIndex* retobj))block;



@end

@interface SOrderCompute : SAutoEx
@property (nonatomic,assign)   BOOL     isBind;
@property (nonatomic,assign)   BOOL     isCard;
@property (nonatomic,assign)   BOOL     todayUsed;
@property (nonatomic,assign)   double   mGoodsFee;//	Double	商品金额
@property (nonatomic,assign)   double   mTotalFee;//	Double	总金额
@property (nonatomic,assign)   double   mDiscountFee;//	Double	优惠金额
@property (nonatomic,assign)   double   mFreight;//	Double	配送费
@property (nonatomic,assign)   double   mPayFee;//	Double	支付金额
@property (nonatomic,assign)   int      mIsCashOnDelivery;//	int	是否支持货到付款 0：不支持 1：支持
@property (nonatomic,assign)   int      mIsShowPromotion;//	int	是否显示优惠券 0:否 1:是
@property (nonatomic,assign)   int      mPromotionCount;//	int	可选的优惠券数量 用于判断显示有无可选优惠券
@property (nonatomic,assign)   int      mSellerId;//	int	商家编号
@property (nonatomic,assign)   double   mTotalMoney;//	double	总金额(商品金额+配送费),不算优惠券金额


//计算购物车价格 promotionSn 优惠卷 carids 购物车编号(数组)
+(void)computerInfo:(NSString*)promotionSnId carids:(NSArray*)carids block:(void(^)(SResBase* resb ,SOrderCompute* retobj ))block;


@end

@interface  SPromotion : SAutoEx

@property (nonatomic,assign)    int             mId;//	int	优惠券SN表编号
@property (nonatomic,assign)    int             mPromotionId;//	int	优惠群编号(领取优惠券时用)
@property (nonatomic,strong)    NSString*       mSn;//	string	优惠券SN码
@property (nonatomic,assign)    int             mStatus;//	int	是否已失效 0:否 1:是
@property (nonatomic,strong)    NSString*       mExpireTimeStr;//	string	过期时间,直接显示(如:2016-01-01或 永久有效)
@property (nonatomic,strong)    NSString*       mName;//	string	优惠券名称
@property (nonatomic,strong)    NSString*       mBrief;//	string	优惠群描述
@property (nonatomic,assign)    float           mMoney;//	double	金额
@property (nonatomic,strong)    NSString*       mType;//	string	优惠券类型: offset :抵用券 money: 优惠券

-(BOOL)bY;// YES 优惠券 ,  NO 抵用券 ,

//优惠券兑换
+(void)exchangeOne:(NSString*)sn block:(void(^)(SResBase* resb ,SPromotion* retobj ))block;

//领取
-(void)getThis:(void(^)(SResBase* resb ,SPromotion* retobj ))block;


@end

@interface SForumMessage : SAutoEx

@property (nonatomic,assign)    int             mId;//	int	编号
@property (nonatomic,assign)    int             mType;//	int	类型 1:系统消息 2:其他 (后续待增加)
@property (nonatomic,strong)    NSString*       mTitle;//	string	标题
@property (nonatomic,strong)    NSString*       mContent;//	string	内容
@property (nonatomic,strong)    NSString*       mSendTime;//	string	推送时间
@property (nonatomic,strong)    SForumPosts*    mPosts;//	FormPosts	帖子对象
@property (nonatomic,strong)    SUser*          mUser;//	User	接收者
@property (nonatomic,strong)    SUser*          mRelatedUser;//	User	关联会员
@property (nonatomic,strong)    NSString*       mReadTime;//

//删除这个
-(void)delThis:(void(^)(SResBase* resb ))block;

//已读
-(void)readThis:(void(^)(SResBase* resb ))block;

@end



@interface SDoorKeysInfo : SAutoEx

@property (nonatomic,assign)    int             mDoorid;//	int	是			小区门编号
@property (nonatomic,strong)    NSString*       mDoorname;//	string	是			门名字
@property (nonatomic,strong)    NSString*       mRemark;
@property (nonatomic,strong)    NSString*       mExpiretime;//	string	是			过期时间
@property (nonatomic,strong)    NSString*       mUserid;//	string	是			用户 ID
@property (nonatomic,strong)    NSString*       mKeyid;//	string	是			钥匙 ID
@property (nonatomic,strong)    NSString*       mKeyname;//	string	是			钥匙名称
@property (nonatomic,strong)    NSString*       mCommunity;//	string	是			小区标识
@property (nonatomic,strong)    NSString*       mAppkey;//	string	是			服务端认证key

//获取门禁列表
+ (void)getDoorKeys:(int)villagesid block:(void(^)(SResBase* resb,NSArray* all))block;

//修改门禁信息
- (void)updateDoorKeys:(NSString *)doorname block:(void(^)(SResBase* resb))block;

//开门记录
-(void)openRecode:(int)ecode did:(int)did bid:(int)bid rid:(int)rid;


@end

@interface SRoom : SAutoEx

@property (nonatomic,assign)    int             mId;//	int	是			编号
@property (nonatomic,strong)    NSString*       mRoomNum;//	string	是			房间号
@property (nonatomic,assign)    int             mSellerId;//	int	是			物业编号
@property (nonatomic,assign)    int             mDistrictId;//	int	是			小区编号
@property (nonatomic,strong)    NSString*       mOwner;//	string	是			业主
@property (nonatomic,strong)    NSString*       mMobile;//	string	是			电话
@property (nonatomic,strong)    NSString*       mRemark;//	string	是			备注
@property (nonatomic,assign)    int             mBuildId;//	int	是			楼栋号
@property (nonatomic,assign)    double          mPropertyFee;//	double	是			物业费
@property (nonatomic,assign)    int             mRoomArea;//	int	否			套内面积
@property (nonatomic,assign)    int             mStructureArea;//	int	否			建筑面积
@property (nonatomic,strong)    NSString*       mIntakeTime;//	string	否			入住时间

@end


@interface SBuilding : SAutoEx

@property (nonatomic,assign)    int             mId;//	int	是			编号
@property (nonatomic,strong)    NSString*       mName;//	string	是			名称
@property (nonatomic,assign)    int             mSellerId;//	int	是			物业编号
@property (nonatomic,assign)    int             mDistrictId;//	int	是			小区编号
@property (nonatomic,strong)    NSString*       mRemark;//	string	是			备注

//获取这栋楼的所有房间
-(void)getRooms:(void(^)(NSArray* all,SResBase* resb))block;


@end

@interface SDistrict: SAutoEx

@property (nonatomic,assign)    int             mId;//	int	是			编号
@property (nonatomic,strong)    NSString*       mName;//	string	是			名称
@property (nonatomic,strong)    NSString*       mAddress;//	string	是			地址
@property (nonatomic,assign)    int             mProvinceId;//	int	是			省
@property (nonatomic,assign)    int             mCityId;//	int	是			城市
@property (nonatomic,assign)    int             mAreaId;//	int	是			区域
@property (nonatomic,strong)    NSString*       mMapPointStr;//	String	是			坐标
@property (nonatomic,strong)    NSString*       mHouseTypeName;//	String	否			房产类型
@property (nonatomic,assign)    int             mHouseNum;//	int	否			户数
@property (nonatomic,assign)    int             mAreaNum;//	Int	否			面积
@property (nonatomic,assign)    int             mIsEnter;//	int	否			是否开通物业0否1是
@property (nonatomic,assign)    int             mCountDistrict;//	int	否			小区数量（大于1时显示切换按钮）
@property (nonatomic,strong)    NSString*       mLocation;//	string	是			地区
@property (nonatomic,strong)    NSString*       mSellerName;//	string	否			物业公司名称
@property (nonatomic,strong)    SSeller*        mSeller;//	Seller	否			物业公司对象
@property (nonatomic,assign)    int             mSellerId;//	int	是			物业编号0表示未入驻
@property (nonatomic,assign)    int             mIsUser;//	int	是			会员是否加入1已加入

//获取这个小区的所有楼栋号
-(void)getBuilds:(void(^)(NSArray* all,SResBase* resb))block;

//搜索小区
+(void)searchDistrict:(NSString*)keywords block:(void(^)(NSArray* all,SResBase* resb))block;

//删除这个小区
-(void)delThis:(void(^)(SResBase* resb))block;


//加入我的小区
-(void)addThis:(void(^)(SResBase* resb))block;


//获取详情
-(void)getDetail:(void(^)(SResBase* resb))block;


//获取保修列表 all =>> SRepair
-(void)getRepairList:(int)page block:(void(^)(SResBase* resb,NSArray* all))block;

//获取是否可以进入
-(void)checkDoor:(void(^)(SAuth* retobj,SResBase* resb))block;


@end

@interface SAuth : SAutoEx

@property (nonatomic,assign)    int             mId;//	int	是			编号
@property (nonatomic,strong)    SBuilding*         mBuild;//	Build	是			楼栋对象
@property (nonatomic,strong)    SDistrict*      mDistrict;//	District	是			小区编号
@property (nonatomic,strong)    SRoom*          mRoom;//	Room	是			楼栋号
@property (nonatomic,strong)    NSString*       mName;//	string	是			业主
@property (nonatomic,strong)    NSString*       mMobile;//	string	是			电话
@property (nonatomic,assign)    int             mStatus;//	int	是			身份认证状态0待审核1通过-1拒绝
@property (nonatomic,assign)    int             mAccessStatus;//	int	是			"门禁申请状态默认是   0 不能进入开锁界面   1  申请成功，可以进入开锁界面"
@property (nonatomic,assign)    int             mIsProperty;//	int	否			是否开通物业1、需要开通
@property (nonatomic,assign)    int             mIsVerify;//	int	否			是否申请验证1、需要申请
@property (nonatomic,assign)    int             mIsCheck;//	int	否			是否通过验证1、需要验证
@property (nonatomic,assign)    int             mSellerId;//	int	是			物业编号

-(void)submitThisAuth:(void(^)(SResBase* resb))block;

//获取我的物业信息
+(void)getMyWuye:(int)sdid block:(void(^)(SResBase*resb,SAuth* retobj))block;

@end


@interface SArticle: SAutoEx

@property (nonatomic,assign)    int             mId;//	int	是			公告编号
@property (nonatomic,assign)    int             mSellerId;//	int	是			商家编号
@property (nonatomic,strong)    NSString*       mTitle;//	string	是			公告标题
@property (nonatomic,strong)    NSString*       mContent;//	string	是			公告内容
@property (nonatomic,strong)    NSString*       mReadTime;//	string	是			阅读时间
@property (nonatomic,strong)    NSString*       mCreateTime;//	string	是			发布时间
@property (nonatomic,strong)    NSString*       mUrl;//	string	是			详情链接

+(void)getArticlelist:(int)sellerid block:(void(^)(SResBase* resb,NSArray* all))block;

@end



@interface SRepair : SAutoEx


@property (nonatomic,assign)    int             mId;//	int	是			编号
@property (nonatomic,strong)    NSString*       mContent;//	string	是			内容
@property (nonatomic,strong)    NSString*       mRepairType;//	string	是			报修类型
@property (nonatomic,strong)    NSArray *       mImages;//	List	是			图片数组
@property (nonatomic,strong)    NSString*       mStatusStr;//	String	是			状态
@property (nonatomic,strong)    NSString*       mCreateTime;//	string	是			报修时间
@property (nonatomic,strong)    SAutoEx*        mPuser;//	Auth	是			业主对象
@property (nonatomic,strong)    SBuilding*      mBuild;//	Build	是			楼栋对象
@property (nonatomic,strong)    SDistrict*      mDistrict;//	District	是			小区编号
@property (nonatomic,strong)    SRoom*          mRoom;//	Room	是			楼栋号

//提交的时候需要
@property (nonatomic,assign)    int             mDistrictId;//	int	是			小区编号
@property (nonatomic,assign)    int             mTypeid;


-(void)submitRepair:(void(^)(SResBase* resb))block;

@end


@interface SRepairType : SAutoEx

@property (nonatomic,assign) int        mId;//	int	是			编号
@property (nonatomic,strong) NSString*  mName;//	string	是			名称
@property (nonatomic,assign) int        mSort;//	int	是			排序

+(void)getRepairTypes:(void(^)(SResBase* resb,NSArray* all))block;


@end


@interface SShareContent : NSObject

@property (nonatomic,strong) NSString   *mSurplusTime;

@property (nonatomic,assign) int        mStatus;

@property (nonatomic,strong) NSString   *mTitle;

@property (nonatomic,assign) float      mMoney;

@property (nonatomic,strong) NSString   *mUrl;

@property (nonatomic,strong) NSString   *mImgUrl;

@property (nonatomic,assign) int        mSort;

@property (nonatomic,strong) NSString   *mBtnName;

@property (nonatomic,assign) int      mEndTime;

@property (nonatomic,assign) int        mSendType;

@property (nonatomic,strong) NSString   *mName;

@property (nonatomic,assign) int        mType;

@property (nonatomic,assign) int        mId;

@property (nonatomic,strong) NSString   *mDetail;

@property (nonatomic,strong) NSString   *mBtnUrl;

@property (nonatomic,assign) int      mStartTime;

@property (nonatomic,assign) int      mCreateTime;

@property (nonatomic,strong) NSString   *mBgImg;

@property (nonatomic,assign) int      mSharePromotionNum;
 

-(id)initWithObj:(NSDictionary*)obj;

-(void)fetchIt:(NSDictionary*)obj;

@end



