import Foundation

class Database {
    static let shared = Database()
    private var orders: [UUID: Order] = [:]
    let filePath = "/Users/matvii/Desktop/Orders.csv"

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
            try csvContent.write(toFile: filePath, atomically: true, encoding: .utf8)
            print("Orders saved to \(filePath)")
        } catch {
            print("Error saving orders: \(error)")
        }
    }

    private func loadOrdersFromCSV() {
        guard let fileContents = try? String(contentsOfFile: filePath) else {
            print("No existing orders file found or unable to read.")
            return
        }

        let lines = fileContents.components(separatedBy: "\n").dropFirst()
        for line in lines where !line.isEmpty {
            let components = line.components(separatedBy: ",")
            if components.count == 3,
               let orderID = UUID(uuidString: components[0]),
               let totalPrice = Double(components[2]) {

                let productIDs = components[1].components(separatedBy: ";")
                                             .compactMap { UUID(uuidString: $0) }
                var loadedOrder = Order()
                loadedOrder.orderId = orderID
                loadedOrder.totalPrice = totalPrice

                loadedOrder.products = productIDs.compactMap { productID in
                    InventoryController().viewProductByID(id: productID)
                }

                orders[orderID] = loadedOrder
            } else {
                print("Warning: Skipping invalid line in CSV: \(line)")
            }
        }
    }
}
