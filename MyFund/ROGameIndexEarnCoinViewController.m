//
//  ROGameIndexEarnCoinViewController.m
//  MyFund
//
//  Created by ben on 14/11/2.
//  Copyright (c) 2014年 benking. All rights reserved.
//

#import "ROGameIndexEarnCoinViewController.h"

@interface ROGameIndexEarnCoinViewController ()

@end

@implementation ROGameIndexEarnCoinViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.btnDUOMENG.layer.cornerRadius = 2;
    self.btnDUOMENG.layer.borderWidth = 1;
    self.btnDUOMENG.layer.borderColor = [UIColorFromRGB(0x3ec060) CGColor];
    self.btnDUOMENG.layer.backgroundColor = [UIColorFromRGB(0x50d266) CGColor];
    
    self.btnCloseModal.layer.cornerRadius = 2;
    self.btnCloseModal.layer.borderWidth = 1;
    self.btnCloseModal.layer.borderColor = [UIColorFromRGB(0x3ec060) CGColor];
    self.btnCloseModal.layer.backgroundColor = [UIColorFromRGB(0x50d266) CGColor];
    
    self.viewTitle.layer.shadowColor = [UIColor grayColor].CGColor;
    self.viewTitle.layer.shadowOffset = CGSizeMake(0.2, 0.2);
    self.viewTitle.layer.shadowOpacity = 0.5;
    self.viewTitle.layer.shadowRadius = 1.0;
    
    self.view.backgroundColor = UIColorFromRGB(0xf1f0ee);
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)closeModal:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
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
