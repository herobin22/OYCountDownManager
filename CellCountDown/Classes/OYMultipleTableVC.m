//
//  OYMultipleTableVC.m
//  CellCountDown
//
//  Created by herobin on 2017/9/30.
//  Copyright © 2017年 herobin. All rights reserved.
//

#import "OYMultipleTableVC.h"
#import "OYTableViewCell.h"
#import "OYCountDownManager.h"

NSString *const OYMultipleTableSource1 = @"OYMultipleTableSource1";
NSString *const OYMultipleTableSource2 = @"OYMultipleTableSource2";

@interface OYMultipleTableVC () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *dataSource;
@property (nonatomic, strong) UITableView *tableView2;
@property (nonatomic, strong) NSArray *dataSource2;

@end

@implementation OYMultipleTableVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"多个列表倒计时";
    self.view.backgroundColor = [UIColor grayColor];

    [self.view addSubview:self.tableView];
    [self.view addSubview:self.tableView2];
    // 启动倒计时管理
    [kCountDownManager start];
    // 增加倒计时源
    [kCountDownManager addSourceWithIdentifier:OYMultipleTableSource1];
    [kCountDownManager addSourceWithIdentifier:OYMultipleTableSource2];
}

#pragma mark - UITableViewDelegate, UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.tableView) {
        return self.dataSource.count;
    }
    return self.dataSource2.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *dataSource;
    if (tableView == self.tableView) {
        dataSource = self.dataSource;
    }else {
        dataSource = self.dataSource2;
    }
    OYTableViewCell *cell = (OYTableViewCell *)[tableView dequeueReusableCellWithIdentifier:OYTableViewCellID];
    // 传递模型
    OYModel *model = dataSource[indexPath.row];
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
- (void)reloadData {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 模拟网络请求
        self.dataSource = nil;
        // 调用reload, 指定identifier
        [kCountDownManager reloadSourceWithIdentifier:OYMultipleTableSource1];
        // 刷新
        [self.tableView reloadData];
        // 停止刷新
        [self.tableView.refreshControl endRefreshing];
    });
}

- (void)reloadData2 {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 模拟网络请求
        self.dataSource2 = nil;
        // 调用reload, 指定identifier
        [kCountDownManager reloadSourceWithIdentifier:OYMultipleTableSource2];
        // 刷新
        [self.tableView2 reloadData];
        // 停止刷新
        [self.tableView2.refreshControl endRefreshing];
    });
}

#pragma mark - Getter
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height/2) style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.refreshControl = [[UIRefreshControl alloc] init];
        [_tableView.refreshControl addTarget:self action:@selector(reloadData) forControlEvents:UIControlEventValueChanged];
        [_tableView registerClass:NSClassFromString(OYTableViewCellID) forCellReuseIdentifier:OYTableViewCellID];
    }
    return _tableView;
}

- (NSArray *)dataSource {
    if (_dataSource == nil) {
        NSMutableArray *arrM = [NSMutableArray array];
        for (NSInteger i=0; i<50; i++) {
            // 模拟从服务器取得数据 -- 例如:服务器返回的数据为剩余时间数
            NSInteger count = arc4random_uniform(100); //生成0-100之间的随机正整数
            OYModel *model = [[OYModel alloc]init];
            model.count = count;
            model.title = [NSString stringWithFormat:@"第%zd条数据", i];
            model.countDownSource = OYMultipleTableSource1;
            [arrM addObject:model];
        }
        _dataSource = arrM.copy;
    }
    return _dataSource;
}

- (UITableView *)tableView2 {
    if (!_tableView2) {
        _tableView2 = [[UITableView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height/2+50, self.view.bounds.size.width, self.view.bounds.size.height/2 - 50) style:UITableViewStylePlain];
        _tableView2.dataSource = self;
        _tableView2.delegate = self;
        _tableView2.refreshControl = [[UIRefreshControl alloc] init];
        [_tableView2.refreshControl addTarget:self action:@selector(reloadData2) forControlEvents:UIControlEventValueChanged];
        [_tableView2 registerClass:NSClassFromString(OYTableViewCellID) forCellReuseIdentifier:OYTableViewCellID];
    }
    return _tableView2;

}

- (NSArray *)dataSource2 {
    if (_dataSource2 == nil) {
        NSMutableArray *arrM = [NSMutableArray array];
        for (NSInteger i=0; i<50; i++) {
            // 模拟从服务器取得数据 -- 例如:服务器返回的数据为剩余时间数
            NSInteger count = arc4random_uniform(100); //生成0-100之间的随机正整数
            OYModel *model = [[OYModel alloc]init];
            model.count = count;
            model.title = [NSString stringWithFormat:@"第%zd条数据", i];
            model.countDownSource = OYMultipleTableSource2;
            [arrM addObject:model];
        }
        _dataSource2 = arrM.copy;
    }
    return _dataSource2;
}

- (void)dealloc {
    [kCountDownManager removeAllSource];
    [kCountDownManager invalidate];
}

@end
