import Foundation
import LoggerAPI

do {
    let app = App()
    try app.run()
} catch let error {
    Log.error(error.localizedDescription)
}
