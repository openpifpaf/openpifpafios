//
//  ContentView.swift
//  openpifpafios
//
//  Created by Sven Kreiss on 24.10.20.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ZStack {
            CameraViewController()
                .edgesIgnoringSafeArea(.top)
            VStack {
                Spacer()
                Text("hello world")
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
