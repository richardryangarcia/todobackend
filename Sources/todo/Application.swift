//
//  File.swift
//  
//
//  Created by Garcia,Richard on 7/5/20.
//

import Foundation
import Dispatch
import Kitura
import KituraOpenAPI
import KituraCORS
import SwiftKueryORM
import SwiftKueryPostgreSQL

public class App {
    let router: Router
    private var nextId: Int = 0
    private let workerQueue = DispatchQueue(label: "worker")
    
    public init(){
        router = Router()
    }
    
    public func initializeRouter() {
        router.get("/healthcheck") { request, response, next in
            response.send("Hello brahhh!")
            next()
        }
        
        router.post("/", handler: storeHandler)
        
        router.delete("/", handler: deleteAllHandler)
        
        router.get("/", handler: getAllHandler)
        
        router.get("/", handler: getOneHandler)
        
        router.patch("/", handler: updateHandler)
        
        router.delete("/", handler: deleteOneHandler)

        
        KituraOpenAPI.addEndpoints(to: router)
        let options = Options(allowedOrigin: .all)
        let cors = CORS(options: options)
        router.all("/*", middleware: cors)
    }
    
    func postInit() {
        Persistance.setUp();
        do {
            try ToDo.createTableSync()
        } catch let error {
            print("Table already exists. Error: \(String(describing: error))")
        }
    }
    
    func deleteOneHandler(id: Int, completion: @escaping (RequestError?) -> Void ) {
        ToDo.delete(id: id, completion)
    }
    
    func updateHandler(id: Int, new: ToDo, completion: @escaping (ToDo?, RequestError?) -> Void ) {
        ToDo.find(id:id) { (prexistingToDo, error) in
            if error != nil {
                return completion(nil, .notFound)
            }
            
            guard var oldToDo = prexistingToDo else {
                return completion(nil, .notFound)
            }
            
            guard let id = oldToDo.id else {
                return completion(nil, .internalServerError)
            }
            
            oldToDo.user = new.user ?? oldToDo.user
            oldToDo.order = new.order ?? oldToDo.order
            oldToDo.title = new.title ?? oldToDo.title
            oldToDo.completed = new.completed ?? oldToDo.completed
            
            oldToDo.update(id: id, completion)
        }
        
    }
    
    func getOneHandler(id: Int, completion: @escaping (ToDo?, RequestError?) -> Void ) {
        ToDo.find(id: id, completion)
    }
    
    func getAllHandler(completion: @escaping ([ToDo]?, RequestError?) -> Void ) {
        ToDo.findAll(completion)
    }
    
    func deleteAllHandler(completion: @escaping (RequestError?) -> Void ) {
        ToDo.deleteAll(completion)
    }

    func storeHandler(todo: ToDo, completion: @escaping (ToDo?, RequestError?) -> Void){
        var todo = todo
        if(todo.completed == nil){
            todo.completed = false
        }
        todo.id = nextId
        todo.url = "http://localhost:8080/\(nextId)"
        nextId += 1
        todo.save(completion)
    }
    
    public func run() throws {
        initializeRouter()
        postInit()
        Kitura.addHTTPServer(onPort: 8080, with: router)
        Kitura.run()
    }
    
    public func execute(_ block: (() -> Void)) {
        workerQueue.sync {
            block()
        }
    }
    
}

extension ToDo: Model {
}

class Persistance {
    static func setUp(){
        let pool = PostgreSQLConnection.createPool(host: "postgresql-database", port: 5432, options: [.databaseName("tododb"), .userName("postgres"),.password(ProcessInfo.processInfo.environment["DBPASSWORD"] ?? "")], poolOptions: ConnectionPoolOptions(initialCapacity: 10, maxCapacity: 50))
        Database.default = Database(pool)
    }
}
