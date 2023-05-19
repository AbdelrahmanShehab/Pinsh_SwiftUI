//
//  ContentView.swift
//  Pinsh
//
//  Created by Abdelrahman Shehab on 04/04/2023.
//

import SwiftUI

struct ContentView: View {
    // MARK: -  PROPERTY
    @State private var isAnimating: Bool = true
    @State private var imageScale: CGFloat = 1
    @State private var imageOffset: CGSize = .zero
    @State private var isDrawerOpen: Bool = false
    
    let pages: [Page] = pagesData
    @State private var pageIndex: Int = 1
    
    // MARK: -  FUNCTION
    func restImage() {
        withAnimation(.spring()) {
            imageScale = 1
            imageOffset = .zero
        }
    }
    
    func currentPage() -> String {
        return pages[pageIndex - 1].imageName
    }
    
    // MARK: -  CONTENT
    var body: some View {
        
        NavigationView {
            
            ZStack{
                Color.clear
                
                // MARK: -  PAGE IMAGE
                
                Image(currentPage())
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .cornerRadius(10)
                    .padding()
                    .shadow(color: .black.opacity(0.2), radius: 12, x: 2, y: 2)
                    .offset(x: imageOffset.width, y: imageOffset.height)
                    .opacity(isAnimating ? 1 : 0)
                    .scaleEffect(imageScale)
                
                // MARK: -  TAP GESTURE
                
                    .onTapGesture(count: 2) {
                        if imageScale == 1 {
                            withAnimation(.spring()) {
                                imageScale = 5
                            }
                        } else {
                            withAnimation(.spring()) {
                                imageScale = 1
                            }
                        }
                    }
                    
                // MARK: -  DRAG GESTURE
                
                    .gesture(
                        DragGesture()
                            .onChanged({ value in
                                withAnimation(.linear(duration: 1)) {
                                    imageOffset = value.translation
                                }
                            })
                            .onEnded({ _ in
                                withAnimation(.linear(duration: 1)) {
                                    restImage()
                                }
                            })
                    )
                // MARK: -  MAGIFICATION
                    .gesture(
                        MagnificationGesture()
                            .onChanged({ value in
                                withAnimation(.linear(duration: 1)) {
                                    if imageScale >= 1 && imageScale <= 5 {
                                        imageScale = value
                                    } else if imageScale > 5 {
                                        imageScale = 5
                                    }
                                }
                            })
                            .onEnded({ _ in
                                withAnimation {
                                    if imageScale > 5 {
                                        imageScale = 5
                                    } else if imageScale <= 1 {
                                        restImage()
                                    }
                                }
                            })
                        
                    )
                
            } //: ZSTACK
            .navigationTitle("Pinsh & Zoom")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                withAnimation(.linear(duration: 4)) {
                    isAnimating = true
                }
            }
            // MARK: -  INFO PANEL
            .overlay (
                InfoPanelView(scale: imageScale, offset: imageOffset)
                    .padding(.horizontal)
                    .padding(.top, 30)
                ,alignment: .top
            )
            
            // MARK: -  CONTROLS
            .overlay (
                Group{
                    HStack{
                        
                        /// SCALE DOWN
                        Button {
                            withAnimation(.spring()) {
                                if imageScale > 1 {
                                    imageScale -= 1
                                    if imageScale <= 1 {
                                        restImage()
                                    }
                                }
                            }
                        } label: {
                            ControlImageView(icon: "minus.magnifyingglass")
                        }
                        
                        /// RESET
                        Button{
                            restImage()
                        } label: {
                            ControlImageView(icon: "arrow.up.left.and.down.right.magnifyingglass")
                        }
                        
                        /// SCALE UP
                        Button {
                            withAnimation(.spring()) {
                                if imageScale < 5{
                                    imageScale += 1
                                    
                                    if imageScale > 5 {
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
            // MARK: -  DRAWER
            .overlay (
                HStack(spacing: 12) {
                    // MARK: -  DRAWER HANDLER
                    Image(systemName:  isDrawerOpen ? "chevron.compact.right" : "chevron.compact.left" )
                        .resizable()
                        .scaledToFit()
                        .frame(height: 40)
                        .padding(8)
                        .foregroundStyle(.secondary)
                        .onTapGesture {
                            withAnimation(.easeOut) {
                                isDrawerOpen.toggle()
                            }
                        }
                    
                    // MARK: -  TUMBNAIL
                    ForEach(pages) { page in
                        Image(page.thumbnailName)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 80)
                            .cornerRadius(8)
                            .shadow(radius: 4)
                            .opacity(isDrawerOpen ? 1 : 0)
                            .animation(.easeOut(duration: 0.5), value: isDrawerOpen)
                            .onTapGesture {
                                isAnimating = true
                                pageIndex = page.id
                            }
                        }
                    
                    Spacer()
                    }
                        .padding(EdgeInsets(top: 16, leading: 8, bottom: 16, trailing: 8))
                        .background(.ultraThinMaterial)
                        .cornerRadius(12)
                        .opacity(isAnimating ? 1 : 0)
                        .frame(width: 260)
                        .padding(.top, UIScreen.main.bounds.height / 12)
                        .offset(x: isDrawerOpen ? 20 : 215)
                    ,alignment: .topTrailing
                    
            )
        }//: NAVIGATION
        .navigationViewStyle(.stack)
    }
}
// MARK: -  PREVIEW
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
