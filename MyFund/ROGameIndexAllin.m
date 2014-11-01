//
//  ROGameIndexAllin.m
//  MyFund
//
//  Created by ben on 14/11/1.
//  Copyright (c) 2014年 benking. All rights reserved.
//

#import "ROGameIndexAllin.h"

@implementation ROGameIndexAllin

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (IBAction)coinChanged:(id)sender {
    [[NSUserDefaults standardUserDefaults] setFloat:[self.txtChipin.text floatValue] forKey:kSettingChipinCoin];
}

@end
