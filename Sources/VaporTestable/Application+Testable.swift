//
//  Application+Testable.swift
//  VaporTestable
//
//  Created by Michael Housh on 8/1/18.
//
//  Credit: Adapted from: https://github.com/raywenderlich/vapor-til/

import Vapor

/// Add's testing functionality used to test routes in
/// `Vapor.Application`'s.
extension Application {
    
    /// Helper method for testing routes.
    public func sendRequest<T>(
        to path: String,
        method: HTTPMethod,
        headers: HTTPHeaders = .init(),
        body: T? = nil) throws -> Response where T: Content {
        
        var headers = headers
        
        if !headers.contains(name: .contentType) {
            headers.add(name: .contentType, value: "application/json")
        }
        
        let responder = try self.make(Responder.self)
        let request = HTTPRequest(method: method, url: URL(string: path)!, headers: headers)
        let wrappedRequest = Request(http: request, using: self)
        if let body = body {
            try wrappedRequest.content.encode(body)
        }
        return try responder.respond(to: wrappedRequest).wait()
    }
    
    /// Helper method for testing routes.
    public func getResponse<C, T>(
        to path: String,
        method: HTTPMethod = .GET,
        headers: HTTPHeaders = .init(),
        data: C? = nil, decodeTo type: T.Type) throws -> T where C: Content, T: Decodable {
        let response = try self.sendRequest(to: path, method: method, headers: headers, body: data)
        return try response.content.decode(type).wait()
    }
    
    /// Helper method for testing routes.
    public func getResponse<T>(to path: String, method: HTTPMethod = .GET, headers: HTTPHeaders = .init(), decodeTo type: T.Type) throws -> T where T: Content {
        let emptyContent: EmptyContent? = nil
        return try self.getResponse(to: path, method: method, headers: headers, data: emptyContent, decodeTo: type)
    }
    
    /// Helper method for testing routes.
    public func sendRequest(to path: String, method: HTTPMethod, headers: HTTPHeaders = .init()) throws -> Response {
        let emptyContent: EmptyContent? = nil
        return try sendRequest(to: path, method: method, headers: headers, body: emptyContent)
    }

}

public struct EmptyContent: Content {}

