//
//  CalendarDatesProvider.swift
//  TestCustomCalendar
//
//  Created by François Soulier on 18/01/2023.
//

import Foundation

class CalendarDatesProvider: ObservableObject {
    @Published public var dates: [Date] = [Date().startOfWeek()]
}
