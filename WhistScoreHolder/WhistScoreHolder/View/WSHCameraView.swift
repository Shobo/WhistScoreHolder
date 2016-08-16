//
//  WSHCameraView.swift
//  WhistScoreHolder
//
//  Created by OctavF on 13/08/16.
//  Copyright © 2016 WSHGmbH. All rights reserved.
//

import UIKit
import AVFoundation

class WSHCameraView: UIView {

    @IBOutlet private weak var cameraContainerView: WSHOverlayView!
    @IBOutlet private weak var switchCameraButton: UIButton!
    @IBOutlet private weak var previewView: UIView!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var overlayView: UIView!
    
    private var captureSession: AVCaptureSession?
    private var backCameraDevice: AVCaptureDevice?
    private var frontCameraDevice: AVCaptureDevice?
    private var currentCameraDevice: AVCaptureDevice?
    private var stillImageOutput: AVCaptureStillImageOutput?
    private var previewLayer: AVCaptureVideoPreviewLayer?
    private var videoConnection: AVCaptureConnection!
    
    private(set) var image: UIImage? {
        set(newImage) {
            self.imageView.image = newImage
            
            if (newImage != nil) {
                self.stopCamera()
            } else {
                self.imageView.contentMode = .ScaleAspectFill
                self.startCamera()
            }
        }
        get {
            return self.imageView.image
        }
    }
    
    
    // MARK: - Lifecycle
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        xibSetup()
        setupCamera()
        setupOverlayButtons()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        xibSetup()
        setupCamera()
        setupOverlayButtons()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.previewLayer?.position = CGPointMake(self.bounds.width / 2.0, self.bounds.height / 2.0)
        self.setupPreviewLayerOrientationDeviceDependent()
    }
    
    
    // MARK: - Public
    
    
    func setFitImage(givenImage: UIImage?) {
        self.image = givenImage
        
        if let _ = givenImage {
            self.imageView.contentMode = .ScaleAspectFit
        }
    }
    
    
    // MARK: - Private
    
    
    private func xibSetup() {
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: "WSHCameraView", bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        self.addSubview(view);
    }
    
    private func setupCamera() {
        self.captureSession = AVCaptureSession()
        self.captureSession!.sessionPreset = AVCaptureSessionPresetPhoto
        
        let availableCameraDevices = AVCaptureDevice.devicesWithMediaType(AVMediaTypeVideo)
        
        for device in availableCameraDevices as! [AVCaptureDevice] {
            if device.position == .Back {
                self.backCameraDevice = device
                self.setupDevice(self.backCameraDevice!)
                
            } else if device.position == .Front {
                self.frontCameraDevice = device
                self.setupDevice(self.frontCameraDevice!)
            }
        }
        self.setupIntputTo(self.backCameraDevice!)
        
        self.stillImageOutput = AVCaptureStillImageOutput()
        self.stillImageOutput!.outputSettings = [AVVideoCodecJPEG: AVVideoCodecKey]
        
        if (self.captureSession?.canAddOutput(self.stillImageOutput) ?? false) {
            self.captureSession!.addOutput(self.stillImageOutput)
        }
        
        let deviceMin = min(UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.height)
        
        self.previewLayer = AVCaptureVideoPreviewLayer(session: self.captureSession)
        self.previewLayer?.frame = CGRectMake(0.0, 0.0, deviceMin, deviceMin)
        self.previewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
        self.setupPreviewLayerOrientationDeviceDependent()
        
        self.previewView.layer.addSublayer(self.previewLayer!)
        
        self.videoConnection = self.stillImageOutput!.connectionWithMediaType(AVMediaTypeVideo)
        
        self.startCamera()
    }
    
    private func setupOverlayButtons() {
        self.switchCameraButton.tintColor = UIColor.white()
    }
    
    private func startCamera() {
        self.captureSession?.startRunning()
        self.previewView.hidden = false
        self.switchCameraButton.hidden = false
        self.imageView.hidden = true
    }
    
    private func stopCamera() {
        self.captureSession?.stopRunning()
        self.previewView.hidden = true
        self.switchCameraButton.hidden = true
        self.imageView.hidden = false
    }
    
    private func setupIntputTo(inputDevice: AVCaptureDevice) {
        do {
            let input = try AVCaptureDeviceInput(device: inputDevice)
            
            if self.captureSession!.canAddInput(input) {
                self.captureSession!.addInput(input)
                
                self.currentCameraDevice = inputDevice
            }
        } catch {//let error {
//            presentError(error, fromController: nil)
        }
    }
    
    private func setupDevice(inputDevice: AVCaptureDevice) {
        let baseCameraSize = prefferedImageSize()
        let focusPoint = CGPointMake(baseCameraSize.width / 2.0, baseCameraSize.height / 2.0)
        
        if inputDevice.focusPointOfInterestSupported {
            do {
                try inputDevice.lockForConfiguration()
                inputDevice.focusPointOfInterest = focusPoint
                inputDevice.focusMode = .AutoFocus
                inputDevice.exposurePointOfInterest = focusPoint
                inputDevice.exposureMode = .AutoExpose
            } catch {
                //ERR
            }
        }
    }
    
    private func setupPreviewLayerOrientationDeviceDependent() {
        if let connection = self.previewLayer?.connection  {
            connection.videoOrientation = self.avOrientation(UIDevice.currentDevice().orientation)
        }
    }
    
    private func imageOrientationForCurrentDeviceOrientation() -> UIImageOrientation {
        var imageOrientation: UIImageOrientation = .Up
        
        if self.currentCameraDevice == self.frontCameraDevice {
            switch UIDevice.currentDevice().orientation {
            case .Portrait:
                imageOrientation = .Right
                break
                
            case .PortraitUpsideDown:
                imageOrientation = .Right
                break
                
            case .LandscapeRight:
                imageOrientation = .UpMirrored
                break
            
            case .LandscapeLeft:
                imageOrientation = .DownMirrored
                break
                
            default:
                break
            }
            
        } else {
            switch UIDevice.currentDevice().orientation {
            case .Portrait:
                imageOrientation = .Right
                break
                
            case .PortraitUpsideDown:
                imageOrientation = .Left
                break
                
            case .LandscapeRight:
                imageOrientation = .Down
                break
                
            default:
                break
            }
        }
        return imageOrientation
    }
    
    private func avOrientation(forDeviceOrientation: UIDeviceOrientation) -> AVCaptureVideoOrientation {
        var result:AVCaptureVideoOrientation = .Portrait
        
        switch forDeviceOrientation {
        case .LandscapeLeft:
            result = .LandscapeRight
            break
        case .LandscapeRight:
            result = .LandscapeLeft
            break
        default:
            break
        }
        return result
    }
    
    
    //MARK: - Actions
    

    @IBAction func didTap(sender: AnyObject) {
        if let _ = self.image {
            self.image = nil
            
        } else {
            self.stillImageOutput?.captureStillImageAsynchronouslyFromConnection(self.videoConnection, completionHandler: {[weak self] (sampleBuffer, error) in
                let imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(sampleBuffer)
                let dataProvider = CGDataProviderCreateWithCFData(imageData)
                let cgImageRef = CGImageCreateWithJPEGDataProvider(dataProvider, nil, true, .RenderingIntentDefault)
                let image = UIImage(CGImage: cgImageRef!, scale: 0.7, orientation: self?.imageOrientationForCurrentDeviceOrientation() ?? .Up)
                
                self?.image = image
                
                if let imageView = self?.imageView {
                    if let visibleImage = UIImage.visibleImageFromImageView(imageView) {
                        self?.setFitImage(visibleImage)
                    }
                }
                if let maImage = self?.image {
                    self?.setFitImage(maImage.centerCroppedImage(prefferedImageSize()))
                }
                })
        }
    }
    
    @IBAction func didTapSwitchCamera(sender: AnyObject) {
        if let input = self.captureSession?.inputs[0] as? AVCaptureInput {
            self.captureSession?.removeInput(input)
        }
        if self.currentCameraDevice == self.frontCameraDevice {
            self.currentCameraDevice = self.backCameraDevice
        } else {
            self.currentCameraDevice = self.frontCameraDevice
        }
        if let asdf = self.currentCameraDevice {
            self.setupIntputTo(asdf)
            self.videoConnection = self.stillImageOutput!.connectionWithMediaType(AVMediaTypeVideo)
        }
    }
    
}
