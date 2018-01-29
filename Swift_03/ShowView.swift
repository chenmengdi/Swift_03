//
//  ShowView.swift
//  Swift_03
//
//  Created by 陈孟迪 on 2017/11/29.
//  Copyright © 2017年 陈孟迪. All rights reserved.
//

import UIKit

class ShowView: UIView {

//    var showImageView:UIImageView?
    
    var saveButton : UIButton?
    
    var cancel : UIButton?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.white
        self.alpha = 0.6
        createUI()
        
    }
    
    func createUI() {
        
//        self.showImageView = UIImageView.init(frame: CGRect.init(x: 20, y: 64, width: WIDTH-40, height: HEIGHT-64*3))
//        self.showImageView?.contentMode = .scaleAspectFit
//        self.addSubview(self.showImageView!)
        
        self.saveButton = UIButton.init(type: .custom)
        self.saveButton?.frame = CGRect.init(x: WIDTH/6, y: HEIGHT-(64*2-50), width: WIDTH/4, height: 40)
        self.saveButton?.setTitle("保存", for:.normal)
        self.saveButton?.setTitleColor(UIColor.green, for: .normal)
        self.saveButton?.titleLabel?.textAlignment = .center
        self.addSubview(self.saveButton!)
        
        self.cancel = UIButton.init(type: .custom)
        self.cancel?.frame = CGRect.init(x: WIDTH/3+WIDTH/4, y: HEIGHT-(64*2-50), width: WIDTH/4, height: 40)
        self.cancel?.setTitle("取消", for:.normal)
        self.cancel?.setTitleColor(UIColor.green, for: .normal)
        self.cancel?.titleLabel?.textAlignment = .center
        self.addSubview(self.cancel!)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
