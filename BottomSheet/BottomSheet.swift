//
//  BottomSheet.swift
//  BottomSheet
//
//  Created by hanwool oh on 3/16/24.
//

import SwiftUI

struct BottomSheet<Content: View>: View {
    @State var opacity: CGFloat = 0
    @State var offset: Double = 1000
    @Binding var isPresented: Bool
    
    @State var backgroundColor: Color = .white
    
    @ViewBuilder var content: () -> Content

    @State private var contentHeight: CGFloat = 0
    
    @State var scrollEnabled = true
    var body: some View {
        GeometryReader { proxy in
            let _ = print(proxy.size)
            ZStack(alignment: .bottom) {
                Color.black.opacity(opacity)
                    .ignoresSafeArea()
                    .onTapGesture {
                        close()
                    }
                VStack {
                    ScrollView {
                        content()
                            .frame(maxWidth: .infinity)
                            .background( // calculate content height
                                GeometryReader { proxy in
                                    Color.clear.onAppear {
                                        print(proxy.size.height)
                                        contentHeight = proxy.size.height
                                    }
                                }
                            )
                    }
                    .scrollEnabled(scrollEnabled)
                    .background(backgroundColor)
                    
                }
                .offset(x: 0, y: offset)
                .frame(height: min(contentHeight, proxy.size.height))
                .onAppear {
                    withAnimation {
                        opacity = 0.3
                        offset = 0
                    }
                }
                .task {
                    scrollEnabled = contentHeight > proxy.size.height
                }
            }
            .clearModalBackground()
            .ignoresSafeArea()
        }
    }
    
    func close() {
        if #available(iOS 17.0, *) {
            withAnimation {
                opacity = 0
                offset = 1000
            } completion: {
                isPresented.toggle()
            }
        } else {
            withAnimation(.spring(duration: 0.3)) {
                opacity = 0
                offset = 1000
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: {
                isPresented.toggle()
            })
        }
    }
}

#Preview {
    BottomSheet(isPresented: .constant(true),
                content: {
            VStack {
                ForEach(0..<10, id: \.self) { index in
                    Text("Hello\(index)")
                }
            }
    })
}

extension ScrollView {
    //TODO: iOS 16 미만에서 스크롤 고정은 해결 못함.
    func scrollEnabled(_ isEnabled: Bool) -> some View {
        if #available(iOS 16.0, *) {
            return self.scrollDisabled(!isEnabled)
        } else {
            return self
        }
    }
}

extension View {
    func withoutAnimation(action: @escaping () -> Void) {
        var transaction = Transaction()
        transaction.disablesAnimations = true
        withTransaction(transaction) {
            action()
        }
    }
    
    // MARK: use this!
    func bottomSheet<Content>(isPresented: Binding<Bool>, @ViewBuilder content: @escaping () -> Content) -> some View where Content : View {
        self.fullScreenCover(isPresented: isPresented) {
            BottomSheet(isPresented: .constant(true),
                        content: content)
        }
    }
}

struct ClearBackgroundView: UIViewRepresentable {
    func makeUIView(context: Context) -> some UIView {
        let view = UIView()
        DispatchQueue.main.async {
            view.superview?.superview?.backgroundColor = .clear
        }
        return view
    }
    func updateUIView(_ uiView: UIViewType, context: Context) {
    }
}

struct ClearBackgroundViewModifier: ViewModifier {
    
    func body(content: Content) -> some View {
        content
            .background(ClearBackgroundView())
    }
}

extension View {
    func clearModalBackground()->some View {
        self.modifier(ClearBackgroundViewModifier())
    }
}
