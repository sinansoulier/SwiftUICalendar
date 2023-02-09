//
//  DaysList.swift
//  TestCustomCalendar
//
//  Created by François Soulier on 17/01/2023.
//

import SwiftUI

struct DaysList: View {
    @State var selectedDate: Date = Date().startOfDay()
    
    @State var tabViewWeekDate: Date = Date().startOfWeek()
    
    @State var weeks: [Date] = [Date]()
    
    @State var weekOffset: CGFloat = .zero
    @State var days: [Date] = [Date]()
    @State var didTapTodayButton: Bool = false
    
    var body: some View {
        VStack {
            Button("Back to today") {
                self.didTapTodayButton = true
            }
            
            Text(self.tabViewWeekDate.description)
            TabView(selection: self.$tabViewWeekDate) {
                ForEach(self.weeks, id: \.self) { date in
                    GeometryReader { proxy in
                        VStack {
                            WeekViewSelector(currentDate: date, selectedDate: self.$selectedDate)
                                .overlay(
                                    Color.clear
                                        .preference(key: WeekOffsetKey.self, value: proxy.frame(in: .global).minX)
                                        .frame(height: 70)
                                )
                                .onPreferenceChange(WeekOffsetKey.self) { newValue in
                                    withAnimation {
                                        self.weekOffset = newValue.truncatingRemainder(dividingBy: proxy.frame(in: .global).width)
                                    }
                                }
                            
                            Text(self.selectedDate.description)
                            TabView(selection: self.$selectedDate) {
                                ForEach(date.getWeekDays(), id: \.self) { day in
                                    DayPlanningView(date: day)
                                }
                            }
                            .tabViewStyle(.page(indexDisplayMode: .never))
                        }
                    }
                }
            }
            .id(self.weeks.count)
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .onChange(of: self.weekOffset) { newOffset in
                if newOffset == .zero {
                    withAnimation {
                        switch self.tabViewWeekDate {
                        case self.weeks.first:
                            self.weeks.insert(self.tabViewWeekDate.startOfPreviousWeek(), at: 0)
                        case self.weeks.last:
                            self.weeks.append(self.tabViewWeekDate.startOfNextWeek())
                        default:
                            break
                        }
                    }
                    
                    if !self.tabViewWeekDate.getWeekDays().contains(self.selectedDate) {
                        let value: Int = self.tabViewWeekDate > self.selectedDate ? 1 : -1
                        var component: Calendar.Component = .weekOfYear
                        let weekDays = self.selectedDate.startOfWeek().getWeekDays().sorted()
                        self.selectedDate = Calendar.current.date(byAdding: component, value: value, to: self.selectedDate)!
                    }
                }
            }
            .onChange(of: self.didTapTodayButton) { newValue in
                if newValue {
                    self.selectedDate = Date().startOfDay()
                    self.tabViewWeekDate = Date().startOfWeek()
                    self.didTapTodayButton = false
                }
            }
        }
        .onAppear {
            self.initWeeks()
        }
    }

    private func initWeeks() {
        let startOfPreviousWeek = self.selectedDate.startOfPreviousWeek()
        let startOfCurrentWeek = self.selectedDate.startOfWeek()
        let startOfNextWeek = self.selectedDate.startOfNextWeek()
        
        self.weeks.append(contentsOf: [startOfPreviousWeek, startOfCurrentWeek, startOfNextWeek].sorted())
        self.days = self.weeks.flatMap { $0.getWeekDays() }
    }
}

struct WeekOffsetKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

struct PlanningOffsetKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

#if DEBUG
struct DaysList_Previews: PreviewProvider {
    static var previews: some View {
        DaysList()
            .environmentObject(CalendarDatesProvider())
    }
}
#endif
