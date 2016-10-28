//
//  Cell.swift
//  OYCountDown
//
//  Created by Gold on 2016/10/27.
//  Copyright © 2016年 Gold. All rights reserved.
//

import UIKit

class Cell: UITableViewCell {
    
    var model: Model? {
        didSet {
            self.titleLabel.text = model?.title
//            self.timeLabel.text = model?.timer
            self.timerAction()
        }
    }
    var countDownZero: (() ->Void)? // 倒计时为0时回调
    
    lazy var titleLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 16, y: 4, width: 100, height: 36))
        label.textColor = UIColor.red
        return label
    }()
    
    lazy var timeLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: UIScreen.main.bounds.size.width-116, y: 4, width: 100, height: 36))
        label.textColor = UIColor.orange
        label.textAlignment = NSTextAlignment.right
        return label
    }()

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() -> Void {
        self.contentView.addSubview(self.titleLabel)
        self.contentView.addSubview(self.timeLabel)
        NotificationCenter.default.addObserver(self, selector: #selector(Cell.timerAction), name: OYCountDownManagerNotification, object: nil)
    }
    
    func timerAction() -> Void {
        guard self.model != nil else {
            return
        }
        // 做倒计时的处理
        let timeCount = Int((self.model?.timer!)!)! - OYCountDownManager.sharedManager.timeInterval
        let time = String(format: "%02d:%02d:%02d", timeCount/3600, (timeCount/60)%60, timeCount%60)
        if timeCount <= 0 {
            self.timeLabel.text = "活动开始"
            self.countDownZero?()
            return
        }
        self.timeLabel.text = time
    }
}
