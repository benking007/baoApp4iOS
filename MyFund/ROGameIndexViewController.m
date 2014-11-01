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
    
    self.downPercentView.layer.cornerRadius = 9.0;
    self.downPercentView.layer.borderWidth = 2;
    self.downPercentView.layer.borderColor = [[UIColor whiteColor] CGColor];
    
    self.riseMoney.layer.cornerRadius = 10;
    self.riseMoney.layer.borderWidth = 1;
    self.riseMoney.layer.borderColor = [[UIColor whiteColor] CGColor];
    
    self.downMoney.layer.cornerRadius = 10;
    self.downMoney.layer.borderWidth = 1;
    self.downMoney.layer.borderColor = [[UIColor whiteColor] CGColor];
    
    self.riseIcon.layer.cornerRadius = 25;
    self.riseIcon.layer.borderWidth = 2;
    self.riseIcon.layer.borderColor = [[UIColor whiteColor] CGColor];
    
    self.downIcon.layer.cornerRadius = 25;
    self.downIcon.layer.borderWidth = 2;
    self.downIcon.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.downIcon.layer.shadowColor = [[UIColor blackColor] CGColor];
    
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
        chipInView.lblChipinDay.text = @"嘿嘿，我猜11月03日股市大涨";
        chipInView.lblChipinPercent.text = @"73%的人和你选择同样的趋势";
        chipInView.imgChipDirect.image = [UIImage imageNamed:@"icon"];
    } else {
        chipInView.lblChipinDay.text = @"嘿嘿，我猜11月03日股市下跌";
        chipInView.lblChipinPercent.text = @"27%的人和你选择同样的趋势";
        chipInView.imgChipDirect.image = [UIImage imageNamed:@"icon"];
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
