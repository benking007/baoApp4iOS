//
//  Copyright (c) 2014年 ben. All rights reserved.
//

#import "ROMyFundManager.h"
#import "ROMyFund.h"
#import "AFNetworking.h"
#import "ROFund.h"
#import "NSString+MD5Addition.h"

@implementation ROMyFundManager

@synthesize myFunds = _myFunds;
@synthesize currentFund = _currentFund;
@synthesize funds = _funds;

static ROMyFundManager *sharedSingleton;
static NSString * UUID = nil;

+(ROMyFundManager*)sharedManager{
    static BOOL initialized = NO;
    if(!initialized)
    {
        initialized = YES;
        sharedSingleton = [[ROMyFundManager alloc] init];
        
    }
    return sharedSingleton;
}

-(id)init{
    self = [super init];
    if(self){
        _myFunds = [[NSMutableArray alloc] init];
        _funds = [[NSMutableArray alloc] init];
        _currentFund = kFundCode_YUEBAO;
        ROMyFund *myfund = [[ROMyFund alloc] initWithSourceFundCode:_currentFund];
        [_myFunds addObject:myfund];
    }
    return self;
}

-(void)setcurrentFund:(NSString *)currentFund{
    _currentFund = currentFund;
}

-(ROMyFund*)myfundByCode:(NSString*)n{
    ROMyFund *source;
    for (ROMyFund *s in self.myFunds) {
        if([s.fundCode isEqualToString:n]){
            source = s;
        }
    }
    return source;
}

-(ROFund*) fundByCode:(NSString*)n{
    ROFund *fund;
    for (ROFund *s in self.funds) {
        if([s.fundCode isEqualToString:n]){
            fund = s;
        }
    }
    return fund;
}

-(void)initFunds{
    NSString *url = kAPI_FUNDS;
    NSString *paramUrl = kAPI_GETFUNDSPARAMS;
    NSString *cryptKey = kCryptKey;
    NSString *timeStmap = [@"TS" addinTimeStampRandomNumber];
    
    NSString *params = [NSString stringWithFormat:paramUrl, timeStmap, cryptKey];
    NSString *signKey = [[params stringFromMD5] uppercaseString];
    
    NSDictionary *parameters = @{@"timestamp":timeStmap,@"signkey":signKey};
    
    if(url){
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager POST:url parameters:parameters
             success:^(AFHTTPRequestOperation *operation, id responseObject) {
                 _funds = [[NSMutableArray alloc] init];
                 for(NSDictionary *obj in responseObject){
                     ROFund *fund = [[ROFund alloc] init];
                     fund.originalData = obj;
                     [_funds addObject:fund];
                 }
             }
             failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                 NSLog(@"error");
             }];
    }
    
}

@end
