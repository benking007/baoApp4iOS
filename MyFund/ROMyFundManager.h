//
//  Copyright (c) 2014年 ben. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ROMyFund.h"
#import "ROFund.h"

@interface ROMyFundManager : NSObject<NSURLSessionDelegate,NSURLSessionTaskDelegate>{
    NSTimer *updateTimer;
}

@property(nonatomic,strong,readonly) NSMutableArray *myFunds;
@property(nonatomic,strong,readonly) NSMutableArray *funds;
@property(nonatomic,strong) NSString *currentFund;

+(ROMyFundManager*)sharedManager;
-(ROMyFund*)myfundByCode:(NSString*)n;
-(ROFund*)fundByCode:(NSString*)n;
-(void)initFunds;

@end
