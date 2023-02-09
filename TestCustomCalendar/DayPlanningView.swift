//
//  DayPlanningView.swift
//  TestCustomCalendar
//
//  Created by François Soulier on 19/01/2023.
//

import SwiftUI

// MARK: - Saved version
struct DayPlanningView: View {
    @State var date: Date = Date()
    @State var eventsLists: [[Event]] = Date.placeholderEvents()

    @State var halfLineHeight: CGFloat = 0.0
    
    @State var everyHourOfDay: [Date] = [Date]()
    @State var maxTextWidth: CGFloat = 0.0
    
    private let uiFont: UIFont = UIFont.systemFont(ofSize: 12, weight: .regular)
    private let height: CGFloat = 50.0
    
    var body: some View {
        GeometryReader { proxy in
            ScrollView(showsIndicators: false) {
                ZStack {
                    HourDividers(with: proxy)
                        
                    EventsList(with: proxy)
                        .onAppear {
                            self.maxTextWidth = self.everyHourOfDay.map { $0.getHourString().size(OfFont: self.uiFont).width }.max()!
                        }
                }
                .frame(height: proxy.frame(in: .local).minY + (self.height + 4) * CGFloat(self.everyHourOfDay.count - 1) + 20)
                .onAppear {
                    self.everyHourOfDay = self.date.everyHourOfDay()
                    self.halfLineHeight = self.uiFont.lineHeight / 2
                    self.maxTextWidth = self.everyHourOfDay.map { $0.getHourString().size(OfFont: self.uiFont).width }.max()!
                }
            }
        }
    }
    
    @ViewBuilder
    private func HourDividers(with proxy: GeometryProxy) -> some View {
        ForEach(Array(0..<self.everyHourOfDay.count), id: \.self) { i in
            HStack(spacing: 5) {
                Text(self.everyHourOfDay[i].getHourString())
                    .font(Font(self.uiFont))
                    .foregroundColor(.gray)
                
                VStack {
                    Divider()
                }
            }.padding(.leading, 10)
            .position(x: proxy.frame(in: .global).midX, y: proxy.frame(in: .local).minY + (height + 4) * CGFloat(i))
        }.padding(.top, self.halfLineHeight)
            
    }
    
    @ViewBuilder
    private func EventContent(_ i: Int, event: Event) -> some View {
        VStack {
            HStack {
                Text(event.name)
                    .foregroundColor(event.textColor)
                Spacer()
            }.padding(5)
            Spacer()
        }
    }
    
    @ViewBuilder func EventsList(with proxy: GeometryProxy) -> some View {
        ForEach(Array(0..<self.eventsLists.count), id: \.self) { i in
            let eventsList: [Event] = self.eventsLists[i]
            ForEach(Array(0..<eventsList.count), id: \.self) { j in
                let event: Event = eventsList[j]
                if !event.isEmpty {
                    let N = eventsList.count
                    RoundedRectangle(cornerRadius: 5)
                        .frame(width: self.eventWidth(with: proxy,
                                                      N: N,
                                                      startDate: event.startDate),
                               height: self.eventHeight(startDate: event.startDate,
                                                        endDate: event.endDate))
                    
                        .foregroundColor(event.backgroundColor)
                        .overlay(content: {
                            EventContent(i, event: event)
                        })
                        .position(x: self.eventXPos(with: proxy,
                                                    at: j,
                                                    N: N,
                                                    startDate: event.startDate),
                                  y: self.eventYPos(i: event.startDate.hour(),
                                                    j: j,
                                                    with: proxy,
                                                    startDate: event.startDate,
                                                    endDate: event.endDate))
                }
            }
        }
    }
    
    private func eventXPos(with proxy: GeometryProxy, at j: Int = 0, N: Int, startDate: Date) -> CGFloat {
        let eventWidth: CGFloat = self.eventWidth(with: proxy, N: N, startDate: startDate)
        let padding: CGFloat = 4
        let floatJ: CGFloat = CGFloat(j)
        return proxy.frame(in: .global).minX +
                eventWidth / 2 +
                self.maxTextWidth +
                15.0 +
                eventWidth * floatJ +
                floatJ * (padding / 2)
    }
    
    private func eventYPos(i: Int = 0, j: Int = 0, with proxy: GeometryProxy, startDate: Date, endDate: Date) -> CGFloat {
        let padding: CGFloat = 2.0
        let timePadding: CGFloat = CGFloat(startDate.minute()) / 60.0
        return proxy.frame(in: .local).minY +
                self.halfLineHeight +
                self.eventHeight(startDate: startDate, endDate: endDate) / 2 +
                padding +
                CGFloat(i) * (self.height + 2 * padding) +
                timePadding * self.height
    }
    
    private func eventWidth(with proxy: GeometryProxy, N: Int, startDate: Date) -> CGFloat {
        let padding: CGFloat = 4
        return (proxy.frame(in: .global).width - self.maxTextWidth - 15.0) / CGFloat(N) -
                padding / 2
    }
    
    private func eventHeight(startDate: Date, endDate: Date) -> CGFloat {
        let timeDuration: CGFloat = endDate.timeElapsed(since: startDate)
        let padding: CGFloat = 2.0
        return self.height * timeDuration + padding * 2 * (timeDuration - 1)
    }
}

// MARK: - Preview
struct DayPlanningView_Previews: PreviewProvider {
    static var previews: some View {
        DayPlanningView(eventsLists: Date.placeholderEvents())
    }
}
