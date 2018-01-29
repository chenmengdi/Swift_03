//
//  ViewController.swift
//  Swift_03
//
//  Created by 陈孟迪 on 2017/11/23.
//  Copyright © 2017年 陈孟迪. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let button = UIButton.init(type: UIButtonType.custom)
        button.frame = CGRect.init(x: 0, y: 100, width: self.view.frame.size.width, height: 50)
        button.setTitle("GO", for: UIControlState.normal)
        button.setTitleColor(UIColor.red, for: UIControlState.normal)
        button.addTarget(self, action: #selector(ViewController.action(sender:)), for: UIControlEvents.touchUpInside)
        self.view.addSubview(button)
    }

    @objc func action(sender:UIButton) {
        
        let vc = CameraViewController.init(nibName: nil, bundle: nil)
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

