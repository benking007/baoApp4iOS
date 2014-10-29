//
//  Copyright (c) 2014年 ben. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RNFrostedSidebar.h"
#import "ShareEngine.h"

@interface ROMyFundViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,RNFrostedSidebarDelegate,ShareEngineDelegate,UIActionSheetDelegate>{
    UITextField *latestResponder;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) UIRefreshControl* refreshControl;
@property (nonatomic, strong) NSMutableIndexSet *optionIndices;
@property (nonatomic, strong) RNFrostedSidebar *guideSider;
@property (nonatomic, strong) RNFrostedSidebar *settingSider;
@property (nonatomic, strong) RNFrostedSidebar *setMyFundSider;

-(void)updateAll;

@end
