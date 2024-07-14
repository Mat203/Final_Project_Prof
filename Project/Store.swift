import Foundation

class Store {
    private var products: [UUID: Product] = [:]
    
    func addProduct(product: Product) {
        products[product.id] = product
    }
    
    func removeProduct(productId: UUID) {
        products.removeValue(forKey: productId)
    }
    
    func updateProduct(product: Product) {
        products[product.id] = product
    }
    
    func getProduct(productId: UUID) -> Product? {
        return products[productId]
    }
    
    func getAllProducts() -> [Product] {
        return Array(products.values)
    }
    
    func lowStockProducts(threshold: Int = 3) -> [Product] {
        return products.values.filter { $0.stockLevel <= threshold }
    }
}
