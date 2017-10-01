//
//  CountDownManager.h
//  CellCountDown
//
//  Created by herobin on 16/9/11.
//  Copyright © 2016年 herobin. All rights reserved.
//

#import <Foundation/Foundation.h>
/** 宏: 使用单例 */
#define kCountDownManager [OYCountDownManager manager]
/** 倒计时的通知名 */
extern NSString *const OYCountDownNotification;

@interface OYCountDownManager : NSObject

/** 使用单例 */
+ (instancetype)manager;

/** 开始倒计时 */
- (void)start;

/** 停止倒计时 */
- (void)invalidate;



// ======== v1.0 ========
// 如果只需要一个倒计时差, 可继续使用timeInterval属性
// 增加后台模式, 后台状态下会继续计算时间差

/** 时间差(单位:秒) */
@property (nonatomic, assign) NSInteger timeInterval;

/** 刷新倒计时(兼容旧版本, 如使用identifier标识的时间差, 请调用reloadAllSource方法) */
- (void)reload;



// ======== v2.0 ========
// 增加identifier:标识符, 一个identifier支持一个倒计时源, 有一个单独的时间差

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

@end



@interface OYTimeInterval : NSObject
@end
