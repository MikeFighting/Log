//
//  ContentView.swift
//  Log
//
//  Created by MikeWong on 2023/6/15.
//

import SwiftUI

struct EventsView: View {
    
    @EnvironmentObject var eventViewModel: EventViewModel
    @State var yearNum = 2023
    @State var monthNum = 6
    @State var showAddSheet = false
    @State var selectDay = Date()
    
    let weeks = ["周一", "周二", "周三", "周四", "周五", "周六", "周日"]
    
    var conlumns : [GridItem] {
        [
            GridItem(.flexible(), spacing: nil, alignment: nil),
            GridItem(.flexible(), spacing: nil, alignment: nil),
            GridItem(.flexible(), spacing: nil, alignment: nil),
            GridItem(.flexible(), spacing: nil, alignment: nil),
            GridItem(.flexible(), spacing: nil, alignment: nil),
            GridItem(.flexible(), spacing: nil, alignment: nil),
            GridItem(.flexible(), spacing: nil, alignment: nil)
        ]
    }
    
    var body: some View {
        
        ScrollView {
            HStack(alignment: .center) {
                Button {
                    switchToAnotherMonth(by: -1);
                } label: {
                    Image(systemName: "chevron.backward.circle")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(.yellow)
                }

                Text("\(formattedYear)年\(monthNum)月")
                    .font(.title2)
                    .fontWeight(.semibold)
                Button {
                    switchToAnotherMonth(by: 1);
                } label: {
                    Image(systemName: "chevron.right.circle")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(.yellow)
                }
            }
            .padding(5)
            HStack{
                Spacer().frame(width: 15)
                ForEach(weeks.indices, id: \.self){index in
                    Text(weeks[index])
                        .font(.title3)
                    if(index == 6) {
                        Spacer().frame(width: 15)
                    }else{
                        Spacer()
                    }
                }
            }
            .frame(maxWidth: .infinity)
            LazyVGrid(columns: conlumns) {
                ForEach(daysOneMonth, id: \.self) {
                    let date = $0
                    let day = getDayNumForDate(date: date)
                    let isToday = date.isEqule(date: Date())
                    VStack {
                        Text("\(day)")
                            .frame(width: 45,height: 45)
                            .font(.body)
                            .background {
                                if (isToday) {
                                    RoundedRectangle(cornerRadius: 5)
                                        .fill(Color.yellow)
                                }else{
                                    RoundedRectangle(cornerRadius: 5)
                                        .stroke()
                                        .foregroundColor(.yellow)
                                }
                            }
                            .foregroundColor(isToday ? .white : .black)
                            .fontWeight(isToday ? .bold : .medium)
                            .onTapGesture {
                                selectDay = date
                                print("clicked on \(date)")
                        }
                        HStack() {
                            Circle().frame(width: 4,height: 4)
                        }
                    }
                }
            }
            .padding(.leading,10)
            .padding(.trailing, 10)
            LazyVStack {
                Section(content: {
                    if eventViewModel.events.isEmpty {
                        HomeEmptyView()
                    } else {
                        ForEach(eventViewModel.events) { event in
                            HStack{
                                VStack(alignment:.leading, spacing: 10){
                                    Text(event.title)
                                    Text(event.detail)
                                }.padding(.horizontal, 12)
                                Spacer()
                            }.frame(width: .infinity)
                            
                        }
                    }
                }, header: {
                    HStack {
                        Text(getUserDay(date:selectDay))
                            .font(.title3)
                            .fontWeight(.medium)
                        Spacer()
                        Button {
                            showAddSheet = true
                            print("add one event")
                        } label: {
                            Image(systemName: "plus.circle")
                                .resizable()
                                .frame(width: 30, height: 30)
                                .foregroundColor(.yellow)
                        }
                    }.padding(10)
                })
            }
        }.onAppear(){
            let yearAndMonth = getYearAndMonth(forDate: Date())
            yearNum = yearAndMonth.year
            monthNum = yearAndMonth.month
            
        }.sheet(isPresented: $showAddSheet) {
            AddRecord()
        }
    }
    
    var  daysOneMonth: [Date] {
       return getDates() ?? []
    }
    
    var formattedYear: String {
        let numFormatter = NumberFormatter()
        numFormatter.numberStyle = .none
        let yearStr = numFormatter.string(from: yearNum as NSNumber)
        return yearStr ?? ""
    }
    
    fileprivate func switchToAnotherMonth(by: Int) {
        var nextMonth: Int = monthNum + by
        if(nextMonth == 0) {
            yearNum -= 1
            nextMonth = 12
        }
        if(nextMonth == 13) {
            yearNum += 1
            nextMonth = 1
        }
        monthNum = nextMonth
    }
    
    fileprivate func getUserDay(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy年MM月dd日"
        let dayStr = formatter.string(from: date)
        return dayStr
    }
    
    fileprivate func getDayNumForDate(date: Date) -> Int {
        
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "yyyy-MM-dd"
        let dateStr = dateFormater.string(from: date)
        let dayStr = dateStr.split(separator: "-").last ?? "-1"
        if let intValue = Int(dayStr) {
            return intValue
        }else{
            return -1
        }
    }
    
    fileprivate func getDates() -> [Date]? {
        let year = yearNum
        let month = monthNum
        let calendar = Calendar.current
        let dateComponents = DateComponents(year: year, month: month)
        guard let startDateOfMonth = calendar.date(from: dateComponents) else {
            return nil
        }
        
        let range = calendar.range(of: .day, in: .month, for: startDateOfMonth)
        let dates = range?.map({ day in
            return calendar.date(bySetting: .day, value: day, of: startDateOfMonth)!
        })
        
        return dates;
    }
    
    fileprivate func getYearAndMonth(forDate date: Date) -> (year: Int, month: Int) {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month], from: date)
        guard let year = components.year, let month = components.month else {
            fatalError("Fiald to extract month and day form the date.\(date)")
        }
        return (year, month)
    }
}

extension Date {
    func isEqule(date: Date) -> Bool {
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "yyyy-MM-dd"
        let current = dateFormater.string(from: self)
        let other = dateFormater.string(from: date)
        let isEqual = current == other
        debugPrint("current = \(current) and other = \(other) isEqual = \(isEqual)")
        return isEqual;
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        EventsView()
    }
}
