//
//  ViewController.swift
//  OYCountDown
//
//  Created by Gold on 2016/10/27.
//  Copyright © 2016年 Gold. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    var dataSource = [Model]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        tableView.register(Cell.classForCoder(), forCellReuseIdentifier: "Cell")
        tableView.delegate = self
        tableView.dataSource = self
        
        self.loadData()
        OYCountDownManager.sharedManager.start()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: Cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! Cell
        let model = self.dataSource[indexPath.row]
        cell.model = model
        cell.countDownZero = {
            print(model.title+"开始")
        }
        return cell
    }
    
    func loadData() -> Void {
        var array = [Model]()
        for i in 0..<10 {
            let model: Model = Model()
            //随机数
            let num = Int(arc4random_uniform(100))+1
            model.timer = String(format: "%d", num)
            model.title = "活动\(i)"
            array.append(model)
        }
        self.dataSource = array
    }
}

