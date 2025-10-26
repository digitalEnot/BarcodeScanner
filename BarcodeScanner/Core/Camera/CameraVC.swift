//
//  CameraVC.swift
//  BarcodeScanner
//
//  Created by Evgeni Novik on 20.10.2025.
//

import UIKit
import AVFoundation

class CameraVC: UIViewController {
    
    private let sessionQueue = DispatchQueue(label: "scanner.session.queue") // зачем?
    let captureSession = AVCaptureSession()
    var previewLayer: AVCaptureVideoPreviewLayer?
    weak var delegate: CameraVCDelegate?
    
    init(delegate: CameraVCDelegate) {
        super.init(nibName: nil, bundle: nil)
        self.delegate = delegate
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupSession()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        sessionQueue.async { [weak self] in
            self?.captureSession.startRunning()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        delegate?.turnOffFlash()
        self.setFlashlightTo(false)
        sessionQueue.async { [weak self] in
            self?.captureSession.stopRunning()
            DispatchQueue.main.async { [weak self] in
                self?.delegate?.didGetBounds(nil)
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        guard let previewLayer = previewLayer else {
            self.delegate?.didEndWithError(URLError(.unknown)) // поменять тип ошибки
            return
        }
        previewLayer.frame = view.layer.bounds
    }
    
    func setFlashlightTo(_ isOn: Bool) {
        guard let device = AVCaptureDevice.default(for: .video) else {
            self.delegate?.didEndWithError(URLError(.unknown)) // поменять тип ошибки
            return
        }
        
        guard device.hasTorch else { // TODO: все обращения к делегату должны быть на main потоке!!!
            self.delegate?.didEndWithError(URLError(.unknown)) // поменять тип ошибки
            return
        }
        
        do {
            try device.lockForConfiguration()
            if isOn {
                try device.setTorchModeOn(level: 1.0)
            } else {
                device.torchMode = .off
            }
            device.unlockForConfiguration()
        } catch {
            self.delegate?.didEndWithError(URLError(.unknown)) // поменять тип ошибки
        }
    }
    
    private func setupSession() {
        sessionQueue.async { [weak self] in
            guard let self = self else { return }
            
            guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else {
                DispatchQueue.main.async {
                    self.delegate?.didEndWithError(URLError(.unknown)) // поменять тип ошибки
                }
                return
            }
            
            let videoInput: AVCaptureDeviceInput
            
            do {
                videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
            } catch {
                DispatchQueue.main.async {
                    self.delegate?.didEndWithError(URLError(.unknown)) // поменять тип ошибки
                }
                return
            }
            
            if captureSession.canAddInput(videoInput) {
                captureSession.addInput(videoInput)
            } else {
                DispatchQueue.main.async {
                    self.delegate?.didEndWithError(URLError(.unknown)) // поменять тип ошибки
                }
                return
            }
            
            let metaDataOutput = AVCaptureMetadataOutput()
            
            if captureSession.canAddOutput(metaDataOutput) {
                captureSession.addOutput(metaDataOutput)
                metaDataOutput.setMetadataObjectsDelegate(self, queue: .main) // фикс варнинга
                metaDataOutput.metadataObjectTypes = [.ean8, .ean13, .qr]
            } else {
                DispatchQueue.main.async {
                    self.delegate?.didEndWithError(URLError(.unknown)) // поменять тип ошибки
                }
                return
            }
            
            DispatchQueue.main.async {
                self.previewLayer = AVCaptureVideoPreviewLayer(session: self.captureSession)
                self.previewLayer?.videoGravity = .resizeAspectFill
                if let previewLayer = self.previewLayer {
                    self.view.layer.addSublayer(previewLayer)
                    previewLayer.frame = self.view.layer.bounds
                }
            }
        }
        
    }
}

extension CameraVC: AVCaptureMetadataOutputObjectsDelegate {
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        
        if let object = metadataObjects.first as? AVMetadataMachineReadableCodeObject {
            let code = object.stringValue
            let bounds = object.bounds
            let type: CodeType = (object.type == .qr) ? .qr : .barcode
            
            guard let transformedBounds = previewLayer?.layerRectConverted(fromMetadataOutputRect: bounds) else { return }
            delegate?.didGetBounds(transformedBounds)
            if let code = code {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
                    self?.delegate?.didFindCode(code, type: type)
                }
            } else {
                self.delegate?.didEndWithError(URLError(.unknown)) // поменять тип ошибки
            }
            captureSession.stopRunning()
        } else {
            delegate?.didGetBounds(nil) // TODO: вопрос надо ли это??? (+ надо добавить сообщение при получении разрешения на пользование камеры)
        }
    }
}

