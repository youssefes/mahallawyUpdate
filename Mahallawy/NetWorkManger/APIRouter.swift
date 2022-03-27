import Foundation
import Alamofire

protocol APIRouter: URLRequestConvertible {
    var method: HTTPMethod { get }
    var path: String  { get }
    var parameters: Parameters?  { get }
    var encoding: ParameterEncoding { get }
    var header : HTTPHeaders {get}

}

extension APIRouter {
    func asURLRequest() throws -> URLRequest {
        guard var url: URL = URL(string: NetworkConstants.baseUrl) else {
            throw OpportunitiesError.URLNotValid
        }
        url.appendPathComponent(path)
        
        let request = try URLRequest(url: url, method: method, headers: header)
        
        return try encoding.encode(request, with: parameters)
    }
}


enum OpportunitiesError: Error {
    case URLNotValid
}
