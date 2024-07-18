import Foundation

class UserInterface {
    private let inventoryController = InventoryController()
    
    func run() {
        print("Welcome to Anya Baluvana's Inventory System")
        
        while true {
            print("""
                Please choose an option:
                1. View all products
                2. View a product by ID
                3. Add a new product
                4. Remove a product by ID
                5. Update product information
                6. View low stock products
                7. Create a new order
                8. Exit
                """)
            
            guard let choice = readLine(), let option = Int(choice) else {
                print("Invalid choice. Please try again.")
                continue
            }
            
            switch option {
            case 1:
                viewAllProducts()
            case 2:
                viewProductByID()
            case 3:
                addNewProduct()
            case 4:
                removeProductByID()
            case 5:
                updateProductInformation()
            case 6:
                viewLowStockProducts()
            case 7:
                createNewOrder()
            case 8:
                print("Goodbye!")
                return
            default:
                print("Invalid choice. Please try again.")
            }
        }
    }
    
    private func viewAllProducts() {
        let products = inventoryController.viewAllProducts()
        for product in products {
            print("ID: \(product.id), Name: \(product.name), Price: \(product.price), Stock Level: \(product.stockLevel)")
        }
    }
    
    private func viewProductByID() {
        print("Enter the product ID:")
        guard let idString = readLine(), let id = UUID(uuidString: idString) else {
            print("Invalid ID format.")
            return
        }
        
        if let product = inventoryController.viewProductByID(id: id) {
            print("ID: \(product.id), Name: \(product.name), Description: \(product.description), Price: \(product.price), Stock Level: \(product.stockLevel)")
        } else {
            print("Product not found.")
        }
    }
    
    private func addNewProduct() {
        print("Enter product name:")
        guard let name = readLine() else { return }
        print("Enter product description:")
        guard let description = readLine() else { return }
        print("Enter product price:")
        guard let priceString = readLine(), let price = Double(priceString) else { return }
        print("Enter product stock level:")
        guard let stockLevelString = readLine(), let stockLevel = Int(stockLevelString) else { return }
        
        inventoryController.addNewProduct(name: name, description: description, price: price, stockLevel: stockLevel)
    }
    
    private func removeProductByID() {
        print("Enter the product ID to remove:")
        guard let idString = readLine(), let id = UUID(uuidString: idString) else {
            print("Invalid ID format.")
            return
        }
        
        inventoryController.removeProductByID(id: id)
    }
    
    private func updateProductInformation() {
        print("Enter the product ID to update:")
        guard let idString = readLine(), let id = UUID(uuidString: idString) else {
            print("Invalid ID format.")
            return
        }
        
        guard let product = inventoryController.viewProductByID(id: id) else {
            print("Product not found.")
            return
        }
        
        print("Enter new name (leave blank to keep current):")
        let name = readLine()
        print("Enter new description (leave blank to keep current):")
        let description = readLine()
        print("Enter new price (leave blank to keep current):")
        let priceString = readLine()
        let price = Double(priceString ?? "")
        print("Enter new stock level (leave blank to keep current):")
        let stockLevelString = readLine()
        let stockLevel = Int(stockLevelString ?? "")
        
        inventoryController.updateProductInformation(id: id, name: name, description: description, price: price, stockLevel: stockLevel)
    }
    
    private func viewLowStockProducts() {
        let products = inventoryController.viewLowStockProducts()
        for product in products {
            print("ID: \(product.id), Name: \(product.name), Price: \(product.price), Stock Level: \(product.stockLevel)")
        }
    }
    
    private func createNewOrder() {
        let order = inventoryController.createNewOrder()
        
        while true {
            print("""
                Order Menu:
                1. Add product to order
                2. Finalize order
                3. Cancel order
                """)
            
            guard let choice = readLine(), let option = Int(choice) else {
                print("Invalid choice. Please try again.")
                continue
            }
            
            switch option {
            case 1:
                addProductToOrder(order: order)
            case 2:
                inventoryController.finalizeOrder(order: order)
                print("Order finalized. Total price: \(order.totalPrice)")
                return
            case 3:
                print("Order cancelled.")
                return
            default:
                print("Invalid choice. Please try again.")
            }
        }
    }
    
    private func addProductToOrder(order: Order) {
        print("Enter the product ID:")
        guard let idString = readLine(), let id = UUID(uuidString: idString) else {
            print("Invalid ID format.")
            return
        }
        
        guard let product = inventoryController.viewProductByID(id: id) else {
            print("Product not found.")
            return
        }
        
        print("Enter quantity:")
        guard let quantityString = readLine(), let quantity = Int(quantityString) else {
            print("Invalid quantity.")
            return
        }
        
        inventoryController.addProductToOrder(order: order, productID: id, quantity: quantity)
    }
}
