//
//  TableViewCell.h
//  CellCountDown
//
//  Created by herobin on 16/9/11.
//  Copyright © 2016年 herobin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OYModel.h"
extern NSString *const OYTableViewCellID;

@interface OYTableViewCell : UITableViewCell

@property (nonatomic, strong) OYModel *model;

/// 倒计时到0时回调
@property (nonatomic, copy) void(^countDownZero)(OYModel *);

@end
