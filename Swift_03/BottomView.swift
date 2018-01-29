//
//  BottomView.swift
//  Swift_03
//
//  Created by 陈孟迪 on 2017/11/28.
//  Copyright © 2017年 陈孟迪. All rights reserved.
//

import UIKit

class BottomView: UIView {

    var photoButton : UIButton?
    
    var cancelButton : UIButton?
    
    var cameraDirButton : UIButton?
    override init(frame: CGRect) {
        super.init(frame: frame)
        createUI()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func createUI() {
        photoButton = UIButton.init(type: UIButtonType.custom)
        photoButton?.frame = CGRect.init(x: (WIDTH-60)/2, y: (HEIGHT/5-60)/2, width: 60, height: 60)
        photoButton?.layer.cornerRadius = 30
        photoButton?.layer.masksToBounds = true
        photoButton?.backgroundColor = UIColor.red
        self.addSubview(photoButton!)
        
        self.cancelButton = UIButton.init(type: .custom)
        self.cancelButton?.frame = CGRect.init(x: 0, y: self.frame.size.height/3, width: (self.frame.size.width-(self.photoButton?.frame.size.width)!)/2, height: self.frame.size.height/3)
        self.cancelButton?.setTitle("取消", for: .normal)
        self.cancelButton?.setTitleColor(UIColor.white, for: .normal)
        self.cancelButton?.titleLabel?.textAlignment = .center
        self.addSubview((self.cancelButton)!)
        
        self.cameraDirButton = UIButton.init(type: .custom)
        self.cameraDirButton?.frame = CGRect.init(x: (self.photoButton?.frame.origin.x)! + (self.photoButton?.frame.size.width)!, y: self.frame.size.height/3, width: (self.frame.size.width-(self.photoButton?.frame.size.width)!)/2, height: self.frame.size.height/3)
        self.cameraDirButton?.setTitle("后", for: .normal)
        self.cameraDirButton?.setTitleColor(UIColor.white, for: .normal)
        self.cameraDirButton?.titleLabel?.textAlignment = .center
        self.addSubview((self.cameraDirButton)!)
    }
}
