//
//  Copyright (c) 2014年 ben. All rights reserved.
//

#ifndef MyFundConstants_h

typedef enum
{
    weChat,
    weChatFriend
}WeiboType;

#define MyFundConstants_h

#define kNotification_DataLoaded @"kNotification_DataLoaded"
#define kFundList               @"fund";

#define kSettingsQuotient       @"kSettingsQuotient"
#define kSettingsTotalIncome    @"kSettingsTotalIncome"

#define kAPI_GETMYFUND          @"http://114.215.130.200/myfunds/getmyfund?v=1.0"
#define kAPI_SETMYFUND          @"http://114.215.130.200/myfunds/setmyfund?v=1.0"
#define kAPI_FUNDS              @"http://114.215.130.200/netvalues/getfunds?v=1.0"
#define kAppStore               @"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewSoftware?id=899179525";

#define kFundCode_YUEBAO        @"000198"

#define kTXT_DAILYINCOME        @"今日收益"
#define kTXT_SEVENDAYSINCOME    @"七日年化收益率"
#define kTXT_INCOMEPER10000     @"万份收益"
#define kTXT_TOTALINCOME        @"累计收益"
#define kTXT_TOTALMONEY         @"总金额"
#define kTXT_VALUEDATE          @"更新日期"

#define UMENG_APPKEY            @"53c4f53c56240b4487074397"

#define kWeChatAppId            @"wxe059836673e2aa81"
#define kWeChatAppKey           @"1afbc45a33b549c587695506fe9fdce0"

#define kShareText              @"好用的余额宝收益查询工具，数据更新快，妈妈再也不担心我不会理财了"
#define kShareTitle             @"爱宝宝，爱理财"
#define kShareAddress           @"http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewSoftware?id=899179525"

#define kCryptKey               @"AC2ACDAD&^32EABA14EB";
#define kAPI_GETMYFUNDPARAMS    @"deviceid=%@&fundcode=%@&timestamp=%@%@";
#define kAPI_SETMYFUNDPARAMS    @"deviceid=%@&fundcode=%@&quotient=%@&totalincome=%@&timestamp=%@%@";
#define kAPI_GETFUNDSPARAMS     @"timestamp=%@%@";


#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define kThemes_default @[UIColorFromRGB(0x07a4df),UIColorFromRGB(0x95a322),UIColorFromRGB(0xf9b345),UIColorFromRGB(0xff6049),UIColorFromRGB(0x67B87B),UIColorFromRGB(0x06baff)]
#endif



