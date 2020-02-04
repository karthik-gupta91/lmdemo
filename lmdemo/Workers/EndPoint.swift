//
//  EndPoint.swift
//  lmdemo
//
//  Created by kartik on 03/02/20.
//  Copyright © 2020 nag. All rights reserved.
//

import Foundation

protocol EndPoint {
    var baseURL: String { get }
    var path: String { get }
    var httpMethod: HTTPMethod { get }
}

extension EndPoint {
    var urlComponent: URLComponents {
        guard var component = URLComponents(string: baseURL)  else {
            fatalError("Not a valid path")
        }
        component.path = path
        return component
    }
}

enum ApiResource: String {
    case mostViewed = "/svc/mostpopular/v2/viewed/"
}

extension ApiResource: EndPoint {
    var httpMethod: HTTPMethod {
        switch self {
        default:
            return .get
        }
    }
    
    var baseURL: String {
        return "https://api.nytimes.com"
    }

    var path: String {
        return self.rawValue
    }
}

public enum APIResponseError: Error, LocalizedError {
    case requestFailed
    case jsonConversionFailure
    case invalidData
    case responseFailed
    case jsonParsingFailure
    case internalServerError
    
    public var errorDescription: String? {
        switch self {
        case .requestFailed: return "Request Failed"
        case .invalidData: return "Invalid Data"
        case .responseFailed: return "Response Unsuccessful"
        case .jsonParsingFailure: return "JSON Parsing Failure"
        case .jsonConversionFailure: return "JSON Conversion Failure"
        case .internalServerError: return "Internal Server error"
        }
    }
}

enum AppError: Error {
    case networkError
    case decodingError
    
    public var errorDescription: String {
        switch self {
        case .networkError:
            return NSLocalizedString("Network error occured, please try again", comment: "")
        case .decodingError:
            return NSLocalizedString("Unable to decode, please try again", comment: "")
        }
    }
}

enum HTTPMethod : String {
    case get     = "GET"
    case post    = "POST"
}

enum Result<T, U> where U: Error  {
    case success(T)
    case failure(U)
}
