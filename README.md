# OYCountDownManager
##iOS在cell中使用倒计时的处理方法
##效果图:![](https://github.com/herobin22/OYCountDownManager/master/Untitled.gif)  
##使用方法: 
###1. 导入"OYCountDownManager.h"
###2. 在第一次使用的地方调用[kCountDownManager start]
    - (void)viewDidLoad {
        [super viewDidLoad];
    
        // 启动倒计时管理
        [kCountDownManager start];
    }
###3. 在Cell中监听通知 kCountDownNotification
    - (instancetype)initWithFrame:(CGRect)frame
    {
        self = [super initWithFrame:frame];
        if (self) {
            // 监听通知
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(countDownNotification)    name:kCountDownNotification object:nil];
      }
      return self;
  }
###4. 在cell设置通知回调, 取得时间差, 根据时间差进行处理
     /// 计算倒计时
        NSInteger countDown = [self.model.count integerValue] - kCountDownManager.timeInterval;
        if (countDown < 0) return;
        /// 重新赋值
        self.timeLabel.text = [NSString stringWithFormat:@"倒计时%02zd:%02zd:%02zd", countDown/3600, (countDown/60)%60, countDown%60];
###5. 当刷新数据时,调用[kCountDownManager reload]
    - (void)reloadData {
        // 网络加载数据
    
        // 调用[kCountDownManager reload]
        [kCountDownManager reload];
        // 刷新
        [self.tableView reloadData];
    }

