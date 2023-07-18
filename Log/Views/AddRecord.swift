//
//  AddRecord.swift
//  Log
//
//  Created by MikeWong on 2023/6/18.
//

import SwiftUI
import WrappingHStack


struct AddRecord: View {
    
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var eventViewModel: EventViewModel
    
    @Binding public var beginDate: Date
    @Binding public var endDate: Date
    
    @State private var title:String = ""
    @State private var description: String = ""
    @State private var showCustomTag = false
    
    @State private var showCommitAlert = false
    @State private var commitAlertText = ""
    
    @State private var newTagName: String = ""
    @State private var newTagBgCoor: Color = .blue
    @State private var newTagTextColor: Color = .white
    @State private var selectedTag = ""
    
    var body: some View {
        VStack (){
            Text("添加记录")
                .font(.title2)
                .fontWeight(.semibold)
            
            TextField(text: $title) {
                Text("请输入标题")
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
                DatePicker(selection: $beginDate, displayedComponents: [.hourAndMinute]) {
                    Text("开始").frame(maxWidth:.infinity, alignment: .leading)
                }.frame(maxWidth:.infinity, alignment: .leading)
                
                Spacer().frame(width:50)
                DatePicker("结束", selection: $endDate, in:beginDate...Date.distantFuture, displayedComponents: [.hourAndMinute]).onSubmit {
                    debugPrint("end Date is \(endDate)")
                }
                
                
            }.frame(maxWidth:.infinity)
            
            HStack {
                Text("选择标签:").padding(.vertical, 8)
                Spacer()
            }
            
            WrappingHStack(allTags(), id: \.self){ tag in
                HStack(spacing:5) {
                    if(tag.text == "+") {
                        Button {
                            showCustomTag = true
                        } label: {
                            Image(systemName: "plus")
                                .font(.title3)
                                .fontWeight(.regular)
                                .overlay {
                                    RoundedRectangle(cornerRadius: 5)
                                        .stroke(Color.accentColor, lineWidth: 1)
                                }
                        }
                    }else{
                        Text(tag.text)
                            .modifier(TagStyle(fill: Color.init(hex: tag.backgroundColor),
                                               textColor:  Color.init(hex: tag.textColor)))
                        Image(systemName: selectedTag == tag.text ? "checkmark.square" : "square")
                            .font(.system(size: 20))
                            .fontWeight(.medium)
                            .foregroundColor(Color.init(hex: tag.backgroundColor))
                    }
                }
                .onTapGesture(perform: {
                    selectedTag = tag.text
                }).padding(5)
            }
            Spacer()
            Button {
                let validateResult = isValidat()
                if(validateResult.result == false) {
                    showCommitAlert = true
                    commitAlertText = validateResult.msg
                    return
                }
                
                eventViewModel.addEvent(title: title, detail: description, tagId: selectedTag, begin: beginDate, end: endDate)
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
                    .frame(width: 300, height: 50)
                    .background {
                        RoundedRectangle(cornerRadius: 10.0)
                    }
            }
        }
        .alert(isPresented: $showCommitAlert, content: {
            Alert(title: Text(commitAlertText), dismissButton:.destructive(Text("确定")))
        })
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
    
    private func allTags() -> [TagModel] {
        var tags = eventViewModel.tags
        let fakeTag = TagModel(text: "+", textColor: "0xFFF000", backgroundColor: "0xFFF000")
        tags.append(fakeTag)
        return tags
    }
    
    private func isValidat() -> (result: Bool, msg: String) {
        if title.isEmpty {
            return (false, "请输入标题")
        }
        if selectedTag.isEmpty {
            return (false, "请选择标签")
        }
        if description.isEmpty {
            return (false, "请输入详情")
        }
        
        return (true, "")
    }
}

extension AddRecord {
    var colums:[GridItem] {
        [
            GridItem(.adaptive(minimum: 80), spacing: 10)
        ]
    }
}

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

//struct AddRecord_Previews: PreviewProvider {
//    @State var begin:Date = Date()
//    static var previews: some View {
//        AddRecord(beginDate: $begin, endDate: $begin)
//    }
//}
