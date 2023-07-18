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
        VStack(alignment: .trailing, spacing:5){
            Spacer().frame(height:30)
            HStack{
                Spacer()
                Text("还没有记录，赶快点击").font(.title2).fontWeight(.semibold).foregroundColor(.accentColor)
                Spacer()
                Text("☝️")
                    .font(animate ?.largeTitle : .title2)
                    .padding(.trailing, 15)
            }
        }
        .frame(maxWidth:.infinity)
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
