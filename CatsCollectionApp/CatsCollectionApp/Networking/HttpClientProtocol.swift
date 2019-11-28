//
//  APIClient.swift
//  CatsCollectionApp
//
//  Created by Naina Soni on 12/11/2019.
//  Copyright © 2019 Naina Soni. All rights reserved.
//

import Foundation

enum APIError: Error {
    case unknown, badResponse, jsonDecoder, imageDownload, imageConvert
}

struct HttpMethodType {
    static let GET = "GET"
    static let POST = "POST"
}

protocol HttpClientProtocol {
    func getData<T: Codable>(with request: PhotoRequest, resultType: T.Type, completion: @escaping (_ result: T?) -> Void)
    func getData(with Url: URL, completion: @escaping(_ data: Data?) -> Void)
}


struct HttpClient : HttpClientProtocol {

    func getData(with Url: URL, completion: @escaping (Data?) -> Void) {

        URLSession.shared.dataTask(with: Url) { (serviceData, serviceResponse, _) in

            if(serviceData != nil && serviceData?.isEmpty == false)
            {
                _=completion(serviceData)
            }
            else
            {
                debugPrint("Response received from server for bad request = \(String.init(data: serviceData!, encoding: String.Encoding.utf8)!)")
                _=completion(nil)

            }}.resume()
    }

    func getData<T>(with request: PhotoRequest, resultType: T.Type, completion: @escaping (_ result: T?) -> Void) where T : Decodable, T : Encodable {

        let urlRequest = getURLRequest(endPoint: request)

        URLSession.shared.dataTask(with: urlRequest) { (serviceData, serviceResponse, _) in

            if(serviceData != nil && serviceData?.isEmpty == false)
            {
                _=completion(self.decodeServerResponse(resultType: resultType, serviceResponse: serviceData))
            }
            else
            {
                debugPrint("Response received from server for bad request = \(String.init(data: serviceData!, encoding: String.Encoding.utf8)!)")
                _=completion(nil)
            }}.resume()
    }

    // MARK: Private method
    //This method creates the URLRequest for the service
    private func getURLRequest(endPoint:PhotoRequest) -> URLRequest{

        var urlRequest = URLRequest(url: getUrlComponents(request: endPoint).url!, cachePolicy: .reloadIgnoringCacheData, timeoutInterval: 60.0)
        urlRequest.httpMethod = HttpMethodType.GET
        urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        urlRequest.setValue("application/json;charset=utf-8", forHTTPHeaderField: "Content-Type")
        //todo: the api key needs to be salted
        urlRequest.setValue("baf9540c-f0a8-4fee-828e-e0d6dbb7e472", forHTTPHeaderField:"x-api-key")
        return urlRequest
    }

    private func getUrlComponents(request: PhotoRequest) -> URLComponents{
        
        var urlComponent = URLComponents(string: CatApi.baseUrl)
        urlComponent?.queryItems = request.ToURLQueryItem()
        return urlComponent!
    }

    //This method decodes the JSON received from the server and uses generics to return a concerete type to the caller
    private func decodeServerResponse<T: Codable>(resultType: T.Type, serviceResponse: Data?) -> T? {
        do {
            let decoder = JSONDecoder()

            let decodedResponse = try decoder.decode(T.self, from: serviceResponse!)
            return decodedResponse
        } catch let jsonError
        {
            debugPrint("Response received from server for bad parsing = \(String.init(data: serviceResponse!, encoding: String.Encoding.utf8)!)")
            debugPrint("Error decoding Json", jsonError)
        }
        return nil
    }

}
