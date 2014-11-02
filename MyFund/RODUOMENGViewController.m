//
//  RODUOMENGViewController.m
//  MyFund
//
//  Created by ben on 14/11/2.
//  Copyright (c) 2014年 benking. All rights reserved.
//

#import "RODUOMENGViewController.h"
#import "DMOfferWallManager.h"
#import "Toast+UIView.h"

@interface RODUOMENGViewController ()

@end

@implementation RODUOMENGViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _offerWallManager = [[DMOfferWallManager alloc] initWithPublisherID:@"96ZJ39xwzegKfwTA/L"];
    //96ZJ3sIAzeBqzwTBZP
    _offerWallManager.delegate = self;
    _offerWallManager.disableStoreKit=YES;
    
    self.viewTitle.layer.shadowColor = [UIColor grayColor].CGColor;
    self.viewTitle.layer.shadowOffset = CGSizeMake(0.2, 0.2);
    self.viewTitle.layer.shadowOpacity = 0.5;
    self.viewTitle.layer.shadowRadius = 1.0;
    
    self.btnCloseModal.layer.cornerRadius = 2;
    self.btnCloseModal.layer.borderWidth = 1;
    self.btnCloseModal.layer.borderColor = [UIColorFromRGB(0x3ec060) CGColor];
    self.btnCloseModal.layer.backgroundColor = [UIColorFromRGB(0x50d266) CGColor];
    
    self.btnGO.layer.cornerRadius = 2;
    self.btnGO.layer.borderWidth = 1;
    self.btnGO.layer.borderColor = [UIColorFromRGB(0x3ec060) CGColor];
    self.btnGO.layer.backgroundColor = [UIColorFromRGB(0x50d266) CGColor];
    
    self.view.backgroundColor = UIColorFromRGB(0xf1f0ee);
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    _offerWallManager.delegate = nil;
    _offerWallManager = nil;
}

- (IBAction)showListWall:(id)sender {
    [_offerWallManager presentOfferWallWithViewController:self type:eDMOfferWallTypeList];
}

- (IBAction)closeModal:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark - Manager Delegate

// 积分墙开始加载数据
- (void)dmOfferWallManagerDidStartLoad:(DMOfferWallManager *)manager
                         offerWallType:(DMOfferWallType)type {
    
    //[self.view makeToast:@"消费失败，余额不足！"];
    switch (type) {
            
        case eDMOfferWallTypeList:
            NSLog(@"<demo>ListWallDidStartLoad");
            break;
        case eDMOfferWallTypeVideo:
            NSLog(@"<demo>VideoWallDidStartLoad");
            break;
        case eDMOfferWallTypeInterstitial:
            NSLog(@"<demo>InterstitialWallDidStartLoad");
            break;
        default:
            break;
    }
}

// 积分墙加载完成。
- (void)dmOfferWallManagerDidFinishLoad:(DMOfferWallManager *)manager
                          offerWallType:(DMOfferWallType)type {
    
    switch (type) {
            
        case eDMOfferWallTypeList:
            NSLog(@"<demo>ListWallDidFinishLoad");
            break;
        case eDMOfferWallTypeVideo:
            NSLog(@"<demo>VideoWallDidFinishLoad");
            break;
        case eDMOfferWallTypeInterstitial:
            NSLog(@"<demo>InterstitialWallDidFinishLoad");
            break;
        default:
            break;
    }
}

// 积分墙加载失败。可能的原因由error部分提供，例如网络连接失败、被禁用等。
- (void)dmOfferWallManager:(DMOfferWallManager *)manager
       failedLoadWithError:(NSError *)error
             offerWallType:(DMOfferWallType)type {
    
    switch (type) {
            
        case eDMOfferWallTypeList:
            NSLog(@"<demo>ListWallFailedLoadWithError:%@",error);
            break;
        case eDMOfferWallTypeVideo:
            NSLog(@"<demo>VideoWallFailedLoadWithError:%@",error);
            break;
        case eDMOfferWallTypeInterstitial:
            NSLog(@"<demo>InterstitialWallFailedLoadWithError:%@",error);
            break;
        default:
            break;
    }
}

// 当积分墙要被呈现出来时，回调该方法
- (void)dmOfferWallManagerWillPresent:(DMOfferWallManager *)manager
                        offerWallType:(DMOfferWallType)type {
    
    switch (type) {
            
        case eDMOfferWallTypeList:
            NSLog(@"<demo>ListWallWillPresent");
            break;
        case eDMOfferWallTypeVideo:
            NSLog(@"<demo>VideoWallWillPresent");
            break;
        case eDMOfferWallTypeInterstitial:
            NSLog(@"<demo>InterstitialWallWillPresent");
            break;
        default:
            break;
    }
}

//  积分墙页面关闭。
- (void)dmOfferWallManagerDidClosed:(DMOfferWallManager *)manager
                      offerWallType:(DMOfferWallType)type {
    
    switch (type) {
            
        case eDMOfferWallTypeList:
            NSLog(@"<demo>ListWallDidClosed");
            break;
        case eDMOfferWallTypeVideo:
            NSLog(@"<demo>VideoWallDidClosed");
            break;
        case eDMOfferWallTypeInterstitial:
            NSLog(@"<demo>InterstitialWallDidClosed");
            break;
        default:
            break;
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
