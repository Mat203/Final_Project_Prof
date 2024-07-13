import Foundation

func userInterface() {
    let inventoryController = InventoryController()
    var isRunning = true
    
    while isRunning {
        print("""
        Enter a command:
        1. Add Product
        2. Remove Product
        3. Update Product
        4. View All Products
        5. View Product by ID
        6. Check Low Stock Products
        7. Exit
        """)
        
        if let input = readLine() {
            switch input {
            case "1":
                print("Enter product name:")
                let name = readLine() ?? ""
                print("Enter product description:")
                let description = readLine() ?? ""
                print("Enter product price:")
                let price = Double(readLine() ?? "0") ?? 0
                print("Enter product stock level:")
                let stockLevel = Int(readLine() ?? "0") ?? 0
                inventoryController.addNewProduct(name: name, description: description, price: price, stockLevel: stockLevel)
                print("Product added!\n")
                
            case "2":
                print("Enter product ID to remove:")
                if let idInput = readLine(), let id = UUID(uuidString: idInput) {
                    inventoryController.removeProduct(by: id)
                    print("Product removed!\n")
                } else {
                    print("Invalid ID\n")
                }
                
            case "3":
                print("Enter product ID to update:")
                if let idInput = readLine(), let id = UUID(uuidString: idInput) {
                    print("Enter new product name (or press Enter to skip):")
                    let name = readLine()
                    print("Enter new product description (or press Enter to skip):")
                    let description = readLine()
                    print("Enter new product price (or press Enter to skip):")
                    let price = Double(readLine() ?? "")
                    print("Enter new product stock level (or press Enter to skip):")
                    let stockLevel = Int(readLine() ?? "")
                    inventoryController.updateProduct(id: id, name: name, description: description, price: price, stockLevel: stockLevel)
                    print("Product updated!\n")
                } else {
                    print("Invalid ID\n")
                }
                
            case "4":
                let allProducts = inventoryController.viewAllProducts()
                for product in allProducts {
                    print("Product ID: \(product.id), Name: \(product.name), Price: \(product.price), Stock Level: \(product.stockLevel)")
                }
                print("")
                
            case "5":
                print("Enter product ID to view:")
                if let idInput = readLine(), let id = UUID(uuidString: idInput), let product = inventoryController.viewProduct(by: id) {
                    print("Product Name: \(product.name), Description: \(product.description), Price: \(product.price), Stock Level: \(product.stockLevel)\n")
                } else {
                    print("Invalid ID or product not found\n")
                }
                
            case "6":
                let lowStockProducts = inventoryController.checkLowStockProducts()
                for product in lowStockProducts {
                    print("Low Stock Product: \(product.name), Stock Level: \(product.stockLevel)")
                }
                print("")
                
            case "7":
                isRunning = false
                print("Exiting...\n")
                
            default:
                print("Invalid command\n")
            }
        }
    }
}

userInterface()
