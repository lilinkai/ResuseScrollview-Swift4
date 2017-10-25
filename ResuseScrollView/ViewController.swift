//
//  ViewController.swift
//  ResuseScrollView
//
//  Created by 林凯李 on 2017/10/23.
//  Copyright © 2017年 林凯李. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let imgModel = ImageShowModel(imageUrls: ["1.jpg","2.jpg","3.jpg","4.jpg"], imageDescs: [], jumpId: [], jumpUrl: [])
        
        let contentScrollview = LKResuseScrollview.init(frame: CGRect.init(x: 0, y: 200, width: self.view.frame.width, height: 200), imgModels: imgModel) { (index) in
            print("点击了第\(index)个")
        }
        
        view.addSubview(contentScrollview);
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

