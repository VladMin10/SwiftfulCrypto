//
//  ChartView.swift
//  SwiftfulCrypto
//
//  Created by Vladyslav Mi on 02.04.2024.
//

import SwiftUI

struct ChartView: View {
    
    private let data : [Double]
    private let maxY : Double
    private let minY : Double
    private let lineColor : Color
    private let startingDate : Date
    private let endingDate : Date
    @State private var percentage : CGFloat = 0
    
    init(coin : CoinModel){
        data = coin.sparklineIn7D?.price ?? []
        maxY = data.max() ?? 0
        minY = data.min() ?? 0
        
        
        let priceChange = (data.last ?? 0) - (data.first ?? 0)
        lineColor = priceChange > 0 ? Color.theme.green : Color.theme.red
        
        endingDate = Date(coinGeckoString: coin.lastUpdated ?? "")
        startingDate = endingDate.addingTimeInterval(-7*24*60*60)
    }
    
    var body: some View {
        VStack {
            chartView
                .frame(height : 200)
                .background(chartBackground)
                .overlay(chartYAxis.padding(.horizontal, 4), alignment : .leading)
            chartDataLabels
                .padding(.horizontal, 4)
        }
        .font(.caption)
        .foregroundColor(Color.theme.secondaryText)
        .onAppear{
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                withAnimation(.linear(duration : 2.0)) {
                    percentage = 1.0
                }
            }
        }
    }
}

struct ChartView_Previews : PreviewProvider {
    static var previews: some View{
        NavigationView{
            ChartView(coin : dev.coin)
            
        }
        .environmentObject(dev.homeVM)
    }
}

extension ChartView {
    private var chartView : some View {
        GeometryReader { geometry in //  для отримання розмірів контейнера
            Path { path in
                for index in data.indices {
                    
                    let xPosition = (geometry.size.width / CGFloat(data.count)) * CGFloat(index + 1) //Обчислення позиції по осі X для кожної точки графіка.
                    
                    let yAxes = maxY - minY//Обчислення діапазону по осі Y
                    
                    let yPosition = (1 - CGFloat((data[index] - minY) / yAxes)) * geometry.size.height//Обчислення позиції по осі Y для кожної точки графіка.
                    
                    if index == 0 {
                        path.move(to: CGPoint(x : xPosition, y: yPosition))//Перший індекс встановлює початкову точку шляху
                }
                    path.addLine(to: CGPoint(x: xPosition, y: yPosition))//Додаємо лінію до шляху для поточної точки.
                }
            }
            .trim(from: 0, to: percentage)//Обрізаємо шлях до вказаного відсотка
            .stroke(lineColor, style: StrokeStyle(lineWidth: 3,lineCap: .round, lineJoin: .round))
            .shadow(color: lineColor, radius: 10, x: 0.0, y: 10)
            .shadow(color: lineColor.opacity(0.5), radius: 8, x: 0.0, y: 10)
            .shadow(color: lineColor.opacity(0.2), radius: 8, x: 0.0, y: 10)
            .shadow(color: lineColor.opacity(0.1), radius: 8, x: 0.0, y: 10)
        }
    }
    private var chartBackground : some View {
        VStack{
            Divider()
            Spacer()
            Divider()
            Spacer()
            Divider()
        }
    }
    private var chartYAxis : some View {
        VStack{
            Text(maxY.formattedWithAbbreviations())
            Spacer()
            Text(((maxY + minY) / 2).formattedWithAbbreviations())
            Spacer()
            Text(minY.formattedWithAbbreviations())
        }
    }
    private var chartDataLabels : some View {
        HStack{
            Text(startingDate.asShortDateString())
            Spacer()
            Text(endingDate.asShortDateString())
        }
    }
}
