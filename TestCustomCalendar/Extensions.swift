//
//  Extensions.swift
//  TestCustomCalendar
//
//  Created by François Soulier on 17/01/2023.
//

import Foundation
import SwiftUI

extension Date {
    func getWeekDays() -> [Date] {
        let dateInWeek = self

        let calendar = Calendar.current
        let dayOfWeek = calendar.component(.weekday, from: dateInWeek)
        let weekdays = calendar.range(of: .weekday, in: .weekOfYear, for: dateInWeek)!
        let days = (weekdays.lowerBound ..< weekdays.upperBound).compactMap { calendar.date(byAdding: .day, value: $0 - dayOfWeek, to: dateInWeek) }.map { Calendar.current.startOfDay(for: $0) }

        return days
    }

    func startOfWeek() -> Date {
        let components = Calendar.current.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)
        let weekStart = Calendar.current.date(from: components)!
        let weekStartWithOffset = Calendar.current.date(byAdding: .day, value: 1, to: weekStart)!
        return weekStartWithOffset
    }
    
    func startOfDay() -> Date {
        return Calendar.current.startOfDay(for: self)
    }
    
    func weeksRange() -> (startDate: Date, endDate: Date) {
        let cal = Calendar.current
        let (month, year) = (cal.component(.month, from: self), cal.component(.year, from: self))
        
        // September -> 9
        let endDateYear = year + (month == 9 ? 1 : 0)
        let components = DateComponents(year: endDateYear, month: 9)
        let endDate = cal.date(from: components)!
        let startDate = cal.date(byAdding: .year, value: -2, to: endDate)!
        
        return (startDate, endDate)
    }
    
    public func startOfPreviousWeek() -> Date {
        let startOfCurrentWeek = self.startOfWeek()
        let previousWeekStart = Calendar.current.date(byAdding: .weekOfYear, value: -1, to: startOfCurrentWeek)!
        return previousWeekStart
    }
    
    public func startOfNextWeek() -> Date {
        let startOfCurrentWeek = self.startOfWeek()
        let nextWeekStart = Calendar.current.date(byAdding: .weekOfYear, value: 1, to: startOfCurrentWeek)!
        return nextWeekStart
    }
    
    public func everyHourOfDay() -> [Date] {
        let startOfDay = Calendar.current.startOfDay(for: self)
        let startOfNextDay = Calendar.current.date(byAdding: .day, value: 1, to: startOfDay)!
        
        var dateIter = startOfDay
        var datesList: [Date] = [Date]()
        
        while dateIter <= startOfNextDay {
            datesList.append(dateIter)
            dateIter = Calendar.current.date(byAdding: .hour, value: 1, to: dateIter)!
        }
        
        return datesList
    }
    
    func getHourString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: self)
    }
    
    func timeElapsed(since date: Date) -> Double {
        return self.timeIntervalSince(date) / 3600
    }
    
    func hour() -> Int {
        return Calendar.current.component(.hour, from: self)
    }
    
    func minute() -> Int {
        return Calendar.current.component(.minute, from: self)
    }
    
    static func placeholderStartDates() -> [Date] {
        var dates: [Date] = [Date]()
        let startOfDay = Calendar.current.startOfDay(for: Date())
        
        for i in 0..<2 {
            let newDate = Calendar.current.date(byAdding: .minute, value: i * 0, to: startOfDay)!
            dates.append(newDate)
        }
        
//        for i in 0..<2 {
//            let newDate = Calendar.current.date(byAdding: .hour, value: 1, to: startOfDay)!
//            dates.append(newDate)
//        }
//
//        for i in 0..<1 {
//            let newDate = Calendar.current.date(byAdding: .minute, value: 90, to: startOfDay)!
//            dates.append(newDate)
//        }
//
//        for i in 0..<2 {
//            let newDate = Calendar.current.date(byAdding: .minute, value: i * 30, to: Calendar.current.date(byAdding: .hour, value: 2, to: startOfDay)!)!
//            dates.append(newDate)
//        }
        
        return dates
    }
    
    static func placeholderEndDates() -> [Date] {
        return Date.placeholderStartDates()
                   .map { Calendar.current.date(byAdding: .minute, value: 60, to: $0)! }
    }
    
    static func placeholderEvents() -> [[Event]] {
        let startDatesLists: [Date] = Date.placeholderStartDates().sorted()
        let endDatesLists: [Date] = Date.placeholderEndDates().sorted()
        
        var events: [Event] = [Event]()
        
        for i in 0..<startDatesLists.count {
            events.append(Event(name: "Event \(i.description)", startDate: startDatesLists[i], endDate: endDatesLists[i]))
        }
        
        events.sort()
        
        var groupEvents: [[Event]] = Dictionary(grouping: events, by: { $0.startDate.hour() }).values.sorted(by: { $0[0] < $1[0] })
        
        groupEvents.enumerated().forEach { (index, events) in
            let backgroundColor: Color = [Color.firstColor, Color.secondColor][index % 2]
            let textColor: Color = [Color.darkFirstColor, Color.darkSecondColor][index % 2]
            events.forEach { event in
                event.textColor = textColor
                event.name = "\(index.description)"
                event.backgroundColor = backgroundColor
            }
        }
        
        for i in 0..<groupEvents.count - 1 {
            for j in 0..<groupEvents[i].count {
                if Calendar.current.component(.minute, from: groupEvents[i][j].startDate) >= 45 {
                    let event = groupEvents[i].remove(at: j)
                    groupEvents[i + 1].append(event)
                    groupEvents[i + 1].sort()
                }
            }
        }
        
        return groupEvents
    }
}

extension String {
    func size(OfFont font: UIFont) -> CGSize {
        (self as NSString).size(withAttributes: [NSAttributedString.Key.font:font])
    }
}

extension Color {
    public static let firstColor: Color = Color(red: 1, green: 0, blue: 0, opacity: 0.2)
    public static let secondColor = Color(red: 0, green: 0, blue: 1, opacity: 0.2)
    public static let darkFirstColor: Color = Color(red: 1, green: 0, blue: 0, opacity: 1)
    public static let darkSecondColor = Color(red: 0, green: 0, blue: 1, opacity: 1)
}
