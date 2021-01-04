//
//  ContentView.swift
//  openpifpafios
//
//  Created by Sven Kreiss on 24.10.20.
//

import SwiftUI

struct ContentView: View {
    @State private var poses: [Pose] = [
        Pose(
            keypoints: [
                Keypoint(c: 1.0, x: 10, y: 10),
                Keypoint(c: 1.0, x: 100, y: 10),
                Keypoint(c: 1.0, x: 50, y: 50)
            ],
            skeleton: [[0, 1], [0, 2]]
        )
    ]
    @State private var fps = 0.0
    private let posePredictor = PosePredictor()
    
    var body: some View {
        ZStack {
            CameraViewControllerRepresentable(posePredictor: posePredictor, poses: $poses, poseUpdateFPS: $fps)
                .edgesIgnoringSafeArea(.top)
            PoseView(poses: $poses)
            VStack {
                Spacer()
                Text("hello world: " + String(format: "%.1f", fps) + " FPS")
                    .foregroundColor(.white)
                    .frame(minWidth: 200)
                    .padding(.horizontal)
                    .background(
                        RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/)
                    )
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
