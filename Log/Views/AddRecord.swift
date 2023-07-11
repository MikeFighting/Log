//
//  AddRecord.swift
//  Log
//
//  Created by MikeWong on 2023/6/18.
//

import SwiftUI

struct TagStyle:ViewModifier {
    let fill:Color
    var textColor:Color = .white
    init(fill: Color, textColor:Color = .white) {
        self.fill = fill
        self.textColor = textColor
    }
    
    func body(content: Content) -> some View {
        content
            .foregroundColor(textColor)
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
    @State private var showCustomTag = false
    
    @State private var newTagName: String = ""
    @State private var newTagBgCoor: Color = .blue
    @State private var newTagTextColor: Color = .white
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
                    .foregroundColor(Color("input_text_bg_color"))
            }
            HStack{
                Text("记录详情:").font(.title3)
                Spacer()
            }
            TextEditor(text: $description)
                .scrollContentBackground(.hidden)
                .background(Color("input_text_bg_color"))
                .font(.system(size: 18))
                .lineSpacing(4)
                .cornerRadius(10)
                .frame(maxWidth:500,maxHeight: 250)
                .cornerRadius(10)
                .submitLabel(.done)
                .onChange(of: description) { _ in
                    if !description.filter({ $0.isNewline }).isEmpty {
                        hideKeyboard()
                    }
                }
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
                    showCustomTag = true
                } label: {
                    Image(systemName: "plus")
                        .font(.title3)
                        .fontWeight(.bold)
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
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .background {
                        RoundedRectangle(cornerRadius: 10.0)
                            .frame(width: 300, height: 50)
                    }
        }
        }
        .padding(10)
        .sheet(isPresented:$showCustomTag, content: {
                AddTag(showAddTag: $showCustomTag, newTagName: $newTagName, newTagTextColor: $newTagTextColor, newTagBgColor: $newTagBgCoor)

            })
    }
    
    // Function to hide the keyboard
    private func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder),
                                        to: nil,
                                        from: nil,
                                        for: nil)
    }
}

struct AddRecord_Previews: PreviewProvider {
    static var previews: some View {
        AddRecord()
    }
}