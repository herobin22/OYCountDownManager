# OYCountDownManager
iOS在cell中使用倒计时的处理方法

使用方法: 
1. 导入"OYCountDownManager.h"
2. 在第一次使用的地方调用[kCountDownManager start]
3. 在Cell中监听通知 kCountDownNotification
4. 在cell设置通知回调, 取得时间差, 根据时间差进行处理
5. 当刷新数据时,调用[kCountDownManager reload]
