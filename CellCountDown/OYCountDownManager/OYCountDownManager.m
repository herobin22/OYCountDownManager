//
//  CountDownManager.m
//  CellCountDown
//
//  Created by herobin on 16/9/11.
//  Copyright © 2016年 herobin. All rights reserved.
//

#import "OYCountDownManager.h"


@interface OYTimeInterval ()

@property (nonatomic, assign) NSInteger timeInterval;

+ (instancetype)timeInterval:(NSInteger)timeInterval;

@end



@interface OYCountDownManager ()

@property (nonatomic, strong) NSTimer *timer;

/// 时间差字典(单位:秒)(使用字典来存放, 支持多列表或多页面使用)
@property (nonatomic, strong) NSMutableDictionary<NSString *, OYTimeInterval *> *timeIntervalDict;

@end

@implementation OYCountDownManager

+ (instancetype)manager {
    static OYCountDownManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[OYCountDownManager alloc]init];
    });
    return manager;
}

- (void)start {
    // 启动定时器
    [self timer];
}

- (void)reload {
    // 刷新只要让时间差为0即可
    _timeInterval = 0;
}

- (void)invalidate {
    [self.timer invalidate];
    self.timer = nil;
    self.timeInterval = 0;
}

- (void)timerAction {
    // 时间差+1
    self.timeInterval ++;
    [self.timeIntervalDict enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, OYTimeInterval * _Nonnull obj, BOOL * _Nonnull stop) {
        obj.timeInterval ++;
    }];
    // 发出通知
    [[NSNotificationCenter defaultCenter] postNotificationName:kCountDownNotification object:nil userInfo:nil];
}

- (void)addSourceWithIdentifier:(NSString *)identifier {
    OYTimeInterval *timeInterval = self.timeIntervalDict[identifier];
    if (timeInterval) {
        timeInterval.timeInterval = 0;
    }else {
        [self.timeIntervalDict setObject:[OYTimeInterval timeInterval:0] forKey:identifier];
    }
}

- (NSInteger)timeIntervalWithIdentifier:(NSString *)identifier {
    return self.timeIntervalDict[identifier].timeInterval;
}

- (void)reloadSourceWithIdentifier:(NSString *)identifier {
    self.timeIntervalDict[identifier].timeInterval = 0;
}

- (void)reloadAllSource {
    [self.timeIntervalDict enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, OYTimeInterval * _Nonnull obj, BOOL * _Nonnull stop) {
        obj.timeInterval = 0;
    }];
}

- (void)removeSourceWithIdentifier:(NSString *)identifier {
    [self.timeIntervalDict removeObjectForKey:identifier];
}

- (void)removeAllSource {
    [self.timeIntervalDict removeAllObjects];
}

- (NSTimer *)timer {
    if (_timer == nil) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    }
    return _timer;
}

- (NSMutableDictionary *)timeIntervalDict {
    if (!_timeIntervalDict) {
        _timeIntervalDict = [NSMutableDictionary dictionary];
    }
    return _timeIntervalDict;
}

@end


@implementation OYTimeInterval

+ (instancetype)timeInterval:(NSInteger)timeInterval {
    OYTimeInterval *object = [OYTimeInterval new];
    object.timeInterval = timeInterval;
    return object;
}

@end
