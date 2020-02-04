//
//  NetworkProtocol.swift
//  lmdemo
//
//  Created by kartik on 03/02/20.
//  Copyright © 2020 nag. All rights reserved.
//

import Foundation
import UIKit

class RemoteClient: RemoteClientProtocol {
    var query: String?
    var queryItems: [URLQueryItem]?
    var params: [String : Any]?
    var headers: [String : String]?
    var session: URLSession!
    
    init() {
        let  downloadQueue:OperationQueue = {
            let queue = OperationQueue()
            queue.name = "Download queue"
            queue.maxConcurrentOperationCount = 1
            return queue
        }()
        self.session = URLSession(configuration: .default, delegate: nil, delegateQueue: downloadQueue)
    }
    
}

protocol RemoteClientProtocol {
    var query: String? { get set }
    var queryItems: [URLQueryItem]? { get set}
    var params: [String: Any]? { get set }
    var headers: [String: String]? { get set}
    var session: URLSession! {get set}
    func fetch<T: Decodable>(with urlComponent: URLComponents, httpMethod: HTTPMethod, decodingType:T.Type, completion: @escaping(Result<T, APIResponseError>) -> Void)
}

extension RemoteClientProtocol {
    
    func fetch<T: Decodable>(with urlComponent: URLComponents, httpMethod: HTTPMethod, decodingType:T.Type, completion: @escaping(Result<T, APIResponseError>) -> Void) {
        let urlRequest = createRequest(with: urlComponent, httpMethod: httpMethod, query: self.query, queryItems: self.queryItems, headers: self.headers, params: self.params)
        let task = session.dataTask(with: urlRequest) { (data, response, error) in
            guard  let urlResponse = response as? HTTPURLResponse
                else {
                    finishRequest(with: .failure(.requestFailed))
                    return
            }
            if urlResponse.statusCode == 200 {
                if let data = data {
                    do {
                        let decodedData = try JSONDecoder().decode(decodingType, from: data)
                        finishRequest(with: .success(decodedData))
                    } catch {
                        finishRequest(with: .failure(.jsonConversionFailure))
                    }
                } else {
                    finishRequest(with: .failure(.invalidData))
                }
            } else {
                urlResponse.statusCode == 500 ? finishRequest(with: .failure(.internalServerError)) : finishRequest(with: .failure(.responseFailed))
            }
        }
        task.resume()
        
        func finishRequest(with result: (Result<T, APIResponseError>)) {
            DispatchQueue.main.async {
               let _ = completion(result)
            }
        }
    }
    
    private func createRequest(with urlComponent: URLComponents, httpMethod: HTTPMethod, query: String?, queryItems: [URLQueryItem]?, headers: [String: String]?, params: [String: Any]?) -> URLRequest {
        var urlComponent = urlComponent
        if let query = query {
            urlComponent.path = urlComponent.path + "/\(query)"
        }
        urlComponent.queryItems = queryItems
        var request = URLRequest(url: urlComponent.url!)
        request.httpMethod = httpMethod.rawValue
        request.allHTTPHeaderFields = headers
        if let params = params {
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject:  params)
            } catch {
                fatalError("Not valid parameters")
            }
        }
        return request
    }
    
}
