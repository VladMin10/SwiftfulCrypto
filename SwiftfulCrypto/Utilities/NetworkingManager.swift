//
//  NetworkingManager.swift
//  SwiftfulCrypto
//
//  Created by Vladyslav Mi on 18.03.2024.
//

import Foundation
import Combine

class NetworkingManager{
    
    enum NetworkingError : LocalizedError{
        case badURLResponse
        case unknown
        
        var errorDescription: String? {
            switch self{
            case .badURLResponse: return "Bad response URL[🤡])"
            case .unknown: return "Unknown error occured[🤡]"
            }
        }
    }
    static func download(url: URLRequest) -> AnyPublisher<Data, Error> {
       return URLSession.shared.dataTaskPublisher(for: url)
            .subscribe(on: DispatchQueue.global(qos: .default))
            .tryMap ({ try handleURLResponse(output: $0)})
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    static func handleURLResponse(output :URLSession.DataTaskPublisher.Output) throws -> Data{
        guard let response = output.response as? HTTPURLResponse,
              response.statusCode >= 200 && response.statusCode < 300 else {
            throw NetworkingError.badURLResponse
        }
        return output.data
    }
    
    static func handleCompletion(completion : Subscribers.Completion<Error>){
        switch completion {
        case .finished:
            break
        case .failure(let error):
            print(error.localizedDescription)
        }
    }
}
