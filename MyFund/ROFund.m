//
//  ROFund.m
//  MyFund
//
//  Created by ben on 14-7-8.
//  Copyright (c) 2014年 benking. All rights reserved.
//

#import "ROFund.h"

@implementation ROFund

@synthesize originalData=_originalData;

-(void)loadInfos{
    self.fundCode =_originalData[@"fundcode"];
    self.name= _originalData[@"name"];
    self.fundName = _originalData[@"fundname"];
    self.netvalue = _originalData[@"netvalue"];
    self.totalnetvalue = _originalData[@"totalnetvalue"];
    self.nvdate = _originalData[@"nvdate"];
}

-(void)setOriginalData:(NSDictionary *)originalData{
    _originalData = originalData;
    [self loadInfos];
}

@end
