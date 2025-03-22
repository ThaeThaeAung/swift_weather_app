//
//  NetworkManager.swift
//  WeatherAppAssignment
//
//  Created by Thae Thae on 11/2/25.
//

import Foundation
import Alamofire
//struct MyData : Decodable {
//    
//}
//class NetworkManager {
//    static func request<T:Decodable>(urlString : String,
//method : HTTPMethod,
// parameters : Encodable, encoder : ParameterEncoder,header: Encodable?,completion: @escaping (T?, Int?, Error?) -> Void) {
//        guard let url = URL(string: urlString) else{
//            print("Invalid URL")
//            return
//        }
//        AF.request(url,
//                          method: method,
//                          parameters: parameters,
//                          encoder: encoder,
//                          headers: [])
//                   .validate(statusCode: 200..<300)
//                   .responseDecodable(of: T.self) { response in
//                       print(response)
//                       completion(response.value, response.response?.statusCode, response.error)
//                   }
//    }
//}
class NetworkManager {

    static func request<T: Decodable>(urlString: String,
                                      method: HTTPMethod,
                                      parameters: Encodable,
                                      encoder: ParameterEncoder = .urlEncodedForm,
                                      header: Encodable?,
                                      completion: @escaping (T?, Int?, Error?) -> Void) {

        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }

        AF.request(url,
                   method: method,
                   parameters: parameters,
                   encoder: encoder,
                   headers: [])
            .validate(statusCode: 200..<300)
            .responseDecodable(of: T.self) { response in
                print(response)
                completion(response.value, response.response?.statusCode, response.error)
            }
    }
}
