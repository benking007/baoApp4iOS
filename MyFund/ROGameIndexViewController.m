//
//  ROGameIndexViewController.m
//  MyFund
//
//  Created by ben on 14/11/1.
//  Copyright (c) 2014年 benking. All rights reserved.
//

#import "ROGameIndexViewController.h"
#import "ROGameRuleView.h"
#import "ROGameIndexAllin.h"

@interface ROGameIndexViewController ()

@end

@implementation ROGameIndexViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    
    self.risePercentView.layer.cornerRadius = 9.0;
    self.risePercentView.layer.borderWidth = 2;
    self.risePercentView.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.risePercentView.layer.backgroundColor = [UIColorFromRGB(0xde1a17) CGColor];
    
    self.downPercentView.layer.cornerRadius = 9.0;
    self.downPercentView.layer.borderWidth = 2;
    self.downPercentView.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.downPercentView.layer.backgroundColor = [UIColorFromRGB(0x81c223) CGColor];
    
    self.btnRules.layer.cornerRadius = 15;
    self.btnRules.layer.backgroundColor = [UIColorFromRGB(0x0074cd) CGColor];
    
    self.viewTitle.layer.backgroundColor = [UIColorFromRGB(0x54a2de) CGColor];
    self.viewTitle.layer.shadowColor = [UIColor grayColor].CGColor;
    self.viewTitle.layer.shadowOffset = CGSizeMake(0.2, 0.2);
    self.viewTitle.layer.shadowOpacity = 0.5;
    self.viewTitle.layer.shadowRadius = 1.0;
    
    self.viewBottom.layer.backgroundColor = [UIColorFromRGB(0x54a2de) CGColor];
    self.viewBottom.layer.shadowColor = [UIColor grayColor].CGColor;
    self.viewBottom.layer.shadowOffset = CGSizeMake(0.2, 0.2);
    self.viewBottom.layer.shadowOpacity = 0.5;
    self.viewBottom.layer.shadowRadius = 1.0;
    
    self.btnEarnCoin.layer.cornerRadius = 15;
    [self.btnEarnCoin setTitleColor:UIColorFromRGB(0x7e5531) forState:UIControlStateNormal];
    self.btnEarnCoin.layer.backgroundColor = [UIColorFromRGB(0xffd800) CGColor];
    
    self.btnExchangeCoin.layer.cornerRadius = 15;
    [self.btnExchangeCoin setTitleColor:UIColorFromRGB(0x7e5531) forState:UIControlStateNormal];
    self.btnExchangeCoin.layer.backgroundColor = [UIColorFromRGB(0xffd800) CGColor];
    
    self.btnMyEarn.layer.cornerRadius = 15;
    self.btnMyEarn.layer.backgroundColor = [UIColorFromRGB(0x0074cd) CGColor];
    
    self.view.backgroundColor = UIColorFromRGB(0x3e96d8);
    
    self.scrollView.scrollEnabled = YES;
    self.scrollView.contentSize = CGSizeMake(320, 568);
    self.indexTrend.scrollView.scrollEnabled = NO;
    
    NSURL *url =[NSURL URLWithString:@"http://image.sinajs.cn/newchart/hollow/small/nsh000300.gif"];
    NSURLRequest *request =[NSURLRequest requestWithURL:url];
    [self.indexTrend loadRequest:request];
}

- (IBAction)closeThisModalView:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)showRuleView:(id)sender {
    NSArray *nibViews=[[NSBundle mainBundle] loadNibNamed:@"ROGameRuleView" owner:self options:nil];
    ROGameRuleView *ruleView = [nibViews objectAtIndex:0];
    
    NSMutableArray *itemView = [[NSMutableArray alloc] init];
    [itemView addObject:ruleView];
    
    NSURL *url =[NSURL URLWithString:@"http://image.sinajs.cn/newchart/hollow/small/nsh000300.gif"];
    NSURLRequest *request =[NSURLRequest requestWithURL:url];
    [ruleView.webGameRulePage loadRequest:request];
    
    [ruleView.btnCloseRule addTarget:self action:@selector(closeRuleView:) forControlEvents:UIControlEventTouchUpInside];
    
    _ruleSider = [[RNFrostedSidebar alloc] initWithCustomViews:itemView selectedIndices:self.optionIndices];
    
    _ruleSider.delegate = self;
    _ruleSider.height = 450;
    _ruleSider.showFromTop = TRUE;
    _ruleSider.backgroundColorAlpha = 1;
    _ruleSider.leftPadding = 0;
    _ruleSider.topPadding = 0;
    _ruleSider.backgroundColorAlpha = 1;
    _ruleSider.majorBackgroundColor = UIColorFromRGB(0x1d1d1d);
    _ruleSider.majorBackgroundColorAlpha = 1;
    
    [_ruleSider show];
}

-(void)closeRuleView:(id)sender{
    if(_ruleSider){
        [_ruleSider dismiss];
    }
}

- (IBAction)showChipinRiseView:(id)sender {
    [self showChipinView:YES];
}

- (IBAction)showChipinDownView:(id)sender {
    [self showChipinView:NO];
}

-(void)showChipinView:(BOOL) direct{
    NSArray *nibViews=[[NSBundle mainBundle] loadNibNamed:@"ROGameIndexAllin" owner:self options:nil];
    ROGameIndexAllin *chipInView = [nibViews objectAtIndex:0];
    
    NSMutableArray *itemView = [[NSMutableArray alloc] init];
    [itemView addObject:chipInView];
    
    chipInView.txtChipin.layer.cornerRadius = 25;
    chipInView.btnChipin.layer.cornerRadius = 22;
    
    [chipInView.btnClose addTarget:self action:@selector(closeChipinView:) forControlEvents:UIControlEventTouchUpInside];
    
    [chipInView.btnChipin addTarget:self action:@selector(doChipin:) forControlEvents:UIControlEventTouchUpInside];
    
    [chipInView.btnChipinOK addTarget:self action:@selector(doChipin:) forControlEvents:UIControlEventTouchUpInside];
    
    _chipinDirect = direct;
    
    if(direct){
        chipInView.lblChipinDay.text = @"嘿嘿，我猜11月03日沪深300大涨";
        chipInView.lblChipinDay.textColor = UIColorFromRGB(0xde1a17);
        chipInView.lblChipinPercent.text = @"73%的人和你选择同样的趋势";
        chipInView.imgChipDirect.image = [UIImage imageNamed:@"guessrise.png"];
    } else {
        chipInView.lblChipinDay.text = @"我看11月03日沪深300凶多吉少";
        chipInView.lblChipinDay.textColor = UIColorFromRGB(0x81c223);
        chipInView.lblChipinPercent.text = @"27%的人和你选择同样的趋势";
        chipInView.imgChipDirect.image = [UIImage imageNamed:@"guessdown.png"];
    }
    
    chipInView.lblMyCoin.text = @"56787";
    
    _chipinSider = [[RNFrostedSidebar alloc] initWithCustomViews:itemView selectedIndices:self.optionIndices];
    
    _chipinSider.delegate = self;
    _chipinSider.height = 383;
    _chipinSider.showFromTop = TRUE;
    _chipinSider.backgroundColorAlpha = 1;
    _chipinSider.leftPadding = 0;
    _chipinSider.topPadding = 0;
    _chipinSider.backgroundColorAlpha = 1;
    _chipinSider.majorBackgroundColor = UIColorFromRGB(0x1d1d1d);
    _chipinSider.majorBackgroundColorAlpha = 0.95;
    
    [_chipinSider show];
}

-(void)closeChipinView:(id)sender{
    if(_chipinSider){
        [_chipinSider dismiss];
    }
}

-(void)doChipin:(id)sender{
    NSString *chipinCoin = [NSString stringWithFormat:@"%f",[[NSUserDefaults standardUserDefaults]  floatForKey:kSettingChipinCoin]];
    
    if(_chipinSider){
        [_chipinSider dismiss];
    }
}

@end
