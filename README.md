## 一.OYCountDownManager描述
iOS在cell中使用倒计时的处理方法, 全局使用一个NSTimer对象

Swift版本: [OYCountDownManager-Swift](https://github.com/herobin22/OYCountDownManager-Swift)
* 单个列表倒计时
* 多个列表倒计时
* 多个页面倒计时
* 分页列表倒计时
* 后台模式倒计时

![单个列表](https://github.com/herobin22/OYCountDownManager/raw/master/gif-single.gif)![多个列表.gif](https://github.com/herobin22/OYCountDownManager/raw/master/gif-multipleTable.gif)![多个页面.gif](https://github.com/herobin22/OYCountDownManager/raw/master/gif-multiplePage.gif)![分页列表.gif](https://github.com/herobin22/OYCountDownManager/raw/master/gif-paging.gif)

## 二.原理分析
![原理分析图.png](http://upload-images.jianshu.io/upload_images/1646270-622a49c3f6d9b4f3.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

## 三.使用方法
#### 1.1 第一种方法: 使用cocoapods自动安装
```
pod 'OYCountDownManager'
```

#### 1.2 第二种方法
```
下载示例Demo, 把里面的OYCountDownManager文件夹拖到你的项目中
```

#### 2. 在第一次使用的地方调用[kCountDownManager start]
```
- (void)viewDidLoad {
    [super viewDidLoad];

    // 启动倒计时管理
    [kCountDownManager start];
}
```
#### 3. 在Cell初始化中监听通知 kCountDownNotification
```
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        // 监听通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(countDownNotification) name:kCountDownNotification object:nil];
    }
    return self;
}
```
#### 4. 在cell设置通知回调, 取得时间差, 根据时间差进行处理
```
- (void)countDownNotification {
    /// 计算倒计时
    NSInteger countDown = [self.model.count integerValue] - kCountDownManager.timeInterval;
    if (countDown <= 0) {
          // 倒计时结束时回调
          xxxx(使用代理或block)
          return;
    }
    /// 重新赋值
    self.timeLabel.text = [NSString stringWithFormat:@"倒计时%02zd:%02zd:%02zd", countDown/3600,       (countDown/60)%60, countDown%60];
}
```
#### 5. 当刷新数据时,调用reload方法
```
- (void)reloadData {
    // 网络加载数据

    // 调用[kCountDownManager reload]
    [kCountDownManager reload];
    // 刷新
    [self.tableView reloadData];
}
```
#### 6. 当不需要倒计时时, 废除定时器
```
[kCountDownManager invalidate];
```


## 四.高级使用(多列表.多页面.分页列表)
增加identifier:标识符, 一个identifier支持一个倒计时源, 有一个单独的时间差
```
/** 添加倒计时源 */
- (void)addSourceWithIdentifier:(NSString *)identifier;

/** 获取时间差 */
- (NSInteger)timeIntervalWithIdentifier:(NSString *)identifier;

/** 刷新倒计时源 */
- (void)reloadSourceWithIdentifier:(NSString *)identifier;

/** 刷新所有倒计时源 */
- (void)reloadAllSource;

/** 清除倒计时源 */
- (void)removeSourceWithIdentifier:(NSString *)identifier;

/** 清除所有倒计时源 */
- (void)removeAllSource;
```
以一个页面有两个独立的列表为例
#### 1.定义identifier(常量)
```
NSString *const OYMultipleTableSource1 = @"OYMultipleTableSource1";
NSString *const OYMultipleTableSource2 = @"OYMultipleTableSource2";
```

#### 2.增加倒计时源
```
// 增加倒计时源 
[kCountDownManager addSourceWithIdentifier:OYMultipleTableSource1];
[kCountDownManager addSourceWithIdentifier:OYMultipleTableSource2];
```
#### 3.在cell通知回调中, 通过identifier取得时间差, 根据时间差进行处理
```
- (void)countDownNotification {
    /// 判断是否需要倒计时 -- 可能有的cell不需要倒计时,根据真实需求来进行判断
    if (0) {
        return;
    }
    /// 计算倒计时
    OYModel *model = self.model;
    /// 根据identifier取得时间差, 以OYMultipleTableSource1为例
    NSInteger timeInterval = timeInterval = [kCountDownManager timeIntervalWithIdentifier: OYMultipleTableSource1];
    }
    NSInteger countDown = model.count - timeInterval;
    /// 当倒计时到了进行回调
    if (countDown <= 0) {
        self.detailTextLabel.text = @"活动开始";
        // 倒计时结束时回调
          xxxx(使用代理或block)
        return;
    }
    /// 重新赋值
    self.detailTextLabel.text = [NSString stringWithFormat:@"倒计时%02zd:%02zd:%02zd", countDown/3600, (countDown/60)%60, countDown%60];
}
```

#### 4. 当刷新数据时,调用reloadSourceWithIdentifier:刷新时间差
```
- (void)reloadData {
    // 网络加载数据

   // 调用reloadSourceWithIdentifier:刷新时间差
   [kCountDownManager reloadSourceWithIdentifier:OYMultiplePageSource1];
    // 刷新
    [self.tableView reloadData];
}
```

#### 5. 当页面销毁, 移除倒计时源, 或者不需要定时器, 废除定时器
```
// 移除所有倒计时源
[kCountDownManager removeAllSource];
// 废除定时器
[kCountDownManager invalidate];
```


## 五.注意事项
 > #### 误差分析
 * NSTimer可以精确到50-100毫秒,不是绝对准确的,所以你使用时间累加的方法时间久了有可能成为时间误差的来源
* 以秒为单位触发定时器, 当reloadData后, 定时器也许刚好到达触发点, 时间差+1, 数据刚reload完就马上-1秒 
* 后台模式是以进入后台的绝对时间, 及进入前台的绝对时间做差值来计算的, 差值会进行取整, 导致一点点误差
 
 > #### 滚动cell时出去文字闪烁
  在给cell的模型赋值后, 最好手动调用一下countDownNotification方法, 保证及时刷新 
 ```
 ///  重写setter方法
 - (void)setModel:(Model *)model {
     _model = model;
     self.titleLabel.text = model.title;
     // 手动调用通知的回调
     [self countDownNotification];
}
 ```



> #### 倒计时为0后出现复用问题
 在倒计时为0后, 应该回调给控制器, 从后台请求一次数据, 保证倒计时没有出现误差
 ```
 if (countDown <= 0) {
           // 倒计时结束时回调
           xxxx(使用代理或block)
     }return;
 ```



> #### 出现每秒倒计时减2的问题
1.查看定时器设置是否正确, 或者通知是否监听了两次

2.在countDownNotification方法中, 是否用[NSDate date]做了某些计算, 因为[NSDate date]为当前时间, 每一秒去取都会比上一秒大一秒, 再加上timeInterval也是一秒加一, 那么就会出现每秒倒计时减2的问题


  

 
* 还有不懂的问题, 或者出现其它bug
* 请查看Demo: [Demo](https://github.com/herobin22/OYCountDownManager)
* 简书地址:http://www.jianshu.com/p/af62a56ef7e2
* 或者给我留言, 喜欢的话, 就给作者一个star
