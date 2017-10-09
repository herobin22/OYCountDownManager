## 一.OYCountDownManager描述
iOS在cell中使用倒计时的处理方法, 全局使用一个NSTimer对象
* 单个列表倒计时
* 多个列表倒计时
* 多个页面倒计时
* 分页列表倒计时
* 后台模式倒计时
![](https://github.com/herobin22/OYCountDownManager/raw/master/Source/single.gif)![多个列表倒计时.gif](http://upload-images.jianshu.io/upload_images/1646270-1aeb8d0096ed02c9.gif?imageMogr2/auto-orient/strip)![多个页面倒计时.gif](http://upload-images.jianshu.io/upload_images/1646270-215ec89ec4db5042.gif?imageMogr2/auto-orient/strip)![分页列表倒计时.gif](http://upload-images.jianshu.io/upload_images/1646270-2006d5c20996175b.gif?imageMogr2/auto-orient/strip)

## 使用方法: 
### 1. 导入"OYCountDownManager.h"
### 2. 在第一次使用的地方调用[kCountDownManager start]
    - (void)viewDidLoad {
        [super viewDidLoad];
    
        // 启动倒计时管理
        [kCountDownManager start];
    }
### 3. 在Cell中监听通知 kCountDownNotification
```
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        // 监听通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(countDownNotification) name:kCountDownNotification object:nil];
    }
    return self;
    }
```
### 4. 在cell设置通知回调, 取得时间差, 根据时间差进行处理
```
- (void)countDownNotification {
    // 计算倒计时
    NSInteger countDown = [self.model.count integerValue] - kCountDownManager.timeInterval;
    if (countDown <= 0) {
          // 倒计时结束时回调
          xxxx(使用代理或block)
    }return;
    // 重新赋值
    self.timeLabel.text = [NSString stringWithFormat:@"倒计时%02zd:%02zd:%02zd", countDown/3600, (countDown/60)%60, countDown%60];
}
```
### 5. 当刷新数据时,调用[kCountDownManager reload]
    - (void)reloadData {
        // 网络加载数据
    
        // 调用reload
        [kCountDownManager reload];
        // 刷新
        [self.tableView reloadData];
    }
### 6. 当不需要倒计时时, 废除定时器
```
      [kCountDownManager invalidate];
```


## 简书地址:http://www.jianshu.com/p/af62a56ef7e2
## 喜欢请Star一个
