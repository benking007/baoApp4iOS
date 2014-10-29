//
//  Copyright (c) 2014年 ben. All rights reserved.
//

#import "ROAppDelegate.h"
#import "ROMyFundManager.h"
#import "MobClick.h"
#import "ROConstants.h"
#import "ShareEngine.h"

@implementation ROAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[ShareEngine sharedInstance] registerApp];
    
    //初始化默认基金代码
    [[ROMyFundManager sharedManager] setCurrentFund:kFundCode_YUEBAO];
    [[ROMyFundManager sharedManager] initFunds];
    
    //友盟统计
    [MobClick startWithAppkey:UMENG_APPKEY reportPolicy:BATCH   channelId:@"baobaozs_ios"];
    [MobClick checkUpdate:@"有新版本更新哟，赶紧去下载吧！" cancelButtonTitle:@"下次吧" otherButtonTitles:@"去更新"];
    
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [MobClick setAppVersion:version];
    //[MobClick setLogEnabled:YES];
    
    //设置首次访问
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"everLaunched"]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"everLaunched"];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstLaunch"];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"newUser"];
    }
    else{
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"firstLaunch"];
        if(![[NSUserDefaults standardUserDefaults] boolForKey:@"newUser"]){
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"oldUser"];
        }
    }
    
    return YES;
}


- (NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
    return UIInterfaceOrientationMaskPortrait;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return [[ShareEngine sharedInstance] handleOpenURL:url];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return [[ShareEngine sharedInstance] handleOpenURL:url];
}

@end
