import Foundation

class UserInterface {
    private let inventoryController = InventoryController()
    
    func run() {
        print("Welcome to Anya Baluvana's Inventory System")
        
        while true {
            displayMainMenu()
            
            guard let choice = readLine(), let option = Int(choice) else {
                print("Invalid choice. Please try again.")
                continue
            }
            
            switch option {
            case 1: viewAllProducts()
            case 2: viewProductByID()
            case 3: addNewProduct()
            case 4: removeProductByID()
            case 5: updateProductInformation()
            case 6: viewLowStockProducts()
            case 7: createNewOrder()
            case 8: viewAllOrders()
            case 9: viewOrderByID()
            case 10:
                print("Goodbye!")
                return
            default:
                print("Invalid choice. Please try again.")
            }
        }
    }
    
    private func displayMainMenu() {
        print("""
            Please choose an option:
            1. View all products
            2. View a product by ID
            3. Add a new product
            4. Remove a product by ID
            5. Update product information
            6. View low stock products
            7. Create a new order
            8. View all orders
            9. View order by ID
            10. Exit
            """)
    }
    
    private func viewAllProducts() {
        let products = inventoryController.viewAllProducts()
        if products.isEmpty {
            print("No products found.")
        } else {
            for product in products {
                print("ID: \(product.id), Name: \(product.name), Price: \(product.price), Stock Level: \(product.stockLevel)")
            }
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
        guard let priceString = readLine(), let price = Double(priceString) else {
            print("Invalid price format. Please enter a valid number.")
            return
        }
        print("Enter product stock level:")
        guard let stockLevelString = readLine(), let stockLevel = Int(stockLevelString) else {
            print("Invalid stock level format. Please enter a valid number.")
            return
        }
        
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
        if products.isEmpty {
            print("No products found with low stock.")
        } else {
            for product in products {
                print("ID: \(product.id), Name: \(product.name), Price: \(product.price), Stock Level: \(product.stockLevel)")
            }
        }
    }
    
    private func createNewOrder() {
        let order = Order()
        
        while true {
            displayOrderMenu()
            
            guard let choice = readLine(), let option = Int(choice) else {
                print("Invalid choice. Please try again.")
                continue
            }
            
            switch option {
            case 1: addProductToOrder(order: order)
            case 2:
                finalizeOrder(order: order)
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
    
    private func displayOrderMenu() {
        print("""
            Order Menu:
            1. Add product to order
            2. Finalize order
            3. Cancel order
            """)
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
        
        order.addProduct(product: product, quantity: quantity)
        print("Product added to order.")
    }
    
    private func finalizeOrder(order: Order) {
        inventoryController.finalizeOrder(order: order)
    }

    private func viewAllOrders() {
        let orders = OrderDatabase.shared.getAllOrders()
        if orders.isEmpty {
            print("No orders found.")
        } else {
            for order in orders {
                print("Order ID: \(order.orderId), Total Price: \(order.totalPrice)")
                print("Products:")
 
                if order.products.isEmpty {
                    print("  - No products found for this order (may be deleted).")
                } else {
                    for product in order.products {
                        print("  - \(product.name) (ID: \(product.id))")
                    }
                }

                print("--------------------")
            }
        }
    }

    private func viewOrderByID() {
        print("Enter the order ID:")
        guard let idString = readLine(), let id = UUID(uuidString: idString) else {
            print("Invalid ID format.")
            return
        }

        if let order = OrderDatabase.shared.getOrder(byID: id) {
            print("Order ID: \(order.orderId), Total Price: \(order.totalPrice)")
            print("Products:")
            for product in order.products {
                print("- \(product.name) (ID: \(product.id))")
            }
        } else {
            print("Order not found.")
        }
    }
}
