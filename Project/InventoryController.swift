import Foundation

class InventoryController {
    private let store = Store()
    private let orderDatabase = OrderDatabase.shared
    private let productDatabase = ProductDatabase.shared
    private let worker: Worker
    
    init() {
        self.worker = Worker(store: store, orderDatabase: orderDatabase, productDatabase: productDatabase)
        let products = productDatabase.load()
        for product in products {
            store.addProduct(product: product)
        }
    }
    
    func addNewProduct(name: String, description: String, price: Double, stockLevel: Int) {
        let idForProduct = UUID()
        let product = Product(id: idForProduct, name: name, description: description, price: price, stockLevel: stockLevel)
        store.addProduct(product: product)
        productDatabase.save(product: product)
    }
    
    func removeProductByID(id: UUID) {
        store.removeProduct(productId: id)
    }
    
    func updateProductInformation(id: UUID, name: String?, description: String?, price: Double?, stockLevel: Int?) {
        guard let product = store.getProduct(productId: id) else { return }
        if let name = name { product.name = name }
        if let description = description { product.description = description }
        if let price = price { product.price = price }
        if let stockLevel = stockLevel { product.stockLevel = stockLevel }
        store.updateProduct(product: product)
        productDatabase.save(product: product)
    }
    
    func viewProductByID(id: UUID) -> Product? {
        return store.getProduct(productId: id)
    }
    
    func viewAllProducts() -> [Product] {
        return store.getAllProducts()
    }
    
    func viewLowStockProducts(threshold: Int = 3) -> [Product] {
        return store.lowStockProducts(threshold: threshold)
    }
    
    func createNewOrder() -> Order {
        return worker.createOrder()
    }
    
    func addProductToOrder(order: Order, productID: UUID, quantity: Int) {
        guard let product = store.getProduct(productId: productID) else { return }
        worker.addProductToOrder(order: order, product: product, quantity: quantity)
    }
    
    func finalizeOrder(order: Order) {
        for product in order.products {
            if let storedProduct = store.getProduct(productId: product.id) {
                storedProduct.updateStockLevel(newStockLevel: storedProduct.stockLevel - 1)
                store.updateProduct(product: storedProduct)
            }
        }
        orderDatabase.saveOrder(order: order)
    }
}
