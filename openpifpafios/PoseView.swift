//
//  PoseView.swift
//  openpifpafios
//
//  Created by Sven Kreiss on 12.11.20.
//

import SwiftUI

struct Skeleton: Shape {
    let pose: Pose
    
    func path(in rect: CGRect) -> Path {
        var path = Path()

        for connection in pose.skeleton {
            path.move(to: pose.keypoints[connection[0]])
            path.addLine(to: pose.keypoints[connection[1]])
        }
        
        return path
    }
}

struct PoseView: View {
    let kpSize: CGFloat = 10.0
    var poses: [Pose]
    
    var body: some View {
        ZStack {
            ForEach(poses) { pose in
                Skeleton(pose: pose)
                    .stroke(lineWidth: 5)
                    .foregroundColor(.green)
                ForEach(0 ..< pose.keypoints.count) { keypoint_i in
                    let keypoint = pose.keypoints[keypoint_i]
                    Circle()
                        .fill(Color.orange)
                        .frame(width: kpSize, height: kpSize)
                        .position(x: keypoint.x, y: keypoint.y)
                }
            }
        }
    }
}

struct PoseView_Previews: PreviewProvider {
    static var previews: some View {
        let examplePose = Pose(
            keypoints: [
                CGPoint(x: 50, y: 50),
                CGPoint(x: 10, y: 10),
                CGPoint(x: 100, y: 10),
            ],
            skeleton: [[0, 1], [1, 2]]
        )
        PoseView(poses: [examplePose])
    }
}
