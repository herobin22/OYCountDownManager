//
//  TableViewCell.h
//  CellCountDown
//
//  Created by herobin on 16/9/11.
//  Copyright © 2016年 herobin. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Model;

@interface TableViewCell : UITableViewCell

@property (nonatomic, strong) Model *model;

/// 可能有的不需要倒计时,如倒计时时间已到, 或者已经过了
@property (nonatomic, assign) BOOL needCountDown;

/// 倒计时到0时回调
@property (nonatomic, copy) void(^countDownZero)();

@end
