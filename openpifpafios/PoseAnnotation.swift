//
//  PoseAnnotation.swift
//  openpifpafios
//
//  Created by Sven Kreiss on 12.11.20.
//

import Foundation


struct Keypoint {
    var c: Double
    var x: Double
    var y: Double
}


struct Pose: Identifiable {
    let id = UUID()
    var keypoints: [Keypoint]
    let skeleton: [[Int]]
}
