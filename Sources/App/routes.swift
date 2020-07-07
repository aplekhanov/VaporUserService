import Vapor

func routes(_ app: Application) throws {
    app.get([.anything, "serviceName", "health"]) { req in
        return "OK"
    }
}
