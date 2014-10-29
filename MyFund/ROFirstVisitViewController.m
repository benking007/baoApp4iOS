//
//  ROFirstVisitViewController.m
//  MyFund
//
//  Created by ben on 14-8-7.
//  Copyright (c) 2014年 benking. All rights reserved.
//

#import "ROFirstVisitViewController.h"
#import "ROMyFundViewController.h"

@interface ROFirstVisitViewController ()

@end

@implementation ROFirstVisitViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self checkFirstVisit];
    [self createPages:3];
    
}

-(void)checkFirstVisit{
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"firstLaunch"]) {
        [self showMyFund];
    }
}

-(void)showMyFund{
    [self performSegueWithIdentifier:@"switchToMyFund" sender:self];
}

- (void)createPages:(NSInteger)pages {
    for (int i = 0; i < pages; i++) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.scrollView.bounds) * i, 0, CGRectGetWidth(self.scrollView.bounds), CGRectGetHeight(self.scrollView.bounds))];
        view.backgroundColor = [UIColor grayColor];
        NSString *imageFile = [NSString stringWithFormat:@"preview_%d.png", i+1];
        UIImage *image = [UIImage imageNamed:imageFile];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        imageView.frame = CGRectMake(0, 0, CGRectGetWidth(self.scrollView.bounds), CGRectGetHeight(self.scrollView.bounds));
        
        [view addSubview:imageView];
        [self.scrollView addSubview:view];
    }
    
    [self.scrollView setContentSize:CGSizeMake(CGRectGetWidth(self.scrollView.bounds) * pages, CGRectGetHeight(self.scrollView.bounds))];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
