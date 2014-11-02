//
//  RODUOMENGViewController.h
//  MyFund
//
//  Created by ben on 14/11/2.
//  Copyright (c) 2014年 benking. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DMOfferWallManager.h"

@interface RODUOMENGViewController : UIViewController<DMOfferWallManagerDelegate>{
    DMOfferWallManager*_offerWallManager;
}
@property (weak, nonatomic) IBOutlet UIView *viewTitle;
@property (weak, nonatomic) IBOutlet UIButton *btnCloseModal;
@property (weak, nonatomic) IBOutlet UIButton *btnGO;

@end
