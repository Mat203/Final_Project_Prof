import Foundation

class Order: Identifiable {
    var orderId: UUID
    var products: [Product]
    var totalPrice: Double
    
    init() {
        self.orderId = UUID()
        self.products = []
        self.totalPrice = 0.0
    }
    
    func addProduct(product: Product, quantity: Int) {
        for _ in 0..<quantity {
            products.append(product)
        }
        calculateTotalPrice()
    }
    
    func removeProduct(productId: UUID) {
        products.removeAll { $0.id == productId }
        calculateTotalPrice()
    }
    
    func calculateTotalPrice() {
        totalPrice = products.reduce(0) { $0 + $1.price }
    }
}
