import Foundation
import Combine

public struct WebAgent {
    
    struct Response<T> {
        let value: T
        let response: URLResponse
    }
    
    func execute<T: Decodable>(_ request: URLRequest, session: URLSession = URLSession.shared,
                            decoder: JSONDecoder = JSONDecoder()) -> AnyPublisher<Response<T>, Error> {
        
        return session.dataTaskPublisher(for: request)
            .tryMap { result -> Response<T> in
                let value = try decoder.decode(T.self, from: result.data)
                return Response(value: value, response: result.response)
            }
            .subscribe(on: DispatchQueue.global())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
        
    }
    
}

public struct API {
    static let agent = WebAgent()
}
