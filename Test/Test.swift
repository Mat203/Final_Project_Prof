import XCTest

class InventoryManagerTests: XCTestCase {

    override func setUp() {
        super.setUp()
        InventoryManager.shared.clearInventory()
    }

    func testAddProduct() {
        let manager = InventoryManager.shared
        let product = Product(name: "Test Product", description: "This is a test product", price: 10.0, stockLevel: 5)
        
        manager.addProduct(product: product)
        let fetchedProduct = manager.viewProduct(by: product.id)
        
        XCTAssertNotNil(fetchedProduct)
        XCTAssertEqual(fetchedProduct?.name, "Test Product")
    }
    
    func testRemoveProduct() {
        let manager = InventoryManager.shared
        let product = Product(name: "Test Product", description: "This is a test product", price: 10.0, stockLevel: 5)
        
        manager.addProduct(product: product)
        manager.removeProduct(by: product.id)
        let fetchedProduct = manager.viewProduct(by: product.id)
        
        XCTAssertNil(fetchedProduct)
    }
    
    func testUpdateProduct() {
        let manager = InventoryManager.shared
        let product = Product(name: "Test Product", description: "This is a test product", price: 10.0, stockLevel: 5)
        
        manager.addProduct(product: product)
        manager.updateProduct(id: product.id, name: "Updated Product", description: nil, price: nil, stockLevel: nil)
        let fetchedProduct = manager.viewProduct(by: product.id)
        
        XCTAssertNotNil(fetchedProduct)
        XCTAssertEqual(fetchedProduct?.name, "Updated Product")
    }
    
    func testLowStockProducts() {
        let manager = InventoryManager.shared
        let product1 = Product(name: "Test Product 1", description: "This is a test product", price: 10.0, stockLevel: 2)
        let product2 = Product(name: "Test Product 2", description: "This is another test product", price: 15.0, stockLevel: 5)
        
        manager.addProduct(product: product1)
        manager.addProduct(product: product2)
        
        let lowStockProducts = manager.lowStockProducts(threshold: 3)
        
        XCTAssertEqual(lowStockProducts.count, 1)
        XCTAssertEqual(lowStockProducts.first?.name, "Test Product 1")
    }
    
    func testGetAllProducts() {
        let manager = InventoryManager.shared
        let product1 = Product(name: "Test Product 1", description: "This is a test product", price: 10.0, stockLevel: 2)
        let product2 = Product(name: "Test Product 2", description: "This is another test product", price: 15.0, stockLevel: 5)
        
        manager.addProduct(product: product1)
        manager.addProduct(product: product2)
        
        let allProducts = manager.getAllProducts()
        
        XCTAssertEqual(allProducts.count, 2)
    }
}

class InventoryControllerTests: XCTestCase {

    override func setUp() {
        super.setUp()
        InventoryManager.shared.clearInventory()
    }

    func testAddNewProduct() {
        let controller = InventoryController()
        controller.addNewProduct(name: "Test Product", description: "This is a test product", price: 10.0, stockLevel: 5)
        
        let allProducts = controller.viewAllProducts()
        let product = allProducts.first
        
        XCTAssertNotNil(product)
        XCTAssertEqual(product?.name, "Test Product")
    }
    
    func testRemoveProduct() {
        let controller = InventoryController()
        controller.addNewProduct(name: "Test Product", description: "This is a test product", price: 10.0, stockLevel: 5)
        
        let product = controller.viewAllProducts().first!
        controller.removeProduct(by: product.id)
        
        let allProducts = controller.viewAllProducts()
        XCTAssertTrue(allProducts.isEmpty)
    }
    
    func testUpdateProduct() {
        let controller = InventoryController()
        controller.addNewProduct(name: "Test Product", description: "This is a test product", price: 10.0, stockLevel: 5)
        
        let product = controller.viewAllProducts().first!
        controller.updateProduct(id: product.id, name: "Updated Product")
        
        let updatedProduct = controller.viewProduct(by: product.id)
        XCTAssertEqual(updatedProduct?.name, "Updated Product")
    }
    
    func testCheckLowStockProducts() {
        let controller = InventoryController()
        controller.addNewProduct(name: "Test Product 1", description: "This is a test product", price: 10.0, stockLevel: 2)
        controller.addNewProduct(name: "Test Product 2", description: "This is another test product", price: 15.0, stockLevel: 5)
        
        let lowStockProducts = controller.checkLowStockProducts()
        
        XCTAssertEqual(lowStockProducts.count, 1)
        XCTAssertEqual(lowStockProducts.first?.name, "Test Product 1")
    }
    
    func testViewAllProducts() {
        let controller = InventoryController()
        controller.addNewProduct(name: "Test Product 1", description: "This is a test product", price: 10.0, stockLevel: 2)
        controller.addNewProduct(name: "Test Product 2", description: "This is another test product", price: 15.0, stockLevel: 5)
        
        let allProducts = controller.viewAllProducts()
        
        XCTAssertEqual(allProducts.count, 2)
    }
}

