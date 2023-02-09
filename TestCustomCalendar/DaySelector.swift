//
//  DaySelector.swift
//  TestCustomCalendar
//
//  Created by François Soulier on 17/01/2023.
//

import SwiftUI

struct DaySelector: View {
    @State var date: Date
    @Binding var selectedDate: Date
    @State private var shouldHighlightButton: Bool = false
    
    private let currentDayColorSelector: Color = .red
    
    var body: some View {
        VStack(spacing: 5) {
            Text(self.getShortDayKey())
                .font(.system(size: 12))
            Button(self.getDayNumber()) {
                self.selectedDate = self.date
            }
            .foregroundColor(self.dayKeyColor)
            .padding(10)
            .background(self.dayNumberColor)
            .clipShape(Circle())
        }
        .onAppear {
            self.updateDaySelection()
        }
        .onChange(of: self.selectedDate) { newValue in
            self.updateDaySelection()
        }
    }
    
    private var dayKeyColor: Color {
        guard !self.shouldHighlightButton else { return .white }
        return self.dateIsToday() ? self.currentDayColorSelector : .black
    }
    
    private var dayNumberColor: Color {
        guard self.shouldHighlightButton else { return .clear }
        return self.dateIsToday() ? self.currentDayColorSelector : .black
    }
    
    private func getShortDayKey() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E"
        return String(dateFormatter.string(from: self.date).first!)
    }
    
    private func getDayNumber() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd"
        return dateFormatter.string(from: self.date)
    }
    
    private func dateIsToday() -> Bool {
        return Calendar.current.isDate(self.date, inSameDayAs: Date())
    }
    
    private func datesAreOnSameDay(_ firstDate: Date, _ secondDate: Date) -> Bool {
        return Calendar.current.isDate(firstDate, inSameDayAs: secondDate)
    }
    
    private func updateDaySelection() {
        withAnimation(.easeInOut(duration: 0.1)) {
            self.shouldHighlightButton = self.datesAreOnSameDay(self.date, self.selectedDate)
        }
    }
}

struct DaySelector_Previews: PreviewProvider {
    static var previews: some View {
        DaySelector(date: Date(), selectedDate: Binding(get: { return Date() }, set: { _ in return }))
        DaySelector(date: Calendar.current.date(byAdding: .day, value: 2, to: Date())!, selectedDate: Binding(get: { return Date() }, set: { _ in return }))
    }
}
