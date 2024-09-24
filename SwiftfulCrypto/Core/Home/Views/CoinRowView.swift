//
//  CoinRowView.swift
//  SwiftfulCrypto
//
//  Created by Vladyslav Mi on 15.03.2024.
//

import SwiftUI

struct CoinRowView: View {
    
    let coin : CoinModel
    let showHoldingsColumn : Bool
    
    var body: some View {
        HStack(spacing: 0) {
            leftColumn
            Spacer()
            if showHoldingsColumn {
                centerColumn
            }
            rightColumn
        }
        .font(.subheadline)
        .background(
            Color.theme.background.opacity(0.001))
        
    }
}

struct CoinRowView_Previews : PreviewProvider {
    static var previews: some View{
        Group{
            CoinRowView(coin : dev.coin, showHoldingsColumn: true)
                .previewLayout(.sizeThatFits)
            CoinRowView(coin : dev.coin, showHoldingsColumn: true)
                .previewLayout(.sizeThatFits)
                .preferredColorScheme(.dark)
        }
    }
}



extension CoinRowView {
    private var leftColumn : some View {
        HStack(spacing : 5){
            Text("\(coin.rank)")
                .font(.caption)
                .foregroundColor(Color.theme.secondaryText)
                .frame(minWidth: 30)
            CoinImageView(coin: coin)
                .frame(width: 30, height: 30)
            Text(coin.symbol.uppercased())
                .font(.headline)
                .foregroundColor(Color.theme.accent)
        }
    }
    private var centerColumn : some View {
        VStack (alignment : .trailing){
            Text(coin.currentHoldingsValue.asCurrencyWith2Decimal())
                .bold()
            Text((coin.currentHoldings ?? 0).asNumberString())
        }
        .foregroundColor(Color.theme.accent)
    }
    
    private var rightColumn : some View {
        VStack(alignment : .trailing){
            Text(coin.currentPrice.asCurrencyWithDecimal())
                .bold()
                .foregroundColor(Color.theme.accent)
                .frame(minWidth: 100, alignment: .trailing)
                
        
            Text(coin.priceChangePercentage24H?.asPercentString() ?? "")
                .foregroundColor(
                    (coin.priceChangePercentage24H ?? 0) >= 0 ? Color.theme.green : Color.theme.red
                )
                .frame(minWidth: 100, alignment: .trailing)
        }
        .frame(width: UIScreen.main.bounds.width / 3, alignment: .trailing)
    }
}
