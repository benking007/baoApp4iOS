//
//  ROSetMyFundView.m
//  MyFund
//
//  Created by ben on 14-8-20.
//  Copyright (c) 2014年 benking. All rights reserved.
//

#import "ROSetMyFundView.h"

@implementation ROSetMyFundView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (IBAction)myQuotientEditingChanged:(id)sender {
    [[NSUserDefaults standardUserDefaults] setFloat:[self.txtMyQuotient.text floatValue] forKey:kSettingsQuotient];
}
- (IBAction)myIncomeEditingChanged:(id)sender {
    [[NSUserDefaults standardUserDefaults] setFloat:[self.txtMyIncome.text floatValue] forKey:kSettingsTotalIncome];
}

@end
