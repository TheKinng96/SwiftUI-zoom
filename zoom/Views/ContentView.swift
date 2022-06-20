//
//  ContentView.swift
//  zoom
//
//  Created by Feng Yuan Yap on 2022/06/20.
//

import SwiftUI

struct ContentView: View {
  // MARK: - Property
  @State private var isAnimating: Bool = false
  @State private var imageScale: CGFloat = 1
  @State private var imageOffset: CGSize = .zero
  
  // MARK: - Function
  var getOpacity: Double {
    return isAnimating ? 1 : 0
  }
  
  func resetImageState() {
    return withAnimation(.spring()) {
      imageOffset = .zero
      imageScale = 1
    }
  }
  
  // MARK: - Content
  
  var body: some View {
    NavigationView {
      ZStack {
        // MARK: - Image
        Image("magazine-front-cover")
          .resizable()
          .aspectRatio(contentMode: .fit)
          .cornerRadius(10)
          .padding()
          .shadow(color: .black.opacity(0.2), radius: 12, x: 2, y: 2)
          .opacity(getOpacity)
          .offset(x: imageOffset.width, y: imageOffset.height)
          .scaleEffect(imageScale)
        // MARK: - 1. TAP GESTURE
          .onTapGesture(count: 2, perform: {
            if imageScale == 1 {
              withAnimation(.spring()) {
                imageScale = 5
              }
            } else {
              resetImageState()
            }
          })
        // MARK: - 2. DRAG GESTURE
          .gesture(
            DragGesture()
              .onChanged { value in
                withAnimation(.linear(duration: 1)) {
                  imageOffset = value.translation
                }
              }
              .onEnded { _ in
                if imageScale <= 1 {
                  resetImageState()
                }
              }
          )
        
      } // :ZSTACK
      .navigationTitle("Pinch & Zoom")
      .navigationBarTitleDisplayMode(.inline)
      .onAppear {
        withAnimation(.linear(duration: 1)) {
          isAnimating = true
        }
      }
    } // :NAVIGATION
    .navigationViewStyle(.stack)
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
      .preferredColorScheme(.dark)
  }
}
