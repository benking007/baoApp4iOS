//
//  ROGameIndexViewController.h
//  MyFund
//
//  Created by ben on 14/11/1.
//  Copyright (c) 2014年 benking. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RNFrostedSidebar.h"

@interface ROGameIndexViewController : UIViewController<RNFrostedSidebarDelegate>
@property (weak, nonatomic) IBOutlet UIView *risePercentView;
@property (weak, nonatomic) IBOutlet UIView *downPercentView;
@property (weak, nonatomic) IBOutlet UIView *riseMoney;
@property (weak, nonatomic) IBOutlet UIView *downMoney;
@property (weak, nonatomic) IBOutlet UIWebView *indexTrend;
@property (nonatomic, strong) NSMutableIndexSet *optionIndices;
@property (nonatomic, strong) RNFrostedSidebar *ruleSider;
@property (nonatomic, strong) RNFrostedSidebar *chipinSider;
@property (nonatomic) BOOL chipinDirect;

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIButton *btnCloseModal;
@property (weak, nonatomic) IBOutlet UIView *viewTitle;
@property (weak, nonatomic) IBOutlet UIView *viewBottom;
@property (weak, nonatomic) IBOutlet UIButton *btnEarnCoin;
@property (weak, nonatomic) IBOutlet UIButton *btnMyEarn;
@property (weak, nonatomic) IBOutlet UIButton *btnExchangeCoin;
@property (weak, nonatomic) IBOutlet UIButton *btnRules;

@end
