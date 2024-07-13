import Foundation

class InventoryController {
    let inventoryManager = InventoryManager.shared
    
    func addNewProduct(name: String, description: String, price: Double, stockLevel: Int) {
        let product = Product(name: name, description: description, price: price, stockLevel: stockLevel)
        inventoryManager.addProduct(product: product)
    }
    
    func removeProduct(by id: UUID) {
        inventoryManager.removeProduct(by: id)
    }
    
    func updateProduct(id: UUID, name: String? = nil, description: String? = nil, price: Double? = nil, stockLevel: Int? = nil) {
        inventoryManager.updateProduct(id: id, name: name, description: description, price: price, stockLevel: stockLevel)
    }
    
    func viewProduct(by id: UUID) -> Product? {
        return inventoryManager.viewProduct(by: id)
    }
    
    func checkLowStockProducts() -> [Product] {
        return inventoryManager.lowStockProducts()
    }
    
    func viewAllProducts() -> [Product] {
        return inventoryManager.getAllProducts()
    }
}

