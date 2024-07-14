import Foundation

class Product {
    let id: UUID
    var name: String
    var description: String
    var price: Double
    var stockLevel: Int
    
    init(name: String, description: String, price: Double, stockLevel: Int) {
        self.id = UUID()
        self.name = name
        self.description = description
        self.price = price
        self.stockLevel = stockLevel
    }
    
    func updateStockLevel(newStockLevel: Int) {
        self.stockLevel = newStockLevel
    }
}
