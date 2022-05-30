//
//  NetworkManager.swift
//
//  Created by E7.
//

import Foundation

class NetworkManager {
    let baseURL = "https://maps.googleapis.com/maps/api/"
    var requestHeader = NetworkEntity()
    var requestBodyParameters = NetworkEntity()
    var urlQueryParameters = NetworkEntity()
    var httpBody: Data?
    
    // MARK: - Public Methods
    func makeRequest(toURLPath urlPath: String, withContentType contentType: ContentType, withHttpMethod httpMethod: HttpMethod, completion: @escaping (_ result: Results) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            let targetURL = self?.addUrlQueryParameters(toURL: URL(string: self!.baseURL + urlPath)!)
            self?.requestHeader.add(value: contentType.rawValue, forKey: "Content-Type")
            let httpBody = self?.getHttpBody()
            
            guard let request = self?.prepareRequest(withURL: targetURL, httpBody: httpBody, httpMethod: httpMethod) else {
                completion(Results(withError: CustomError.failedToCreateRequest))
                return
            }
            
            let sessionConfiguration = URLSessionConfiguration.default
            let session = URLSession(configuration: sessionConfiguration)
            let task = session.dataTask(with: request) { (data, response, error) in
                completion(Results(withData: data,
                                   response: Response(fromURLResponse: response),
                                   error: error))
            }
            task.resume()
        }
    }
    
    func getData(fromURL url: URL, completion: @escaping (_ data: Data?) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async {
            let sessionConfiguration = URLSessionConfiguration.default
            let session = URLSession(configuration: sessionConfiguration)
            let task = session.dataTask(with: url) { (data, response, error) in
                guard let data = data else {
                    completion(nil)
                    return
                }
                completion(data)
            }
            task.resume()
        }
    }
    
    // MARK: - Private Methods
    private func addUrlQueryParameters(toURL url: URL) -> URL {
        if urlQueryParameters.totalItems() > 0 {
            guard var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false) else { return url }
            var items = [URLQueryItem]()
            for (key, value) in urlQueryParameters.allValue() {
                let item = URLQueryItem(name: key, value: value.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed))
                items.append(item)
            }
            urlComponents.queryItems = items
            
            guard let updateURL = urlComponents.url else { return url }
            return updateURL
        }
        
        return url
    }
    
    private func getHttpBody() -> Data? {
        guard let contentType = requestHeader.value(forKey: "Content-Type") else { return nil }
        
        if contentType.contains("application/json") {
            return try? JSONSerialization.data(withJSONObject: requestBodyParameters.allValue(), options: [.prettyPrinted, .sortedKeys])
        } else if contentType.contains("application/x-www-form-urlencoded") {
            let bodyString = requestBodyParameters.allValue().map {
                "\($0)=\(String(describing: $1.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)))"
            }.joined(separator: "&")
            return bodyString.data(using: .utf8)
        } else {
            return httpBody
        }
    }
    
    private func prepareRequest(withURL url: URL?, httpBody: Data?, httpMethod: HttpMethod) -> URLRequest? {
        guard let url = url else { return nil }
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod.rawValue
        
        for (header, value) in requestHeader.allValue() {
            request.setValue(value, forHTTPHeaderField: header)
        }
        
        request.httpBody = httpBody
        return request
    }
}

extension NetworkManager {
    enum ContentType: String {
        case none
        case json = "application/json"
        case formURLencoded = "application/x-www-form-urlencoded"
    }
    
    enum HttpMethod: String {
        case get
        case post
        case put
        case patch
        case delete
    }
    
    struct NetworkEntity {
        private var values: [String: String] = [:]
        
        mutating func add(value: String, forKey key: String) {
            values[key] = value
        }
        
        func value(forKey key: String) -> String? {
            return values[key]
        }
        
        func allValue() -> [String: String] {
            return values
        }
        
        func totalItems() -> Int {
            return values.count
        }
    }
    
    struct Response {
        var response: URLResponse?
        var httpStatusCode: Int = 0
        var headers = NetworkEntity()
        
        init(fromURLResponse response: URLResponse?) {
            guard let response = response else { return }
            self.response = response
            httpStatusCode = (response as? HTTPURLResponse)?.statusCode ?? 0
            
            if let headerFields = (response as? HTTPURLResponse)?.allHeaderFields {
                for (key, value) in headerFields {
                    headers.add(value: "\(value)", forKey: "\(key)")
                }
            }
        }
    }
    
    struct Results {
        var data: Data?
        var response: Response?
        var error: Error?
        
        init(withData data: Data?, response: Response?, error: Error?) {
            self.data = data
            self.response = response
            self.error = error
        }

        init(withError error: Error) {
            self.error = error
        }
    }
    
    enum CustomError: Error {
        case failedToCreateRequest
    }
}

// MARK: - Custom Error Description
extension NetworkManager.CustomError: LocalizedError {
    public var localizedDescription: String {
        switch self {
        case .failedToCreateRequest: return NSLocalizedString("Unable to create the URLRequest object", comment: "")
        }
    }
}
