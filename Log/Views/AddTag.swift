//
//  AddTag.swift
//  Log
//
//  Created by Mike Wong on 2023/7/9.
//

import SwiftUI

struct AddTag: View {
    
    @Binding var showAddTag:Bool
    @Binding var newTagName:String
    @Binding var newTagTextColor:Color
    @Binding var newTagBgColor:Color
    
    var body: some View {
        VStack(alignment:.leading){
            HStack{
                Spacer()
                Text("添加标签")
                    .font(.title3)
                    .fontWeight(.medium)
                    .padding(.top, 10)
                Spacer()
            }
            TextField(text: $newTagName) {
                Text("输入标签文字")
            }
            .padding(9)
            .submitLabel(.done)
                .background {
                    RoundedRectangle(cornerRadius: 4)
                        .foregroundColor(Color("input_text_bg_color"))
                        
                }

            ColorPicker(selection: $newTagBgColor, label: {
                Text("选择标签背景色:")
            }).padding(.top, 10)
            ColorPicker(selection: $newTagTextColor) {
                Text("选择文字颜色:")
            }
            HStack{
                if(newTagName.isEmpty == false){
                    Text("标签效果")
                    Text(newTagName).modifier(TagStyle(fill: newTagBgColor, textColor: newTagTextColor))
                }
            }
            Spacer()
            HStack {
                Spacer()
                Button {
                    showAddTag = false
                } label: {
                    Text("完成")
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .background {
                            RoundedRectangle(cornerRadius: 10.0)
                                .frame(width: 300, height: 50)
                        }
            }
                Spacer()
            }
        }
        .padding(.horizontal, 10)
        .presentationDetents([.medium])
    }
}

struct AddTag_Previews: PreviewProvider {
    static var previews: some View {
        
        @State var showCustomTag = false
        @State var newTagName: String = ""
        @State var newTagTextColor: Color = .white
        @State var newTagBgColor: Color = .blue
        AddTag(showAddTag: $showCustomTag, newTagName: $newTagName, newTagTextColor:$newTagTextColor, newTagBgColor:$newTagBgColor)
    }
}
