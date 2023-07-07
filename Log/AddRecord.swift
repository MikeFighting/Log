//
//  AddRecord.swift
//  Log
//
//  Created by MikeWong on 2023/6/18.
//

import SwiftUI
struct TagStyle:ViewModifier {
    let fill:Color
    func body(content: Content) -> some View {
        content
            .foregroundColor(.white)
            .padding(4)
            .background {
            Rectangle()
                    .fill(fill)
                    .cornerRadius(4)
        }
    }
}

struct AddRecord: View {
    
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.dismiss) var dismiss
    @State private var title:String = ""
    @State private var description: String = ""
    @State private var beginDate: Date = Date()
    @State private var endDate: Date = Date()
    
    var body: some View {
        VStack (){
            Text("添加记录")
                .font(.title2)
                .fontWeight(.semibold)
            
            TextField(text: $title) {
                Text("输入标题")
            }
            .submitLabel(.done)
            .padding(8)
            .cornerRadius(10)
            .background {
                RoundedRectangle(cornerRadius: 4)
                    .foregroundColor(Color(hue: 1.0, saturation: 0.009, brightness: 0.896))
                    
            }
            HStack{
                Text("记录详情:").font(.title3)
                Spacer()
            }
            TextEditor(text: $description)
                .scrollContentBackground(.hidden)
                .background(Color(hue: 1.0, saturation: 0.009, brightness: 0.896))
                .font(.system(size: 18))
                .lineSpacing(4)
                .cornerRadius(10)
                .frame(maxWidth:500,maxHeight: 250)
                .cornerRadius(10)
                .submitLabel(.done)
            HStack(spacing:10){
                
                DatePicker("开始", selection: $beginDate, displayedComponents: [.hourAndMinute])
                
                DatePicker("结束", selection: $endDate, in:beginDate...Date.distantFuture, displayedComponents: [.hourAndMinute]).onSubmit {
                    debugPrint("end Date is \(endDate)")
                }

                Spacer()
            }.frame(maxWidth:.infinity)

            HStack {
                Text("选择标签:").padding(.vertical, 8)
                Spacer()
            }
            
            HStack{
                Text("家务")
                    .modifier(TagStyle(fill:.red))
                Text("工作")
                    .modifier(TagStyle(fill:.blue))
                Button {
                    debugPrint("clicked plus button")
                } label: {
                    Image(systemName: "plus")
                        .font(.title3)
                        .fontWeight(.bold)
                }
                Spacer()
            }
            ColorPicker(selection: /*@START_MENU_TOKEN@*/.constant(.red)/*@END_MENU_TOKEN@*/, label: {
                Text("选择标签的颜色:")
            }).padding(.top, 10)
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
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .background {
                        RoundedRectangle(cornerRadius: 10.0)
                            .frame(width: 300, height: 60)
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
