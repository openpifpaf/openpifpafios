//
//  PoseAnnotation.swift
//  openpifpafios
//
//  Created by Sven Kreiss on 12.11.20.
//

import CoreGraphics
import Foundation


struct Pose: Identifiable {
    let id = UUID()
    let keypoints: [CGPoint]
    let skeleton: [[Int]]
}
