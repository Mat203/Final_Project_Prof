import Foundation

class Database {
    static let shared = Database()
    private var orders: [UUID: Order] = [:]
    let ordersFilePath = "/Users/matvii/Desktop/Orders.csv"
    let productsFilePath = "/Users/matvii/Desktop/Products.csv"

    private init() {
        loadOrdersFromCSV()
    }

    func saveOrder(order: Order) {
        orders[order.orderId] = order
        saveOrdersToCSV()
    }

    func getAllOrders() -> [Order] {
        return Array(orders.values)
    }

    func getOrder(byID id: UUID) -> Order? {
        return orders[id]
    }

    private func saveOrdersToCSV() {
        var csvContent = "Order ID,Product IDs,Total Price\n"
        for order in getAllOrders() {
            let productIDs = order.products.map { $0.id.uuidString }.joined(separator: ";")
            csvContent += "\(order.orderId.uuidString),\(productIDs),\(order.totalPrice)\n"
        }

        do {
            try csvContent.write(toFile: ordersFilePath, atomically: true, encoding: .utf8)
            print("Orders saved to \(ordersFilePath)")
        } catch {
            print("Error saving orders: \(error)")
        }
    }

    private func loadOrdersFromCSV() {
            guard let fileContents = try? String(contentsOfFile: ordersFilePath) else {
                print("No existing orders file found or unable to read.")
                return
            }

            // 1. Load Products First
            let loadedProducts = loadProductsFromCSV()

            let lines = fileContents.components(separatedBy: "\n").dropFirst()
            for line in lines where !line.isEmpty {
                let components = line.components(separatedBy: ",")
                
                // 2. Validate CSV Line
                if components.count == 3,
                   let orderID = UUID(uuidString: components[0]),
                   let totalPrice = Double(components[2]) {

                    // 3. Extract Product IDs
                    let productIDs = components[1].components(separatedBy: ";")
                                                 .compactMap { UUID(uuidString: $0) }
                    
                    
                    // 4. Create Order Object
                    var loadedOrder = Order()
                    loadedOrder.orderId = orderID
                    loadedOrder.totalPrice = totalPrice

                    // 5. Match Products from Loaded Products
                    loadedOrder.products = productIDs.compactMap { productID in
                        loadedProducts.first { $0.id == productID }
                    }
                    // 6. Add to Orders Dictionary
                    orders[orderID] = loadedOrder
                } else {
                    print("Warning: Skipping invalid line in CSV: \(line)")
                }
            }
        }
    
    func saveProductToCSV(product: Product) {
        let csvLine = "\(product.id.uuidString),\"\(product.name)\",\"\(product.description)\",\(product.price),\(product.stockLevel)\n"

        do {
            if let fileHandle = FileHandle(forUpdatingAtPath: productsFilePath) {
                fileHandle.seekToEndOfFile()
                fileHandle.write(csvLine.data(using: .utf8)!)
                fileHandle.closeFile()
                print("Product \(product.name) saved to \(productsFilePath)")
            } else {
                let header = "ID,Name,Description,Price,Stock Level\n"
                try header.write(toFile: productsFilePath, atomically: true, encoding: .utf8)
                try csvLine.write(toFile: productsFilePath, atomically: true, encoding: .utf8)
            }
        } catch {
            print("Error saving product: \(error)")
        }
    }
    
    func loadProductsFromCSV() -> [Product] {
            var loadedProducts: [Product] = []

            guard let fileContents = try? String(contentsOfFile: productsFilePath) else {
                print("No existing products file found or unable to read.")
                return loadedProducts
            }

            let lines = fileContents.components(separatedBy: "\n").dropFirst()
            for line in lines where !line.isEmpty {
                let components = line.components(separatedBy: ",")
                if components.count == 5,
                   let id = UUID(uuidString: components[0]),
                   let price = Double(components[3]),
                   let stockLevel = Int(components[4]) {

                    let name = components[1].removingSurroundingQuotes()
                    let description = components[2].removingSurroundingQuotes()

                    let product = Product(id: id, name: name,
                                          description: description,
                                          price: price,
                                          stockLevel: stockLevel)
                    loadedProducts.append(product)
                } else {
                    print("Warning: Skipping invalid line in CSV: \(line)")
                }
            }

            return loadedProducts
        }
}

extension String {
    func removingSurroundingQuotes() -> String {
        return self.trimmingCharacters(in: CharacterSet(charactersIn: "\""))
    }
}

