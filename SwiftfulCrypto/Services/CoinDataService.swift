//
//  CoinDataService.swift
//  SwiftfulCrypto
//
//  Created by Vladyslav Mi on 16.03.2024.
//

import Foundation
import Combine

class CoinDataService {
    @Published var allCoins: [CoinModel] = []
    var cancellables = Set<AnyCancellable>()
    
    var coinSubscription: AnyCancellable?
    init() {
        getCoins()
    }
    
    func getCoins() {
        guard let url = URL(string: "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&per_page=250&page=1&sparkline=true&price_change_percentage=24h") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = ["x-cg-demo-api-key": "CG-8r5geog36gevGMqN2DumKcVD"]
        
        coinSubscription = NetworkingManager.download(url: request)
            .decode(type: [CoinModel].self, decoder: JSONDecoder())
            .sink(receiveCompletion: NetworkingManager.handleCompletion, receiveValue: { [weak self] (returnedCoins) in
                self?.allCoins = returnedCoins
                self?.coinSubscription?.cancel()
            })
    }
}
