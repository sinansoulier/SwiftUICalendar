//
//  ListDaySelector.swift
//  TestCustomCalendar
//
//  Created by François Soulier on 17/01/2023.
//

import SwiftUI

struct WeekViewSelector: View {
    @State var currentDate: Date = Date()
    @Binding var selectedDate: Date
    @State private var weekStarts: [Date] = [Date]()
    
    var body: some View {
        HStack {
            ForEach(self.weekStarts, id: \.self) { date in
                DaySelector(date: date, selectedDate: $selectedDate)
                if date != self.weekStarts.last {
                    Spacer()
                }
            }
        }
        .padding([.leading, .trailing])
        .onAppear {
            self.weekStarts = self.currentDate.getWeekDays()
        }
    }
}

struct WeekViewSelector_Previews: PreviewProvider {
    static var previews: some View {
        WeekViewSelector(selectedDate: Binding(get: { return Date() }, set: { _ in return }))
    }
}
