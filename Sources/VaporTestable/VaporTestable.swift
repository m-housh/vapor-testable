//
//  VaporTestable.swift
//  VaporTestable
//
//  Created by Michael Housh on 8/1/18.
//

import Vapor
import XCTest

/// Add's the `perform` helper method, to catch errors in tests.
/// Credit: Adapted from: https://github.com/gtranchedone/vapor-testing-template
extension XCTestCase {
    
    /// Fail on error.
    public func perform(_ closure: () throws -> ()) {
        do {
            try closure()
        } catch {
            XCTFail("\n\n😱 Error => \(error) 😱\n\n")
        }
    }
}

public protocol VaporTestable {
    
    /// The main `Config` to use for the testable
    /// `Application`.
    func config() -> Config
    
    /// The main `Services` to use for the testable
    /// `Application`
    func services() throws -> Services
    
    /// Register routes for the `Application`.
    func routes(_ router: Router) throws -> ()
    
    /// Add custom boot functionality.
    func boot(_ app: Application) throws -> ()
    
    /// Configure the testable `Application`
    func configure(_ config: inout Config, _ env: inout Environment, _ services: inout Services) throws -> ()
    
    /// Create's the application based on above values.
    func makeApplication(_ envArgs: [String]?) throws -> Application
    
    /// Helper to revert database's after tests.
    func revert() throws -> ()
    
}

/// Default implementation
extension VaporTestable {
    
    public func config() -> Config {
        return Config.default()
    }
    
    public func services() throws -> Services {
        return Services.default()
    }
    
    public func routes(_ router: Router) throws {
        return
    }
    
    public func boot(_ app: Application) throws {
        return
    }
    
    public func configure(_ config: inout Config, _ env: inout Environment, _ services: inout Services) throws {
        /// Register providers first.
        
        /// Register routes
        let router = EngineRouter.default()
        try routes(router)
        services.register(router, as: Router.self)
        
        /// Register middlewares
        var middlewares = MiddlewareConfig()
        middlewares.use(ErrorMiddleware.self)
        services.register(middlewares)
    }
    
    public func makeApplication(_ envArgs: [String]? = nil) throws -> Application {
        
        var env = Environment.testing
        
        if let arguments = envArgs {
            env.arguments = arguments
        }
        
        var services = try self.services()
        var config = self.config()
        try configure(&config, &env, &services)
        let app = try Application(config: config, environment: env, services: services)
        try boot(app)
        return app
    }
    
    public func revert() throws {
        let resetArgs = ["vapor", "revert",  "--all", "-y"]
        try makeApplication(resetArgs).asyncRun().wait()
        let migrateEnvironment = ["vapor", "migrate", "-y"]
        try makeApplication(migrateEnvironment).asyncRun().wait()
    }
}
