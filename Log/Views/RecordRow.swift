//
//  RecordRow.swift
//  Log
//
//  Created by MikeWong on 2023/6/18.
//

import SwiftUI

struct RecordRow: View {
    
    var title: String
    var subTitle: String
    var beginTime: Date
    var endTime: Date
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5,content: {
            Text(title)
                .font(.title2)
                .fontWeight(.medium)
            Text(subTitle)
                .font(.subheadline)
                .foregroundColor(.primary)
            HStack{
                    Image(systemName: "clock")
                    Text("\(dateFormattered(beginTime)) - \(dateFormattered(endTime))")
                
                Spacer()
            }
            .foregroundColor(.secondary)
            .padding(.top, 5)
        }).padding(.leading, 10)
    }
    
    fileprivate func dateFormattered(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        let dateString = dateFormatter.string(from: date)
        return dateString
    }
}


struct RecordRow_Previews: PreviewProvider {
    static var previews: some View {
        RecordRow(title: "看书", subTitle: "看明朝那些事", beginTime: Date.distantPast, endTime: Date.distantFuture)
    }
}
