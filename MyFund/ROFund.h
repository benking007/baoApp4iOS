//
//  ROFund.h
//  MyFund
//
//  Created by ben on 14-7-8.
//  Copyright (c) 2014年 benking. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ROFund : NSObject

@property(nonatomic,strong) NSString *fundCode;
@property(nonatomic,strong) NSString *name;
@property(nonatomic,strong) NSString *fundName;
@property(nonatomic,strong) NSString *netvalue;
@property(nonatomic,strong) NSString *totalnetvalue;
@property(nonatomic,strong) NSString *nvdate;
@property(nonatomic,strong) NSDictionary *originalData;

@end
