//
//  ContentView.swift
//  Log
//
//  Created by MikeWong on 2023/6/15.
//

import SwiftUI

struct Home: View {
    
    @EnvironmentObject var eventViewModel: EventViewModel
    @State private var yearNum = 2023
    @State private var monthNum = 6
    @State private var showAddSheet = false
    @State private var selectDay = Date()
    var emptyDate = Date.distantPast
    
    let weeks = ["一", "二", "三", "四", "五", "六", "日"]
    
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
        
        List {
            Section {} header: {
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
                .frame(maxWidth:.infinity)
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
                        let isEmptyDate = date == emptyDate
                        let day = getDayNumForDate(date: date)
                        let isToday = date.isEqule(date: Date())
                        let isSelectDay = date.isEqule(date: selectDay)
                        VStack {
                            Text("\(isEmptyDate ? "": String(day))")
                                .frame(width: 45,height: 45)
                                .font(.body)
                                .background {
                                    if (isToday) {
                                        Circle().fill(Color.accentColor)
                                    }else if(isSelectDay){
                                        Circle().fill(Color("theme_light_yellow"))
                                    }
                                }
                                .foregroundColor(Color("date_num_color"))
                                .fontWeight((isToday || isSelectDay) ? .bold : .medium)
                                .onTapGesture {
                                    selectDay = date
                                    print("clicked on \(date)")
                            }
                            HStack() {
                                let eventsOfDay = getEvents(for: date)
                                let actualNum = eventsOfDay.count
                                let num = actualNum >= 3 ? 3: actualNum
                                
                                ForEach(eventsOfDay[0..<num]) { event in
                                    let tag = getTag(name: event.tagId)
                                    Circle()
                                        .frame(width: 4,height: 4)
                                        .foregroundColor(Color.init(hex: tag.backgroundColor))
                                }
                            }.frame(height:6)
                        }
                    }
                }
                .padding(.leading,10)
                .padding(.trailing, 10)
            }
            Section {
                if getEvents(for: selectDay).isEmpty {
                    HomeEmptyView().listRowSeparator(.hidden)
                } else {
                    ForEach(getEvents(for: selectDay)) { event in
                        let tag = getTag(name: event.tagId)
                        HStack{
                            VStack(alignment:.leading, spacing: 10){
                                Text(event.title)
                                Text(event.detail)
                                    .textSelection(.enabled)
                            }
                            Spacer()
                            Text(tag.text)
                                .modifier(TagStyle(fill: Color.init(hex: tag.backgroundColor), textColor:  Color.init(hex: tag.textColor)))
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.horizontal, 12)
                        
                    }.onDelete { indexSets in
                        for i in indexSets {
                            let deleteId = getEvents(for: selectDay)[i].id
                            eventViewModel.deleteEvent(by: deleteId)
                        }
                    }
                    .onMove { indexSet, location in
                        eventViewModel.moveEvent(indexSet: indexSet, offset: location)
                    }
                }
            } header: {
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
            }
        
        }
        .listStyle(.plain)
        .onAppear(){
            let yearAndMonth = getYearAndMonth(forDate: Date())
            yearNum = yearAndMonth.year
            monthNum = yearAndMonth.month
            
        }.sheet(isPresented: $showAddSheet) {
            AddLog(beginDate: $selectDay, endDate: $selectDay)
        }
    }
    
    var daysOneMonth: [Date] {
       return getDates() ?? []
    }
    
    var formattedYear: String {
        let numFormatter = NumberFormatter()
        numFormatter.numberStyle = .none
        let yearStr = numFormatter.string(from: yearNum as NSNumber)
        return yearStr ?? ""
    }
    
    func getEvents(for date: Date) -> [EventModel] {
       return eventViewModel.getDayEvents(date: date)
    }
    
    fileprivate func getTag(name: String) -> TagModel {
        return eventViewModel.getTag(name: name)
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
        var dates:[Date]? = range?.map({ day in
            return calendar.date(bySetting: .day, value: day, of: startDateOfMonth)!
        })
        
        var comps:DateComponents = DateComponents()
        var monthBeginIndex = 0;
        if let firstDay = dates?.first {
            comps = calendar.dateComponents([.weekday], from: firstDay)
            //["星期日","星期一","星期二","星期三","星期四","星期五","星期六"]
            /*
             第几天  空几天
             1 --> 6
             2 --> 0
             3 --> 1
             4 --> 2
             5 --> 3
             6 --> 4
             7 --> 5
             规律：(i + 5) % 7
             */
            monthBeginIndex = (comps.weekday! + 5) % 7
            print("comps.weekday = \(String(describing: comps.weekday))")
        }
        for _ in 0..<monthBeginIndex {
            dates?.insert(emptyDate, at: 0)
        }
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
        return isEqual;
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
