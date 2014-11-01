//
//  Copyright (c) 2014年 ben. All rights reserved.
//

#import "ROMyFundViewController.h"
#import "ROFundTablePriceCell.h"
#import "ROSetFundControlCell.h"
#import "ROMyFundManager.h"
#import "AFNetworking.h"
#import "UIDevice+IdentifierAddition.h"
#import "ROFund.h"
#import "ROSiderView.h"
#import "ROSettingView.h"
#import "MobClick.h"
#import "ROGuideView.h"
#import "ROShareView.h"
#import "NSString+MD5Addition.h"
#import "ROMyFundTitleView.h"
#import "ROSetMyFundView.h"

@interface ROMyFundViewController ()

@end

@implementation ROMyFundViewController

#pragma interface stuff

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //初始化刷新控件
    UIRefreshControl *rc = [[UIRefreshControl alloc] init];
    [rc addTarget:self action:@selector(refreshTableView) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = rc;
    [self.tableView addSubview:self.refreshControl];

    //第一次加载数据
    [self loadData];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateAll) name:kNotification_DataLoaded object:nil];
    
    UISwipeGestureRecognizer *allFundShow = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(btnShowAllFund:)];
    
    [allFundShow setDirection:(UISwipeGestureRecognizerDirectionRight)];
    [[self view] addGestureRecognizer:allFundShow];
    
    UISwipeGestureRecognizer *showHelp = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(showHelp:)];
    
    [showHelp setDirection:(UISwipeGestureRecognizerDirectionLeft)];
    [[self view] addGestureRecognizer:showHelp];
    
    self.optionIndices = [NSMutableIndexSet indexSetWithIndex:1];
    
    [self updateAll];
    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateAll) userInfo:nil repeats:NO];
}



-(void)updateAll{
    [[self tableView] reloadData];
}

- (void) loadData{
    NSString *code = [ROMyFundManager sharedManager].currentFund;
    ROMyFund *myfund = [[ROMyFundManager sharedManager] myfundByCode:code];
    if(!myfund){
        myfund = [[ROMyFund alloc] initWithSourceFundCode:code];
        [[[ROMyFundManager sharedManager] myFunds] addObject:myfund];
    }
    
    [[ROMyFundManager sharedManager] initFunds];
    
    NSString *url = kAPI_GETMYFUND;
    NSString *paramUrl = kAPI_GETMYFUNDPARAMS;
    NSString *cryptKey = kCryptKey;
    NSString *uid = [[UIDevice currentDevice] uniqueDeviceIdentifier];
    NSString *timeStmap = [@"TS" addinTimeStampRandomNumber];
    
    NSString *params = [NSString stringWithFormat:paramUrl, uid, code, timeStmap, cryptKey];
    NSString *signKey = [[params stringFromMD5] uppercaseString];
    
    NSDictionary *parameters = @{@"deviceid":uid,@"fundcode":code,@"timestamp":timeStmap,@"signkey":signKey};
    
    if(url){
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager POST:url parameters:parameters
             success:^(AFHTTPRequestOperation *operation, id responseObject) {
                 myfund.originalData = responseObject[0];
                 [self.refreshControl endRefreshing];
                 [self updateAll];
             }
             failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                 //error
                 [self.refreshControl endRefreshing];
             }];
    }
}

-(void) setData:(NSString *)quotient totalincome:(NSString *)totalincome{
    NSString *code = [ROMyFundManager sharedManager].currentFund;
    ROMyFund *myfund = [[ROMyFundManager sharedManager] myfundByCode:code];
    if(!myfund){
        myfund = [[ROMyFund alloc] initWithSourceFundCode:code];
        [[[ROMyFundManager sharedManager] myFunds] addObject:myfund];
    }
    
    if([quotient floatValue] != [myfund.quotient floatValue]
       || [totalincome floatValue] != [myfund.totalIncome floatValue])
    {
        
        NSString *url = kAPI_SETMYFUND;
        NSString *paramUrl = kAPI_SETMYFUNDPARAMS;
        NSString *cryptKey = kCryptKey;
        NSString *uid = [[UIDevice currentDevice] uniqueDeviceIdentifier];
        NSString *timeStmap = [@"TS" addinTimeStampRandomNumber];
        
        NSString *params = [NSString stringWithFormat:paramUrl, uid, code, quotient, totalincome, timeStmap, cryptKey];
        NSString *signKey = [[params stringFromMD5] uppercaseString];
        
        NSDictionary *parameters = @{@"deviceid":uid,@"fundcode":code,@"quotient":quotient,@"totalincome":totalincome,@"timestamp":timeStmap,@"signkey":signKey};
        
        if(url){
            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
            [manager POST:url parameters:parameters
                 success:^(AFHTTPRequestOperation *operation, id responseObject) {
                 myfund.originalData = responseObject[0];
                 [self updateAll];
                 }
                 failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                     //error
                     [self.refreshControl endRefreshing];
                 }];
        }
    }
}

-(void) refreshTableView
{
    if (self.refreshControl.refreshing) {
        [self performSelector:@selector(loadData)];
    }
}

#pragma table view

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    NSArray *nibViews=[[NSBundle mainBundle] loadNibNamed:@"ROMyFundTitleView" owner:self options:nil];
    ROMyFundTitleView *titleView = [nibViews objectAtIndex:0];
    ROMyFund *p = [[ROMyFundManager sharedManager] myfundByCode:[ROMyFundManager sharedManager].currentFund];
    ROFund *fund = [[ROMyFundManager sharedManager] fundByCode:p.fundCode];
    titleView.lblMyFundTitle.text = fund.name;
    [titleView.btnShowAllFund addTarget:self action:@selector(btnShowAllFund:) forControlEvents:UIControlEventTouchUpInside];
    [titleView.btnShowHelp addTarget:self action:@selector(showSetMyFund:) forControlEvents:UIControlEventTouchUpInside];
    return titleView;
}

-(CGFloat )tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section == 0){
        return 44;
    }
    return 0;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    ROMyFund *p = [[ROMyFundManager sharedManager] myfundByCode:[ROMyFundManager sharedManager].currentFund];
    if([p.quotient floatValue] > 0){
        return 7;
    }
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    ROMyFund *p = [[ROMyFundManager sharedManager] myfundByCode:[ROMyFundManager sharedManager].currentFund];
    bool hasQuotient = [p.quotient floatValue] > 0;
    float setSection = hasQuotient ? 6 : 3;
    
    if(indexPath.row == setSection){
        return 160;
    }
    
    return 124;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *mCell;
    
    ROMyFund *p = [[ROMyFundManager sharedManager] myfundByCode:[ROMyFundManager sharedManager].currentFund];
    bool hasQuotient = [p.quotient floatValue] > 0;
    float setSection = hasQuotient ? 6 : 3;
    
    if(indexPath.row == setSection){
        ROSetFundControlCell *cell = [tableView dequeueReusableCellWithIdentifier:@"alert_cell" forIndexPath:indexPath];
        
        cell.btnSetMyFund.backgroundColor = kThemes_default[0];
        [cell.btnSetMyFund addTarget:self action:@selector(showSetMyFund:) forControlEvents:UIControlEventTouchUpInside];
        
        mCell = cell;
    }else{
        ROFundTablePriceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"price_cell" forIndexPath:indexPath];
        if (cell) {
            
            cell.backgroundColor = kThemes_default[indexPath.row];
            cell.currencyLabel.hidden = true;
            if(hasQuotient){
                switch(indexPath.row){
                    case 0:
                        cell.sourceNameLabel.text = kTXT_DAILYINCOME;
                        cell.currencyLabel.text = [p.nvDate substringWithRange:NSMakeRange(5,5)];
                        cell.currencyLabel.hidden = false;
                        float value = [p.dailyIncome floatValue];
                        cell.priceLabel.text = [NSString stringWithFormat:@"%.2f",value];
                        break;
                    case 1:
                        cell.sourceNameLabel.text = kTXT_TOTALMONEY;
                        value = [p.quotient floatValue];
                        cell.priceLabel.text = [NSString stringWithFormat:@"%.2f",value];
                        
                        break;
                    case 2:
                        cell.sourceNameLabel.text = kTXT_TOTALINCOME;
                        value = [p.totalIncome floatValue];
                        cell.priceLabel.text = [NSString stringWithFormat:@"%.2f",value];
                        break;
                    case 3:
                        cell.sourceNameLabel.text = kTXT_SEVENDAYSINCOME;
                        value = [p.totalNetValue floatValue];
                        cell.priceLabel.text = [NSString stringWithFormat:@"%.2f%%",value];
                        break;
                    case 4:
                        cell.sourceNameLabel.text = kTXT_INCOMEPER10000;
                        value = [p.netValue floatValue];
                        cell.priceLabel.text = [NSString stringWithFormat:@"%.4f",value];
                        break;
                    case 5:
                        cell.sourceNameLabel.text = kTXT_VALUEDATE;
                        cell.priceLabel.text = p.nvDate;
                        break;
                    default:
                        break;
                }
            } else {
                switch(indexPath.row){
                    case 0:
                        cell.sourceNameLabel.text = kTXT_SEVENDAYSINCOME;
                        float value = [p.totalNetValue floatValue];
                        cell.priceLabel.text = [NSString stringWithFormat:@"%.2f%%",value];
                        
                        break;
                    case 1:
                        cell.sourceNameLabel.text = kTXT_INCOMEPER10000;
                        value = [p.netValue floatValue];
                        cell.priceLabel.text = [NSString stringWithFormat:@"%.4f",value];
                        break;
                    case 2:
                        cell.sourceNameLabel.text = kTXT_VALUEDATE;
                        cell.priceLabel.text = p.nvDate;
                        break;
                    default:
                        break;
                }
            }
            
        }
        mCell = cell;
    }
    return mCell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //nothing
}

-(void)showSetMyFund:(id)sender{
    NSArray *nibViews=[[NSBundle mainBundle] loadNibNamed:@"ROSetMyFundView" owner:self options:nil];
    ROSetMyFundView *setMyFund = [nibViews objectAtIndex:0];
    [setMyFund.txtMyQuotient becomeFirstResponder];
    
    ROMyFund *p = [[ROMyFundManager sharedManager] myfundByCode:[ROMyFundManager sharedManager].currentFund];
    float quotientValue = [p.quotient floatValue];
    if(quotientValue){
        setMyFund.txtMyQuotient.text = [NSString stringWithFormat:@"%.2f",quotientValue];
        [[NSUserDefaults standardUserDefaults] setFloat:quotientValue forKey:kSettingsQuotient];
    } else {
        [[NSUserDefaults standardUserDefaults] setFloat:0 forKey:kSettingsQuotient];
    }
    
    float incomeValue = [p.totalIncome floatValue];
    if(incomeValue){
        setMyFund.txtMyIncome.text = [NSString stringWithFormat:@"%.2f",incomeValue];
        [[NSUserDefaults standardUserDefaults] setFloat:incomeValue forKey:kSettingsTotalIncome];
    } else {
        [[NSUserDefaults standardUserDefaults] setFloat:0 forKey:kSettingsTotalIncome];
    }
    
    [setMyFund.btnOK addTarget:self action:@selector(setMyFund:) forControlEvents:UIControlEventTouchUpInside];
    [setMyFund.btnCancel addTarget:self action:@selector(cancelSetMyFund:) forControlEvents:UIControlEventTouchUpInside];
    
    NSMutableArray *itemView = [[NSMutableArray alloc] init];
    [itemView addObject:setMyFund];
    
    _setMyFundSider = [[RNFrostedSidebar alloc] initWithCustomViews:itemView selectedIndices:self.optionIndices];
    _setMyFundSider.tagName = kFundList;
    _setMyFundSider.delegate = self;
    _setMyFundSider.height = 172;
    _setMyFundSider.showFromTop = TRUE;
    _setMyFundSider.backgroundColorAlpha = 1;
    _setMyFundSider.leftPadding = 0;
    _setMyFundSider.topPadding = 0;
    _setMyFundSider.backgroundColorAlpha = 1;
    _setMyFundSider.majorBackgroundColor = UIColorFromRGB(0x1d1d1d);
    _setMyFundSider.majorBackgroundColorAlpha = 0.97;
    
    [_setMyFundSider show];
}

-(void)setMyFund:(id)sender{
    NSString *quotient = [NSString stringWithFormat:@"%f",[[NSUserDefaults standardUserDefaults]  floatForKey:kSettingsQuotient]];
    NSString *totalincome = [NSString stringWithFormat:@"%f",[[NSUserDefaults standardUserDefaults]  floatForKey:kSettingsTotalIncome]];
    
    if([totalincome isEqualToString:@""] == TRUE){
        totalincome = @"-1975";
    }
    
    [self setData:quotient totalincome:totalincome];
    if(_setMyFundSider){
        [_setMyFundSider dismiss];
    }
}

-(void)cancelSetMyFund:(id)sender{
    if(_setMyFundSider){
        [_setMyFundSider dismiss];
    }
}

-(void)btnShowAllFund:(id)sender {
    NSMutableArray *itemView = [[NSMutableArray alloc] init];    
    NSString * currFund = [ROMyFundManager sharedManager].currentFund;
    for(ROFund *fund in [ROMyFundManager sharedManager].funds){
        NSArray *nibViews=[[NSBundle mainBundle] loadNibNamed:@"ROSiderView" owner:self options:nil];
        ROSiderView *sider = [nibViews objectAtIndex:0];
        sider.lblFundName.text = fund.fundName;
        sider.lblName.text = fund.name;
        float sevenDay = [fund.totalnetvalue floatValue];
        
        NSDate *today = [NSDate date];
        NSDateFormatter *dateformatter=[[NSDateFormatter alloc] init];
        [dateformatter setDateFormat:@"YYYY-MM-dd"];
        NSString *strToday = [dateformatter stringFromDate:today];
        if([strToday isEqualToString:fund.nvdate] == YES){
            sider.imgNew.hidden = FALSE;
        }
        
        sider.lblSevenDayPercent.text = [NSString stringWithFormat:@"%.2f%%",sevenDay];
        
        if([currFund isEqualToString:fund.fundCode]){
            sider.backgroundColor = UIColorFromRGB(0xff6049);
        } else {
            sider.backgroundColor = UIColorFromRGB(0x3e577f);
        }
        [itemView addObject:sider];
    }
    
    RNFrostedSidebar *callout = [[RNFrostedSidebar alloc] initWithCustomViews:itemView selectedIndices:self.optionIndices];
    callout.tagName = kFundList;
    callout.delegate = self;
    callout.width = 200;
    callout.backgroundColorAlpha = 1;
    callout.majorViewAnimation = FALSE;

    [callout show];
}

-(void)showHelp:(id)sender{
    NSMutableArray *itemView = [[NSMutableArray alloc] init];
    NSArray *nibViews = [[NSBundle mainBundle] loadNibNamed:@"ROSettingView" owner:self options:nil];
    ROSettingView *settingView = [nibViews objectAtIndex:0];
    [settingView.btnHelp addTarget:self action:@selector(showGuide:) forControlEvents:UIControlEventTouchUpInside];
    [settingView.btnStar addTarget:self action:@selector(showGuide:) forControlEvents:UIControlEventTouchUpInside];
    [settingView.btnAbout addTarget:self action:@selector(showGuide:) forControlEvents:UIControlEventTouchUpInside];
    [settingView.btnShare addTarget:self action:@selector(showGuide:) forControlEvents:UIControlEventTouchUpInside];
    [itemView addObject:settingView];
    
    _settingSider = [[RNFrostedSidebar alloc] initWithCustomViews:itemView selectedIndices:self.optionIndices borderColors:nil alwaysVertical:NO];
    _settingSider.showFromRight = TRUE;
    _settingSider.leftPadding = 0;
    _settingSider.topPadding = 0;
    _settingSider.delegate = self;
    _settingSider.siderBackgroundColor = UIColorFromRGB(0x212536);
    _settingSider.backgroundColorAlpha = 0.95;
    _settingSider.width = 120;
    _settingSider.majorViewAnimation = FALSE;
    
    [_settingSider show];
}

-(void)showGuide:(id)sender {
    NSInteger tagid = [sender tag];
    if(tagid == 99){
        NSString *url = kAppStore;
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
    }else{
        
        [self dismissGuide];
        
        NSMutableArray *itemView = [[NSMutableArray alloc] init];
        NSArray *nibViews = [[NSBundle mainBundle] loadNibNamed:@"ROSettingView" owner:self options:nil];
        
        if(tagid == 2){
            ROShareView *shareView = [nibViews objectAtIndex:tagid];
            [shareView.btnShareWChat addTarget:self action:@selector(shareToWXChat:) forControlEvents:UIControlEventTouchUpInside];
            [shareView.btnShareWFriend addTarget:self action:@selector(shareToWXFriend:) forControlEvents:UIControlEventTouchUpInside];
            [itemView addObject:shareView];
        }else{
            ROGuideView *guideView = [nibViews objectAtIndex:tagid];
            [itemView addObject:guideView];
        }
    
        _guideSider = [[RNFrostedSidebar alloc] initWithCustomViews:itemView selectedIndices:self.optionIndices];
        _guideSider.leftPadding = 0;
        _guideSider.topPadding = 0;
        _guideSider.delegate = self;
        _guideSider.siderBackgroundColor = UIColorFromRGB(0xffffff);
        _guideSider.backgroundColorAlpha = 1;
        _guideSider.width = 200;
        [_guideSider show];
    }
}

-(void)shareToWXChat:(id)sender {
    NSString *url = kShareAddress;
    [[ShareEngine sharedInstance] sendWeChatMessage:kShareText WithUrl:url WithType:weChat];
}

-(void)shareToWXFriend:(id)sender {
    NSString *url = kShareAddress;
    [[ShareEngine sharedInstance] sendWeChatMessage:kShareText WithUrl:url WithType:weChatFriend];
}

-(void) dismissGuide{
    if(_guideSider){
        [_guideSider dismissAnimated:FALSE];
    }
}

#pragma momery manage

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - RNFrostedSidebarDelegate

- (void)sidebar:(RNFrostedSidebar *)sidebar didTapItemAtIndex:(NSUInteger)index {
    NSString *tag = kFundList;
    if([sidebar.tagName isEqualToString:tag]){
        ROFund *fund = [[ROMyFundManager sharedManager].funds objectAtIndex:index];
        [ROMyFundManager sharedManager].currentFund = fund.fundCode;
        [self loadData];
        [sidebar dismiss];
    }
}

- (void)sidebar:(RNFrostedSidebar *)sidebar didEnable:(BOOL)itemEnabled itemAtIndex:(NSUInteger)index {
    if (itemEnabled) {
        [self.optionIndices addIndex:index];
    }
    else {
        [self.optionIndices removeIndex:index];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [ShareEngine sharedInstance].delegate = self;
    [MobClick beginLogPageView:@"PageOne"];
    [super viewWillAppear:animated];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [ShareEngine sharedInstance].delegate = nil;
    [MobClick endLogPageView:@"PageOne"];
    [super viewWillDisappear:animated];
}

-(void)dealloc{
    
}

#pragma mark - shareEngineDelegate
- (void)shareEngineDidLogIn:(WeiboType)weibotype
{
    [self loadView];
}

- (void)shareEngineDidLogOut:(WeiboType)weibotype
{
    [self loadView];
}

- (void)shareEngineSendSuccess
{
    //UIAlertView *shareAlert = [[UIAlertView alloc] initWithTitle:@"发送成功" message:@"内容成功发送到微博！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    //[shareAlert show];
}

- (void)shareEngineSendFail:(NSError *)error
{
    
    //NSString *failDescription = @"请重试！";
    //if (20019 == error.code)
   // {
    //    failDescription = @"重复发送了相同的内容！";
    //}
    //UIAlertView *shareAlert = [[UIAlertView alloc] initWithTitle:@"发送失败" message:failDescription delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
   // [shareAlert show];
}

- (IBAction)showGameIndex1:(id)sender {
    [self performSegueWithIdentifier:@"game_index" sender:self];
}

@end
