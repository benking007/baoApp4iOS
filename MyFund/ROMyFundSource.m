//
//  ROMyFundSource.m
//  BitLive
//
//  Created by ben on 14-7-3.
//  Copyright (c) 2014年 iamro. All rights reserved.
//

#import "ROMyFundSource.h"
#import "ROMyFundManager.h"
#import <AFNetworking/AFNetworking.h>
#import "UIDevice+IdentifierAddition.h"

@implementation ROMyFundSource

-(id)initWithName:(NSString*)name{
    self = [super init];
    if (self) {
        self.sourceName = name;
        self.myfunds = [[NSMutableArray alloc] init];
    }
    return self;
}

-(void)loadMyFund:(NSString*)c{
    
    ROMyFund *myfund = [self getMyFundObject:c];
    if(!myfund){
        myfund = [[ROMyFund alloc] initWithSourceFundCode:c];
        [self.myfunds addObject:myfund];
    }
    
    NSString *url = kAPI_GETMYFUND; //[NSString stringWithFormat:kAPI_GETMYFUND, [[UIDevice currentDevice] uniqueGlobalDeviceIdentifier],c ];
    
    if(url){
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager GET:url parameters:nil
             success:^(AFHTTPRequestOperation *operation, id responseObject) {
                 myfund.originalData = responseObject[0];
        }
             failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                 //error
        }];
    }
}

-(void)loadMyFundsWithAll{
    [self loadMyFund:kFundCode_YUEBAO];
}

-(ROMyFund*)getMyFundObject:(NSString*)c{
    ROMyFund *myfund;
    for (ROMyFund *p in self.myfunds) {
        if([p.fundCode isEqualToString:c]){
            myfund = p;
        }
    }
    return myfund;
}

@end
