//
//  AddRecord.swift
//  Log
//
//  Created by MikeWong on 2023/6/18.
//

import SwiftUI

struct AddRecord: View {
    
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.dismiss) var dismiss
    @State private var title:String = ""
    @State private var description: String = "我是一个描述"
    @State private var beginDate: Date = Date()
    @State private var endDate: Date = Date()
    
    var body: some View {
        VStack {
            Text("添加记录")
                .font(.title2)
                .fontWeight(.semibold)
            
            TextField(text: $title) {
                Text("输入标题")
            }
            .padding(8)
            .cornerRadius(10)
            .background {
                RoundedRectangle(cornerRadius: 4).foregroundColor(Color.gray)
            }
            
            TextEditor(text: $description)
                .scrollContentBackground(.hidden)
                .background(Color.secondary)
                .font(.system(size: 18))
                .lineSpacing(4)
                .cornerRadius(10)
                .frame(maxWidth:500,maxHeight: 250)
                .cornerRadius(5)
            HStack(spacing:10){
                
                DatePicker("开始", selection: $beginDate, displayedComponents: [.hourAndMinute])
                
                DatePicker("结束", selection: $endDate, in:beginDate...Date.distantFuture, displayedComponents: [.hourAndMinute]).onSubmit {
                    debugPrint("end Date is \(endDate)")
                }

                Spacer()
            }.frame(maxWidth:.infinity)

            HStack {
                Text("选择标签:")
                Spacer()
            }
            
            HStack{
                Text("家务")
                Text("工作")
                Button {
                    debugPrint("clicked plus button")
                } label: {
                    Image(systemName: "plus")
                }
                Spacer()
            }
            Spacer()
            Button {
                debugPrint("end Date is \(endDate)")
                if #available(iOS 15, *) {
                    dismiss()
                } else {
                    presentationMode.wrappedValue.dismiss()
                }
            } label: {
                
                Text("完成")
                    .foregroundColor(.white)
                    .background {
                        RoundedRectangle(cornerRadius: 10.0)
                            .frame(width: 100, height: 40)
                    }
        }
        }.padding(10)
    }
}

struct AddRecord_Previews: PreviewProvider {
    static var previews: some View {
        AddRecord()
    }
}
