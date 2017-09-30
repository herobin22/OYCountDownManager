//
//  Model.h
//  CellCountDown
//
//  Created by herobin on 16/9/11.
//  Copyright © 2016年 herobin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OYModel : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) NSInteger count;

/// 表示时间已经到了
@property (nonatomic, assign) BOOL timeOut;

/// 倒计时源
@property (nonatomic, copy) NSString *countDownSource;

@end
