//
//  LaunchView.swift
//  SwiftfulCrypto
//
//  Created by Vladyslav Mi on 04.04.2024.
//

import SwiftUI

struct LaunchView: View {
    
    @State private var loadingText: [String] = "Loading your portfolio...".map{String($0)}
    @State private var showLoadingText: Bool = false
    let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    
    @State private var counter: Int = 0
    @State private var loops : Int = 0
    @Binding var showLaunchView : Bool
    
    var body: some View {
        ZStack {
            Color.launch.background
                .ignoresSafeArea()
            Image("logo-transparent")
                .resizable()
                .frame(width: 100,height: 100)
            
            ZStack {
                if showLoadingText{
                    HStack(spacing : 0){
                        ForEach(loadingText.indices){ index in
                            Text(loadingText[index])
                                .font(.headline)
                                .fontWeight(.heavy)
                                .foregroundColor(Color.launch.accent)
                                .offset(y : counter == index ? -10 : 0)
                        }
                    }
                    .transition(AnyTransition.scale.animation(.easeIn))
                }
            }
            .offset(y : 70)
        }
        .onAppear{
            showLoadingText.toggle()
        }
        .onReceive(timer, perform: { _ in
            withAnimation(.spring()){
                
                let lastIndex = loadingText.count - 1
                if counter == lastIndex {
                    counter = 0
                    loops += 1
                    if loops >= 2{
                        showLaunchView = false
                    }
                } else{
                    counter += 1
                }
            }
        })
    }
}


struct LaunchView_Previews : PreviewProvider {
    static var previews: some View{
        NavigationView{
            LaunchView(showLaunchView: .constant(true))
                .navigationBarHidden(true)
        }
        .environmentObject(dev.homeVM)
    }
}
