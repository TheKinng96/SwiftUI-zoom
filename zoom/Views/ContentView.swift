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
  @State private var isDrawerOpened: Bool = false
  
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
        Color.clear

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
        // MARK: - 3. MAGNIFICATION
          .gesture(
            MagnificationGesture()
              .onChanged{ value in
                withAnimation(.linear(duration: 1)) {
                  if value >= 1 && value <= 5 {
                    imageScale = value
                  } else if imageScale > 5 {
                    imageScale = 5
                  }
                }
              }
              .onEnded{ _ in
                if imageScale > 5 {
                  imageScale = 5
                } else if imageScale <= 1 {
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
      // MARK: - INFO PANEL
        .overlay(
          InfoPanelView(scale: imageScale, offset: imageOffset)
            .padding(.horizontal)
            .padding(.top, 30)
          ,alignment: .top
        )
      // MARK: - CONTROLS
        .overlay(
          Group {
            HStack {
              // SCALE DOWN
              Button {
                withAnimation(.spring()) {
                  if imageScale > 1 {
                    imageScale -= 1
                    
                    if imageScale >= 1 {
                      resetImageState()
                    }
                  }
                }
              } label: {
                ControlImageView(icon: "minus.magnifyingglass")
              }
              
              // RESET
              Button {
                //
              } label: {
                ControlImageView(icon: "arrow.up.left.and.down.right.magnifyingglass")
              }
              
              // SCALE UP
              Button {
                withAnimation(.spring()) {
                  if imageScale < 5 {
                    imageScale += 1
                    
                    if imageScale >= 5 {
                      imageScale = 5
                    }
                  }
                }
              } label: {
                ControlImageView(icon: "plus.magnifyingglass")
              }

            } //: CONTROLS
            .padding(EdgeInsets(top: 12, leading: 20, bottom: 12, trailing: 20))
            .background(.ultraThinMaterial)
            .cornerRadius(12)
            .opacity(isAnimating ? 1 : 0)
          }
            .padding(.bottom, 30)
          , alignment: .bottom
        )
      // MARK: - DRAWER
        .overlay(
          HStack(spacing: 12, content: {
            // MARK: - DRAWER HANDLE
            Image(systemName: isDrawerOpened ? "chevron.compact.right" : "chevron.compact.left")
              .resizable()
              .scaledToFit()
              .frame(height: 40)
              .padding(8)
              .foregroundColor(.secondary)
              .onTapGesture {
                withAnimation(.easeOut) {
                  isDrawerOpened.toggle()
                }
              }
            
            // MARK: - THUMBNAILS
            Spacer()
          }) //: DRAWER
            .padding(EdgeInsets(top: 16, leading: 8, bottom: 16, trailing: 8))
            .background(.ultraThinMaterial)
            .cornerRadius(12)
            .opacity(isAnimating ? 1 : 0)
            .frame(width: 260)
            .padding(.top, UIScreen.main.bounds.height / 12)
            .offset(x: isDrawerOpened ? 20 : 215)
          , alignment: .topTrailing
        )
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
