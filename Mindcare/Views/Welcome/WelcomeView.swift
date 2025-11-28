//
//  WelcomeView.swift
//  Mindcare
//
//  Created for MindCareAI Project
//

import SwiftUI

struct WelcomeView: View {
    @State private var isVisible = false
    @State private var bearScale = 0.8
    @State private var textOpacity = 0.0
    
    var onFinished: () -> Void
    
    var body: some View {
        ZStack {
            // Background Color (Light Mint Green)
            Color(red: 0.91, green: 0.99, blue: 0.91)
                .ignoresSafeArea()
            
            VStack {
                Spacer()
                
                // Bear Doctor Image with Animation
                Image("logo-meesuk") // Asset: bear_logo
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 250, height: 250)
                    .scaleEffect(bearScale)
                    .opacity(isVisible ? 1 : 0)
                    .animation(.spring(response: 0.8, dampingFraction: 0.6), value: isVisible)
                
                // Title Section with Fade In
                ZStack(alignment: .topTrailing) {
                    Text("MEESUK")
                        .font(.system(size: 50, weight: .regular, design: .serif))
                        .foregroundColor(.black)
                    
                    Text("หมีสุข")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(.gray)
                        .offset(x: 35, y: -10)
                }
                .padding(.top, 10)
                .opacity(textOpacity)
                
                Spacer()
                
                // Kasetsart University Logo
                Image("logo-ku") // Asset: ku_logo
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 60)
                    .padding(.bottom, 40)
                    .opacity(textOpacity)
            }
        }
        .onAppear {
            // Start Animations
            withAnimation(.easeOut(duration: 1.0)) {
                isVisible = true
                bearScale = 1.0
            }
            
            withAnimation(.easeIn(duration: 1.0).delay(0.5)) {
                textOpacity = 1.0
            }
            
            // Auto navigate after delay
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.5) {
                withAnimation {
                    onFinished()
                }
            }
        }
    }
}

#Preview {
    WelcomeView(onFinished: {})
}
