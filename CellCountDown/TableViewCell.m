//
//  TableViewCell.m
//  CellCountDown
//
//  Created by herobin on 16/9/11.
//  Copyright © 2016年 herobin. All rights reserved.
//

#import "TableViewCell.h"
#import "OYCountDownManager.h"
#import "Model.h"

@interface TableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@end

@implementation TableViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // 监听通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(countDownNotification) name:kCountDownNotification object:nil];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        // 监听通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(countDownNotification) name:kCountDownNotification object:nil];
    }
    return self;
}

#pragma mark - 倒计时通知回调
- (void)countDownNotification {
    /// 判断是否需要倒计时 -- 可能有的cell不需要倒计时,根据真实需求来进行判断
    if (0) {
        return;
    }
    
    /// 计算倒计时
    NSInteger countDown = [self.model.count integerValue] - kCountDownManager.timeInterval;
    if (countDown < 0) return;
    /// 重新赋值
    self.timeLabel.text = [NSString stringWithFormat:@"倒计时%02zd:%02zd:%02zd", countDown/3600, (countDown/60)%60, countDown%60];
    /// 当倒计时到了进行回调
    if (countDown == 0) {
        self.timeLabel.text = @"活动开始";
        if (self.countDownZero) {
            self.countDownZero();
        }
    }
}

///  重写setter方法
- (void)setModel:(Model *)model {
    _model = model;
    
    self.titleLabel.text = model.title;
    // 手动调用通知的回调
    [self countDownNotification];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

@end
