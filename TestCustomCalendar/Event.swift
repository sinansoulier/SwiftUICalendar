//
//  Event.swift
//  TestCustomCalendar
//
//  Created by François Soulier on 21/01/2023.
//

import Foundation
import SwiftUI

class Event: Equatable, Comparable, Hashable {
    var name: String
    var startDate: Date
    var endDate: Date
    var isEmpty: Bool
    var textColor: Color = .darkFirstColor
    var backgroundColor: Color = .firstColor
    
    init(name: String, startDate: Date, endDate: Date, isEmpty: Bool = false) {
        self.name = name
        self.startDate = startDate
        self.endDate = endDate
        self.isEmpty = isEmpty
    }
    
//    func overlaps(with event: Event) -> Bool {
//        let ret = (self.startDate == event.startDate && self.endDate == event.endDate) ||
//        self.startDate > event.startDate && self.startDate < event.endDate ||
//        self.endDate > event.startDate && self.endDate < event.endDate ||
//        self.startDate < event.endDate && self.endDate > event.endDate
//
//        return ret
//    }
    
    static func == (lhs: Event, rhs: Event) -> Bool {
        return lhs.name == rhs.name &&
        lhs.startDate == rhs.startDate &&
        lhs.endDate == rhs.endDate
    }
    
    static func < (lhs: Event, rhs: Event) -> Bool {
        return lhs.startDate < rhs.startDate
    }
    
    static func empty() -> Event {
        return Event(name: "", startDate: Date(), endDate: Date(), isEmpty: true)
    }
    
    static func emptyEventArray(ofSize size: Int) -> [Event] {
        return Array(0..<size).map { _ in return Event.empty() }
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.name)
    }
}
