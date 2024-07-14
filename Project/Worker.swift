
import Foundation

class Worker {
    private let store: Store
    private let database: Database
    
    init(store: Store, database: Database) {
        self.store = store
        self.database = database
    }
    
    func createOrder() -> Order {
        return Order()
    }
    
    func addProductToOrder(order: Order, product: Product, quantity: Int) {
        order.addProduct(product: product, quantity: quantity)
    }
    
    func finishOrder(order: Order) {
        for product in order.products {
            if let storeProduct = store.getProduct(productId: product.id) {
                storeProduct.updateStockLevel(newStockLevel: storeProduct.stockLevel - 1)
            }
        }
        database.saveOrder(order: order)
    }
}
