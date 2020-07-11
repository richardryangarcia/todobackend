//
//  File.swift
//  
//
//  Created by Garcia,Richard on 7/5/20.
//


func initializeCodableRoutes(app:App){
    let router = app.router
    router.get("/healthcheck") { request, response, next in
        response.send("Hello bruh!")
        next()
    }
    
}
