import Foundation

class InventoryController: ObservableObject {
    @Published private(set) var store: Store
    let orderDatabase = OrderDatabase.shared
    let productDatabase = ProductDatabase.shared
    private lazy var worker: Worker = {
        Worker(store: store, orderDatabase: orderDatabase, productDatabase: productDatabase)
    }()

    init() {
        self.store = Store()
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
        objectWillChange.send()
    }
    
    func removeProductByID(id: UUID) {
        store.removeProduct(productId: id)
        objectWillChange.send()
    }
    
    func updateProductInformation(id: UUID, name: String?, description: String?, price: Double?, stockLevel: Int?) {
        guard let product = store.getProduct(productId: id) else { return }
        if let name = name { product.name = name }
        if let description = description { product.description = description }
        if let price = price { product.price = price }
        if let stockLevel = stockLevel { product.stockLevel = stockLevel }
        store.updateProduct(product: product)
        productDatabase.save(product: product)
        objectWillChange.send()
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
    
    func addProductToOrder(order: Order, productID: UUID, quantity: Int) -> Bool {
        guard let product = store.getProduct(productId: productID) else { return false }
        guard product.stockLevel >= quantity else { return false }
        
        worker.addProductToOrder(order: order, product: product, quantity: quantity)
        return true
    }
    
    func finalizeOrder(order: Order) {
        for product in order.products {
            if let storedProduct = store.getProduct(productId: product.id) {
                storedProduct.updateStockLevel(newStockLevel: storedProduct.stockLevel - 1)
                store.updateProduct(product: storedProduct)
            }
        }
        orderDatabase.saveOrder(order: order)
        objectWillChange.send()
    }
    
    func checkStockAvailability(product: Product, quantity: Int) -> Bool {
        return product.stockLevel >= quantity
    }
}
