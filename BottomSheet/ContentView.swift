//
//  ContentView.swift
//  BottomSheet
//
//  Created by hanwool oh on 3/15/24.
//

import SwiftUI

struct ContentView: View {
    @State var isPresented: Bool = false
    
    @State var isLongPresented: Bool = false
    var body: some View {
        VStack {
            Button {
                withoutAnimation {
                    isPresented.toggle()
                }
            } label: {
                Image(systemName: "globe")
                    .imageScale(.large)
                    .foregroundStyle(.tint)
                Text("짧은 바텀시트")
            }
            
            Button {
                withoutAnimation {
                    isLongPresented.toggle()
                }
            } label: {
                Image(systemName: "globe")
                    .imageScale(.large)
                    .foregroundStyle(.tint)
                Text("긴 바텀시트")
            }
        }
        .fullScreenCover(isPresented: $isPresented, content: {
            BottomSheet(isPresented: $isPresented) {
                ForEach(0..<10, id: \.self) { _ in
                    Text("Hello")
                }
            }
        })
//        .fullScreenCover(isPresented: $isLongPresented, content: {
//            BottomSheet(isPresented: $isLongPresented) {
//                ForEach(0..<100, id: \.self) { _ in
//                    Text("Hello")
//                }
//            }
//        })
        .bottomSheet(isPresented: $isLongPresented) {
            ForEach(0..<100, id: \.self) { index in
                Text("Hello \(index)")
            }
        }
    }
}

#Preview {
    ContentView()
}
