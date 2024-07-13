import Foundation

class InventoryManager {
    static let shared = InventoryManager()
    
    private var products: [UUID: Product] = [:]
    
    private init() {}
    
    func addProduct(product: Product) {
        products[product.id] = product
    }
    
    func removeProduct(by id: UUID) {
        products.removeValue(forKey: id)
    }
    
    func updateProduct(id: UUID, name: String?, description: String?, price: Double?, stockLevel: Int?) {
        guard let product = products[id] else { return }
        if let name = name { product.name = name }
        if let description = description { product.description = description }
        if let price = price { product.price = price }
        if let stockLevel = stockLevel { product.stockLevel = stockLevel }
    }
    
    func viewProduct(by id: UUID) -> Product? {
        return products[id]
    }
    
    func lowStockProducts(threshold: Int = 3) -> [Product] {
        return products.values.filter { $0.stockLevel <= threshold }
    }
    
    func getAllProducts() -> [Product] {
        return Array(products.values)
    }

    func clearInventory() {
        products.removeAll()
    }
}
