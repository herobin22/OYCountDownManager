//
//  OYPagingTableVC.m
//  CellCountDown
//
//  Created by herobin on 2017/9/30.
//  Copyright © 2017年 herobin. All rights reserved.
//

#import "OYPagingTableVC.h"
#import "OYCountDownManager.h"
#import "OYTableViewCell.h"
#import "MJRefresh.h"

@interface OYPagingTableVC () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic, assign) NSInteger pageNumber;

@end

@implementation OYPagingTableVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"分页列表倒计时";
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    
    [self setupRefresh];
    
    // 启动倒计时管理
    [kCountDownManager start];
}

#pragma mark - UITableViewDataSource, UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    OYTableViewCell *cell = (OYTableViewCell *)[tableView dequeueReusableCellWithIdentifier:OYTableViewCellID];
    // 传递模型
    OYModel *model = self.dataSource[indexPath.row];
    cell.model = model;
    [cell setCountDownZero:^(OYModel *timeOutModel){
        // 回调
        if (!timeOutModel.timeOut) {
            NSLog(@"%@--%@--时间到了", timeOutModel.countDownSource, timeOutModel.title);
        }
        // 标志
        timeOutModel.timeOut = YES;
    }];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

#pragma mark - 刷新数据
- (void)loadData {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 模拟网络请求
        if (self.pageNumber == 0) {
            [self.dataSource removeAllObjects];
        }
        for (NSInteger i=0; i<10; i++) {
            // 模拟从服务器取得数据 -- 例如:服务器返回的数据为剩余时间数
            NSInteger count = arc4random_uniform(100); //生成0-100之间的随机正整数
            OYModel *model = [[OYModel alloc]init];
            model.count = count;
            model.title = [NSString stringWithFormat:@"第%zd条数据", self.pageNumber*10+i];
            model.countDownSource = [NSString stringWithFormat:@"OYPagingSource%zd", self.pageNumber];
            [self.dataSource addObject:model];
        }
        // 增加倒计时源
        [kCountDownManager addSourceWithIdentifier:[NSString stringWithFormat:@"OYPagingSource%zd", self.pageNumber]];
        // 刷新
        [self.tableView reloadData];
        // 停止刷新
        [self endRefreshing];
    });
}

#pragma mark - SetupRefresh
- (void)setupRefresh {
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefresh)];
    self.tableView.mj_header = header;
    
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRefresh)];
    self.tableView.mj_footer = footer;
    
    // 马上刷新一次
    [header beginRefreshing];
}

- (void)headerRefresh {
    self.pageNumber = 0;
    [self loadData];
}

- (void)footerRefresh {
    self.pageNumber ++;
    [self loadData];
}

- (void)endRefreshing {
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
}

#pragma mark - Getter
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        [_tableView registerClass:NSClassFromString(OYTableViewCellID) forCellReuseIdentifier:OYTableViewCellID];
    }
    return _tableView;
}

- (NSArray *)dataSource {
    if (_dataSource == nil) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (void)dealloc {
    [kCountDownManager removeAllSource];
    [kCountDownManager invalidate];
}

@end
