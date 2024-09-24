//
//  CoinImageService.swift
//  SwiftfulCrypto
//
//  Created by Vladyslav Mi on 19.03.2024.
//

import Foundation
import SwiftUI
import Combine

class CoinImageService {
    
    @Published var image : UIImage? = nil
    private var imageSubscription : AnyCancellable?
    private let coin : CoinModel
    private let fileManager = LogoFileManager.instance
    private let folderName = "coin_images"
    private let imageName: String
    
    init(coin : CoinModel){
        self.coin = coin
        self.imageName = coin.id
        getCoinImage()
    }
    private func getCoinImage(){
        if let savedImage = fileManager.getImage(imageName: coin.id, folderName: folderName){
            image = savedImage
        } else {
            downloadCoinImage()
        }
    }
    
    private func downloadCoinImage(){
        guard let url = URL(string: coin.image) else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = ["x-cg-demo-api-key": "CG-8r5geog36gevGMqN2DumKcVD"]
        
        imageSubscription = NetworkingManager.download(url: request)
            .tryMap({ (data) -> UIImage? in
                return UIImage(data: data)
            })
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: NetworkingManager.handleCompletion, receiveValue: { [weak self] (returnedImage) in
                guard let self = self else {return}
                self.image = returnedImage
                self.imageSubscription?.cancel()
                if let image = returnedImage {
                    self.fileManager.saveImage(image: image, imageName: self.imageName, folderName: self.folderName)
                }
            })


    }


}
