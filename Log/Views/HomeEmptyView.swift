//
//  HomeEmptyView.swift
//  Log
//
//  Created by Mike Wong on 2023/7/9.
//

import SwiftUI

struct HomeEmptyView: View {
    @State var animate:Bool = false
    var body: some View {
        VStack(spacing:5){

            Text("还没有记录事项哦~").font(.title2)
            HStack{
                Text("赶快点击").font(.title2)
                Text("☝️")
                    .font(animate ?.largeTitle : .title2 )
            }
            HStack{
                Text("添加吧").font(.title2)
                Text("😍")
                    .font(animate ? .largeTitle : .title2)
            }
        }
        .onAppear(perform: {
            withAnimation(
                .easeInOut(duration: 1)
                .repeatForever()) {
                    animate.toggle()
                }
        })
    }
}

struct HomeEmptyView_Previews: PreviewProvider {
    static var previews: some View {
        HomeEmptyView()
    }
}
