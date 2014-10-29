//
//  Copyright (c) 2014年 ben. All rights reserved.
//

#import "ROMyFund.h"

@implementation ROMyFund

@synthesize originalData=_originalData;


-(id)initWithSourceFundCode:(NSString*)fundcode {
    self = [super init];
    if (self) {
        self.fundCode = fundcode;
    }
    return self;
}

-(void)loadInfos{
    self.dailyIncome = _originalData[@"dailyincome"];
    self.quotient = _originalData[@"quotient"];
    self.totalIncome = _originalData[@"totalincome"];
    self.deviceId = _originalData[@"deviceid"];
    self.netValue = _originalData[@"netvalues"][@"netvalue"];
    self.totalNetValue = _originalData[@"netvalues"][@"totalnetvalue"];
    self.nvDate = _originalData[@"netvalues"][@"nvdate"];
    self.name = _originalData[@"netvalues"][@"name"];
    self.fundName = _originalData[@"netvalues"][@"fundname"];
}

-(void)setOriginalData:(NSDictionary *)originalData{
    _originalData = originalData;
    [self loadInfos];
}

@end
