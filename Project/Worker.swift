import Foundation

class Worker {
    private let store: Store
    private let orderDatabase: OrderDatabase
    private let productDatabase: ProductDatabase
    
    init(store: Store, orderDatabase: OrderDatabase, productDatabase: ProductDatabase) {
        self.store = store
        self.orderDatabase = orderDatabase
        self.productDatabase = productDatabase
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
                store.updateProduct(product: storeProduct)
                productDatabase.save(product: storeProduct)
            }
        }
        orderDatabase.saveOrder(order: order)
    }
}
