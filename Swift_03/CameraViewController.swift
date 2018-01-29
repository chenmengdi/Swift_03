//
//  CameraViewController.swift
//  Swift_03
//
//  Created by 陈孟迪 on 2017/11/23.
//  Copyright © 2017年 陈孟迪. All rights reserved.
//

import UIKit
import AVFoundation
import AssetsLibrary
let WIDTH = UIScreen.main.bounds.width
let HEIGHT = UIScreen.main.bounds.height
let BOUNDS = UIScreen.main.bounds


class CameraViewController: UIViewController {

    //执行输入设备和输出设备之间的数据传递
    let captureSession = AVCaptureSession()
    
    //输入设备
    var videoInput : AVCaptureDeviceInput?
    
    //照片输出流
    var stillImageOutput : AVCaptureStillImageOutput?
    
    //预览图层
    var cameraPreViewLayer : AVCaptureVideoPreviewLayer?
    
    var bottomView : BottomView?
    
    var showView : ShowView?
    
    var showImageView:UIImageView?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        if self.captureSession != nil{
            self.captureSession.startRunning()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
     self.view.backgroundColor = UIColor.white
       setupCamera()
       createUI()
    }

    func setupCamera() {
        
        let device = AVCaptureDevice.default(for: .video)
        //更改这个设置的时候必须先锁定设备，修改完后再解锁，否则崩溃
        //try?会将错误转换为可选值，当调用try?＋函数或方法语句时候，如果函数或方法抛出错误，程序不会发崩溃，而返回一个nil，如果没有抛出错误则返回可选值
        //使用try!可以打破错误传播链条。错误抛出后传播给它的调用者，这样就形成了一个传播链条，但有的时候确实不想让错误传播下去，可以使用try!语句
        try? device?.lockForConfiguration()
        
        //设置闪光灯为自动
        device?.flashMode = .auto
        
        device?.unlockForConfiguration()
        
        self.videoInput = try?AVCaptureDeviceInput.init(device: device!)
        
        self.stillImageOutput = AVCaptureStillImageOutput()
        
        let outputSettings = NSDictionary.init(objects: [AVVideoCodecJPEG], forKeys: [AVVideoCodecKey as NSCopying])
        self.stillImageOutput?.outputSettings = outputSettings as! [String : Any]
        
        if self.captureSession.canAddInput(self.videoInput!) {
            self.captureSession.addInput(self.videoInput!)
        }
        
        if self.captureSession.canAddOutput(self.stillImageOutput!) {
            self.captureSession.addOutput(self.stillImageOutput!)
        }
        
        //初始化预览图层
        self.cameraPreViewLayer = AVCaptureVideoPreviewLayer.init(session: self.captureSession)
        self.cameraPreViewLayer?.videoGravity = .resizeAspect
        self.cameraPreViewLayer?.frame = CGRect.init(x: 0, y: 0, width: WIDTH, height: HEIGHT)
        self.view.layer.addSublayer(cameraPreViewLayer!)
    }
    
    //获取摄像头的方向
    func setDeviceOrientation(orien:UIDeviceOrientation) -> AVCaptureVideoOrientation {
        
        var result:AVCaptureVideoOrientation = AVCaptureVideoOrientation.init(rawValue: orien.rawValue)!
        if orien == .landscapeLeft {
           result = .landscapeRight
        }else if orien == .landscapeRight{
            result = .landscapeLeft
        }
        return result
    }
    
    func createUI() {
        
        bottomView = BottomView.init(frame: CGRect.init(x: 0, y: HEIGHT*4/5, width: WIDTH, height: HEIGHT/5))
        bottomView?.backgroundColor = UIColor.black
        bottomView?.alpha = 0.5
        bottomView?.photoButton?.addTarget(self, action: #selector(takePhoto(sender:)), for: .touchUpInside)
        bottomView?.cancelButton?.addTarget(self, action: #selector(cancel(sender:)), for: .touchUpInside)
        bottomView?.cameraDirButton?.addTarget(self, action: #selector(change(sender:)), for: .touchUpInside)
        self.view.addSubview(bottomView!)
        
        showView = ShowView.init(frame: BOUNDS)
        self.view.addSubview(showView!)
        showView?.saveButton?.addTarget(self, action: #selector(saveActon(sender:)), for: .touchUpInside)
        showView?.cancel?.addTarget(self, action: #selector(cancelAction(sender:)), for: .touchUpInside)
        showView?.isHidden = true
        
        self.showImageView = UIImageView.init(frame: CGRect.init(x: 20, y: 64, width: WIDTH-40, height: HEIGHT-64*3))
        self.showImageView?.contentMode = .scaleAspectFit
        self.view.addSubview(self.showImageView!)
        self.showImageView?.isHidden = true
    }
    
    //拍照事件
    @objc func takePhoto(sender:UIButton) {
        //获得音视频采集设备的连接
        let connection:AVCaptureConnection = (self.stillImageOutput?.connection(with: AVMediaType.video))!
        let deviceOrientation:UIDeviceOrientation = UIDevice.current.orientation
        
        let avcaptureOrientation:AVCaptureVideoOrientation = setDeviceOrientation(orien: deviceOrientation)
        connection.videoOrientation = avcaptureOrientation
        connection.videoScaleAndCropFactor = 1
        
        //输出端以异步方式采集静态图像
        self.stillImageOutput?.captureStillImageAsynchronously(from: connection, completionHandler: { (imageDataSampleBuffer, error) in
            //获取图片
            let jpegData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(imageDataSampleBuffer!)
            
            let stillImage = UIImage.init(data: jpegData!)
            self.showView?.isHidden = false
            self.bottomView?.isHidden = true
            self.showImageView?.isHidden = false
            self.showImageView?.image = stillImage
        })
    }
    
    //保存照片
    @objc func saveActon(sender:UIButton)  {
        
        if ((self.showImageView?.image) != nil) {
         UIImageWriteToSavedPhotosAlbum((self.showImageView?.image)!, nil, nil, nil)
            self.showView?.isHidden = true
            self.showImageView?.isHidden = true
            self.bottomView?.isHidden = false
        }else{
        print("图片为空")
        }
    }
    //取消保存
    @objc func cancelAction(sender:UIButton)  {

        self.showView?.isHidden = true
        self.showImageView?.isHidden = true
        self.bottomView?.isHidden = false
    }
    
    //切换前后摄像头
    @objc func change(sender:UIButton) {
        
        
        //获取之前摄像头的方向
        var oritation = self.videoInput?.device.position
        
        if oritation == .front {
            oritation = .back
           bottomView?.cameraDirButton?.setTitle("后", for: .normal)
        }else if oritation == .back{
            oritation = .front
            bottomView?.cameraDirButton?.setTitle("前", for: .normal)
        }
        
        let devices = AVCaptureDevice.devices() as? [AVCaptureDevice]
        
        let device = devices?.filter({$0.position == oritation}).first
        
        let newInput = try? AVCaptureDeviceInput.init(device: device!)
        
        //移除之前的input
        self.captureSession.beginConfiguration()
        
        self.captureSession.removeInput(self.videoInput!)
        if self.captureSession.canAddInput(newInput!) {
            self.captureSession.addInput(newInput!)
            self.videoInput = newInput
        }
        
        self.captureSession.commitConfiguration()
  
    }
    
    @objc func cancel(sender:UIButton) {
        
        self.navigationController?.popViewController(animated: false)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if self.captureSession != nil {
            self.captureSession.stopRunning()
        }
    }
}
