//
//  ROMyFundSource.h
//  BitLive
//
//  Created by ben on 14-7-3.
//  Copyright (c) 2014年 iamro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ROMyFund.h"

@interface ROMyFundSource : NSObject

@property(nonatomic,strong) NSString *sourceName;
@property(nonatomic,strong) NSMutableArray *myfunds;

-(id)initWithName:(NSString*)name;

-(void)loadMyFundsWithAll;
-(void)loadMyFund:(NSString*)c;
-(ROMyFund*)getMyFundObject:(NSString*)c;

@end
