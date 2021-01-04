//
//  CameraViewController.swift
//  openpifpafios
//
//  Created by Sven Kreiss on 25.10.20.
//

import AVFoundation
import UIKit
import SwiftUI
import VideoToolbox

final class CameraViewController: UIViewController {
    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!
    var posePredictor: PosePredictor!
    private let processingQueue = DispatchQueue(label: "com.svenkreiss.openpifpafios.processingqueue")

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // captureSession
        captureSession = AVCaptureSession()
        guard let videoCaptureDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front) else { return }
        // input
        let videoInput = try? AVCaptureDeviceInput(device: videoCaptureDevice)
        captureSession.addInput(videoInput!)
        // output
        let videoOutput = AVCaptureVideoDataOutput()
        videoOutput.alwaysDiscardsLateVideoFrames = true
        videoOutput.setSampleBufferDelegate(self, queue: processingQueue)
        captureSession.addOutput(videoOutput)

        // previewLayer
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = view.layer.bounds
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer)
        
        captureSession.startRunning()
    }
}

extension CameraViewController: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        if let imageBuffer = sampleBuffer.imageBuffer {
            guard CVPixelBufferLockBaseAddress(imageBuffer, .readOnly) == kCVReturnSuccess
                else {
                    return
            }
            var image: CGImage?
            VTCreateCGImageFromCVPixelBuffer(imageBuffer, options: nil, imageOut: &image)
            CVPixelBufferUnlockBaseAddress(imageBuffer, .readOnly)

            posePredictor!.predict(image!)
        }
    }
}

struct CameraViewControllerRepresentable: UIViewControllerRepresentable {
    var posePredictor: PosePredictor
    @Binding var poses: [Pose]
    @Binding var poseUpdateFPS: Double
    public typealias UIViewControllerType = CameraViewController
    
    func poseUpdate(_ poses: [Pose]) {
        self.poses = poses
        self.poseUpdateFPS = 1.0
    }
    
    public func makeUIViewController(context: UIViewControllerRepresentableContext<CameraViewControllerRepresentable>) -> CameraViewController {
        let cvc = CameraViewController()
//            .posePredictor(PosePredictor())  // TODO
        cvc.posePredictor = posePredictor
        posePredictor.delegate = self.poseUpdate
        return cvc
    }
    
    public func updateUIViewController(_ uiViewController: CameraViewController, context: UIViewControllerRepresentableContext<CameraViewControllerRepresentable>) {
    }
}
