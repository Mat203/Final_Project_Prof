import Foundation

class Database {
    static let shared = Database()
    private var orders: [UUID: Order] = [:]
    
    private init() {}
    
    func saveOrder(order: Order) {
        orders[order.orderId] = order
    }
}
