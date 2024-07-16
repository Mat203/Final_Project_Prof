import XCTest

class ProductTests: XCTestCase {
    
    func testProductInitialization() {
        let product = Product(id: UUID(), name: "Test Product", description: "This is a test product", price: 10.0, stockLevel: 5)
        
        XCTAssertEqual(product.name, "Test Product")
        XCTAssertEqual(product.description, "This is a test product")
        XCTAssertEqual(product.price, 10.0)
        XCTAssertEqual(product.stockLevel, 5)
    }
    
    func testUpdateStockLevel() {
        let product = Product(id: UUID(), name: "Test Product", description: "This is a test product", price: 10.0, stockLevel: 5)
        product.updateStockLevel(newStockLevel: 10)
        
        XCTAssertEqual(product.stockLevel, 10)
    }
}

class OrderTests: XCTestCase {
    
    func testOrderInitialization() {
        let order = Order()
        
        XCTAssertEqual(order.products.count, 0)
        XCTAssertEqual(order.totalPrice, 0.0)
    }
    
    func testAddProduct() {
        let order = Order()
        let product = Product(id: UUID(), name: "Test Product", description: "This is a test product", price: 10.0, stockLevel: 5)
        
        order.addProduct(product: product, quantity: 2)
        
        XCTAssertEqual(order.products.count, 2)
        XCTAssertEqual(order.totalPrice, 20.0)
    }
    
    func testRemoveProduct() {
        let order = Order()
        let product = Product(id: UUID(), name: "Test Product", description: "This is a test product", price: 10.0, stockLevel: 5)
        
        order.addProduct(product: product, quantity: 2)
        order.removeProduct(productId: product.id)
        
        XCTAssertEqual(order.products.count, 0)
        XCTAssertEqual(order.totalPrice, 0.0)
    }
    
    func testCalculateTotalPrice() {
        let order = Order()
        let product1 = Product(id: UUID(), name: "Test Product 1", description: "This is a test product", price: 10.0, stockLevel: 5)
        let product2 = Product(id: UUID(), name: "Test Product 2", description: "This is another test product", price: 15.0, stockLevel: 5)
        
        order.addProduct(product: product1, quantity: 1)
        order.addProduct(product: product2, quantity: 2)
        
        XCTAssertEqual(order.totalPrice, 40.0)
    }
}

class StoreTests: XCTestCase {
    
    func testAddProduct() {
        let store = Store()
        let product = Product(id: UUID(), name: "Test Product", description: "This is a test product", price: 10.0, stockLevel: 5)
        
        store.addProduct(product: product)
        let fetchedProduct = store.getProduct(productId: product.id)
        
        XCTAssertNotNil(fetchedProduct)
        XCTAssertEqual(fetchedProduct?.name, "Test Product")
    }
    
    func testRemoveProduct() {
        let store = Store()
        let product = Product(id: UUID(), name: "Test Product", description: "This is a test product", price: 10.0, stockLevel: 5)
        
        store.addProduct(product: product)
        store.removeProduct(productId: product.id)
        let fetchedProduct = store.getProduct(productId: product.id)
        
        XCTAssertNil(fetchedProduct)
    }
    
    func testUpdateProduct() {
        let store = Store()
        let product = Product(id: UUID(), name: "Test Product", description: "This is a test product", price: 10.0, stockLevel: 5)
        
        store.addProduct(product: product)
        
        product.name = "Updated Product"
        store.updateProduct(product: product)
        
        let fetchedProduct = store.getProduct(productId: product.id)
        XCTAssertEqual(fetchedProduct?.name, "Updated Product")
    }
    
    func testGetAllProducts() {
        let store = Store()
        let product1 = Product(id: UUID(), name: "Test Product 1", description: "This is a test product", price: 10.0, stockLevel: 5)
        let product2 = Product(id: UUID(), name: "Test Product 2", description: "This is another test product", price: 15.0, stockLevel: 5)
        
        store.addProduct(product: product1)
        store.addProduct(product: product2)
        
        let products = store.getAllProducts()
        
        XCTAssertEqual(products.count, 2)
    }
    
    func testLowStockProducts() {
        let store = Store()
        let product1 = Product(id: UUID(), name: "Test Product 1", description: "This is a test product", price: 10.0, stockLevel: 2)
        let product2 = Product(id: UUID(), name: "Test Product 2", description: "This is another test product", price: 15.0, stockLevel: 5)
        
        store.addProduct(product: product1)
        store.addProduct(product: product2)
        
        let lowStockProducts = store.lowStockProducts(threshold: 3)
        
        XCTAssertEqual(lowStockProducts.count, 1)
        XCTAssertEqual(lowStockProducts.first?.name, "Test Product 1")
    }
}

class InventoryControllerTests: XCTestCase {
    
    func testAddNewProduct() {
        let controller = InventoryController()
        
        controller.addNewProduct(name: "Test Product", description: "This is a test product", price: 10.0, stockLevel: 5)
        let products = controller.viewAllProducts()
        
        XCTAssertEqual(products.count, 1)
        XCTAssertEqual(products.first?.name, "Test Product")
    }
    
    func testRemoveProductByID() {
        let controller = InventoryController()
        let product = Product(id: UUID(), name: "Test Product", description: "This is a test product", price: 10.0, stockLevel: 5)
        controller.addNewProduct(name: product.name, description: product.description, price: product.price, stockLevel: product.stockLevel)
        
        if let productID = controller.viewAllProducts().first?.id {
            controller.removeProductByID(id: productID)
        }
        
        let products = controller.viewAllProducts()
        XCTAssertEqual(products.count, 0)
    }
    
    func testUpdateProductInformation() {
        let controller = InventoryController()
        let product = Product(id: UUID(), name: "Test Product", description: "This is a test product", price: 10.0, stockLevel: 5)
        controller.addNewProduct(name: product.name, description: product.description, price: product.price, stockLevel: product.stockLevel)
        
        if let productID = controller.viewAllProducts().first?.id {
            controller.updateProductInformation(id: productID, name: "Updated Product", description: nil, price: nil, stockLevel: nil)
        }
        
        let updatedProduct = controller.viewAllProducts().first
        XCTAssertEqual(updatedProduct?.name, "Updated Product")
    }
    
    func testViewProductByID() {
        let controller = InventoryController()
        let product = Product(id: UUID(), name: "Test Product", description: "This is a test product", price: 10.0, stockLevel: 5)
        controller.addNewProduct(name: product.name, description: product.description, price: product.price, stockLevel: product.stockLevel)
        
        if let productID = controller.viewAllProducts().first?.id {
            let fetchedProduct = controller.viewProductByID(id: productID)
            XCTAssertNotNil(fetchedProduct)
            XCTAssertEqual(fetchedProduct?.name, "Test Product")
        }
    }
    
    func testViewAllProducts() {
        let controller = InventoryController()
        let product1 = Product(id: UUID(), name: "Test Product 1", description: "This is a test product", price: 10.0, stockLevel: 5)
        let product2 = Product(id: UUID(), name: "Test Product 2", description: "This is another test product", price: 15.0, stockLevel: 5)
        
        controller.addNewProduct(name: product1.name, description: product1.description, price: product1.price, stockLevel: product1.stockLevel)
        controller.addNewProduct(name: product2.name, description: product2.description, price: product2.price, stockLevel: product2.stockLevel)
        
        let products = controller.viewAllProducts()
        
        XCTAssertEqual(products.count, 2)
    }
    
    func testViewLowStockProducts() {
        let controller = InventoryController()
        let product1 = Product(id: UUID(), name: "Test Product 1", description: "This is a test product", price: 10.0, stockLevel: 2)
        let product2 = Product(id: UUID(), name: "Test Product 2", description: "This is another test product", price: 15.0, stockLevel: 5)
        
        controller.addNewProduct(name: product1.name, description: product1.description, price: product1.price, stockLevel: product1.stockLevel)
        controller.addNewProduct(name: product2.name, description: product2.description, price: product2.price, stockLevel: product2.stockLevel)
        
        let lowStockProducts = controller.viewLowStockProducts(threshold: 3)
        
        XCTAssertEqual(lowStockProducts.count, 1)
        XCTAssertEqual(lowStockProducts.first?.name, "Test Product 1")
    }
    
    func testCreateNewOrder() {
        let controller = InventoryController()
        let order = controller.createNewOrder()
        
        XCTAssertNotNil(order)
        XCTAssertEqual(order.products.count, 0)
        XCTAssertEqual(order.totalPrice, 0.0)
    }
    
    func testAddProductToOrder() {
        let controller = InventoryController()
        let product = Product(id: UUID(), name: "Test Product", description: "This is a test product", price: 10.0, stockLevel: 5)
        controller.addNewProduct(name: product.name, description: product.description, price: product.price, stockLevel: product.stockLevel)
        
        if let productID = controller.viewAllProducts().first?.id {
            let order = controller.createNewOrder()
            controller.addProductToOrder(order: order, productID: productID, quantity: 2)
            
            XCTAssertEqual(order.products.count, 2)
            XCTAssertEqual(order.totalPrice, 20.0)
        }
    }
    
    func testFinalizeOrder() {
        let controller = InventoryController()
        let product = Product(id: UUID(), name: "Test Product", description: "This is a test product", price: 10.0, stockLevel: 5)
        controller.addNewProduct(name: product.name, description: product.description, price: product.price, stockLevel: product.stockLevel)
        
        if let productID = controller.viewAllProducts().first?.id {
            let order = controller.createNewOrder()
            controller.addProductToOrder(order: order, productID: productID, quantity: 2)
            controller.finalizeOrder(order: order)
            
            if let updatedProduct = controller.viewProductByID(id: productID) {
                XCTAssertEqual(updatedProduct.stockLevel, 3)
            } else {
                XCTFail("Product not found in inventory")
            }
        } else {
            XCTFail("Failed to retrieve product ID")
        }
    }
}
