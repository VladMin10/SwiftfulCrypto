//
//  PortfolioDataService.swift
//  SwiftfulCrypto
//
//  Created by Vladyslav Mi on 27.03.2024.
//

import Foundation
import CoreData

class PortfolioDataService {
    private let container : NSPersistentContainer
    private let containername: String = "PortfolioContainer"
    private let entityName: String = "PortfolioEntity"
    
    @Published var savedEntities : [PortfolioEntity] = []
    
    init(){
        container = NSPersistentContainer(name : containername)
        container.loadPersistentStores { (_, error) in
            if let error = error {
                print("Error loading core data!\(error)")
            }
            self.getPortfolio()
        }
    }
    //MARK: PUBIC
    
    func updatePortfolio(coin : CoinModel, amount : Double){
        //check if coin is already in portfolio
        if let entity = savedEntities.first(where: { $0.coinID == coin.id }){
            
            if amount > 0 {
                update(entity: entity, amount: amount)
            } else {
                delete(entity: entity)
            }
        } else {
            add(coin: coin, amount: amount)
        }
        
    }
    
    //MARK: PRIVATE
    private func getPortfolio(){
        let request = NSFetchRequest<PortfolioEntity>(entityName: entityName)
        do {
            savedEntities = try container.viewContext.fetch(request)
        } catch let error {
            print("Error fetching entities.\(error)")
        }
    }
    
    private func add(coin : CoinModel, amount : Double){
        let entity = PortfolioEntity(context: container.viewContext)
        entity.coinID = coin.id
        entity.amount = amount
        applyChanges()
    }
    
    private func update(entity: PortfolioEntity, amount: Double){
        entity.amount = amount
        applyChanges()
    }
    private func delete(entity : PortfolioEntity) {
        container.viewContext.delete(entity)
        applyChanges()
    }
    
    private func save(){
        do {
            try container.viewContext.save()
        } catch let error {
            print("Error saving to core data.\(error)")
        }
    }
    
    private func applyChanges(){
        save()
        getPortfolio()
    }
}
