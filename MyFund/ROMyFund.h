//
//  Copyright (c) 2014年 ben. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ROMyFund : NSObject

@property(nonatomic,strong) NSString *deviceId;
@property(nonatomic,strong) NSString *fundCode;
@property(nonatomic,strong) NSString *quotient;
@property(nonatomic,strong) NSString *dailyIncome;
@property(nonatomic,strong) NSString *totalIncome;
@property(nonatomic,strong) NSString *netValue;
@property(nonatomic,strong) NSString *totalNetValue;
@property(nonatomic, strong) NSString *nvDate;
@property(nonatomic,strong) NSString *name;
@property(nonatomic,strong) NSString *fundName;
@property(nonatomic,strong) NSDictionary *originalData;

-(id)initWithSourceFundCode:(NSString*)fundcode;

@end
