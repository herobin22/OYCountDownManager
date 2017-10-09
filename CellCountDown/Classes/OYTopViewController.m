//
//  OYTopViewController.m
//  CellCountDown
//
//  Created by Gold on 2017/9/30.
//  Copyright © 2017年 herobin. All rights reserved.
//

#import "OYTopViewController.h"
#import "OYSingleTableVC.h"
#import "OYMultipleTableVC.h"
#import "OYPagingTableVC.h"

@interface OYTopViewController ()

@end

@implementation OYTopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"首页";
}

- (IBAction)singleTableBtnClick:(id)sender {
    [self.navigationController pushViewController:[OYSingleTableVC new] animated:YES];
}

- (IBAction)mutipleTableBtnClick:(id)sender {
    [self.navigationController pushViewController:[OYMultipleTableVC new] animated:YES];
}

- (IBAction)pagingTableBtnClick:(id)sender {
    [self.navigationController pushViewController:[OYPagingTableVC new] animated:YES];
}

@end
