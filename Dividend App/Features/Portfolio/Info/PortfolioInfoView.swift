//
//  PortfolioInfoView.swift
//  Dividend App
//
//  Created by Kevin Li on 12/31/19.
//  Copyright © 2019 Kevin Li. All rights reserved.
//

import SwiftUI
import SunburstDiagram

struct PortfolioInfoView: View {
    @SwiftUI.Environment(\.editMode) var editMode
    @Binding var showEditInfo: Bool
    @Binding var selectedIndex: Int
    @Binding var showSectorInfo: Bool
    
    let portfolioStocks: [PortfolioStock]
    let upcomingDates: [Date]
    let onDelete: (IndexSet) -> Void
    let sunburstConfig: SunburstConfiguration
    
    var body: some View {
        ZStack {
            BlurView(style: .systemMaterialDark)
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 0) {
                HStack {
                    TitleView(title: showSectorInfo ? "Sector Breakdown" : "Portfolio Info")
                        .blur(radius: (editMode?.wrappedValue == EditMode.active && !showSectorInfo) ? 20 : 0)
                        .animation(.default)
                    
                    if !showSectorInfo {
                        EditButton()
                            .padding()
                            .disabled(portfolioStocks.count == 0 ? true : false)
                    }
                }
                
                if showSectorInfo {
                    SunburstView(configuration: sunburstConfig)
                        .colorScheme(.dark)
                } else {
                    ListHeader(leadingText: "Name", trailingText: "Start Div / Next Div Date")
                    if portfolioStocks.count == 0 || portfolioStocks.count != upcomingDates.count {
                        ZStack {
                            Text("Add stocks to display")
                                .foregroundColor(Color("textColor"))
                                .font(.headline)
                                .italic()
                            
                            List {
                                ForEach(PortfolioStock.sample.indexed(), id: \.1.self) { index, stock in
                                    PortfolioInfoRow(stock: stock, date: UpcomingDividend.sample[index])
                                }
                            }
                            .opacity(0.3)
                            .disabled(true)
                        }
                        Spacer()
                    } else {
                            List {
                                ForEach(portfolioStocks.indexed(), id: \.1.self) { index, stock in
                                    Button(action: {
                                        self.selectedIndex = index
                                        self.showEditInfo = true
                                    }) {
                                        PortfolioInfoRow(stock: stock, date: self.upcomingDates[index])
                                    }
                                }
                                .onDelete(perform: onDelete)
                            }
                        }
                }
            }
            SunburstDiagramButton(showSectorInfo: $showSectorInfo)
                .disabled(portfolioStocks.count == 0 ? true : false)
        }
    }
}

struct PortfolioInfoView_Previews: PreviewProvider {
    static var previews: some View {
        PortfolioInfoView(showEditInfo: .constant(false), selectedIndex: .constant(0), showSectorInfo: .constant(false), portfolioStocks: [.mock, .mock, .mock, .mock, .mock, .mock], upcomingDates: [Date(), Date(), Date(), Date(), Date(), Date()], onDelete: { _ in }, sunburstConfig: SunburstConfiguration(nodes: []))
    }
}

struct TitleView: View {
    let title: String
    
    var body: some View {
        VStack {
            HStack {
                Text(title)
                    .foregroundColor(Color("textColor"))
                    .font(.largeTitle)
                    .fontWeight(.heavy)
                
                Spacer()
            }
        }.padding()
    }
}

struct SunburstDiagramButton: View {
    @Binding var showSectorInfo: Bool
    
    var body: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Button(action: {
                    self.showSectorInfo.toggle()
                }, label: {
                    Image(systemName: "chart.pie.fill")
                        .resizable()
                        .frame(width: 50, height: 50)
                        .foregroundColor(showSectorInfo ? Color.pink : Color.purple)
                })
            }
            .padding()
            Spacer()
                .frame(height: UIScreen.main.bounds.height * 0.1)
        }
    }
}
