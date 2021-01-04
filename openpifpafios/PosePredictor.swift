//
//  PosePredictor.swift
//  openpifpafios
//
//  Created by Sven Kreiss on 14.11.20.
//

import CoreGraphics
import CoreML
import Foundation
import Vision

class PredictorInput: MLFeatureProvider {
    var featureNames: Set<String> {
        return ["image"]
    }
    private let image: CGImage
    private let imageSize: CGSize
    
    init(image: CGImage, size: CGSize) {
        self.image = image
        self.imageSize = size
    }

    func featureValue(for featureName: String) -> MLFeatureValue? {
        return try? MLFeatureValue(cgImage: image,
                                   pixelsWide: Int(imageSize.width),
                                   pixelsHigh: Int(imageSize.height),
                                   pixelFormatType: image.pixelFormatInfo.rawValue,
                                   options: [.cropAndScale: VNImageCropAndScaleOption.scaleFill.rawValue])
    }
}

class PosePredictor {
    private let model: MLModel = try! fused9test().model
    private let size = CGSize(width: 353, height: 353)
    private let stride = 8.0
    var delegate: (([Pose]) -> Void)? = nil
    
    func singlePose(_ cif: MLMultiArray) -> Pose {
        var confidences = [Double](repeating: 0.0, count: cif.shape[1].intValue)
        var x = [Double](repeating: 0.0, count: cif.shape[1].intValue)
        var y = [Double](repeating: 0.0, count: cif.shape[1].intValue)
        for jIndex in 0..<cif.shape[1].intValue {
            for yIndex in 0..<cif.shape[3].intValue {
                for xIndex in 0..<cif.shape[4].intValue {
                    let currentConfidence = cif[ [0, jIndex, 0, yIndex, xIndex] ]

                    if currentConfidence > confidences[jIndex] {
                        confidences[jIndex] = currentConfidence
                        x[jIndex] = cif[ [0, jIndex, 1, yIndex, xIndex] ]
                        y[jIndex] = cif[ [0, jIndex, 2, yIndex, xIndex] ]
                    }
                }
            }
        }
        return Pose(
            keypoints: (0..<cif.shape[1].intValue).map { Keypoint(c: confidences[$0], x: x[$0] * stride, y: y[$0] * stride) },
            skeleton: [[0, 1], [0, 2]]
        )
    }
    
    func predict(_ image: CGImage) {
        guard let prediction = try? self.model.prediction(from: PredictorInput(image: image, size: self.size)) else {
            return
        }

        let cif = prediction.featureValue(for: "cif_head")!.multiArrayValue
        let pose = self.singlePose(cif!)

        guard self.delegate != nil else { return }
        self.delegate!([pose])
    }
}


// subscript for MLMultiArray expects [NSNumber] as input and returns NSNumber
// but we would rather work with [Int] and Double
extension MLMultiArray {
    subscript(index: [Int]) -> Double {
        return self[index.map { NSNumber(value: $0) } ] as! Double
    }
}
