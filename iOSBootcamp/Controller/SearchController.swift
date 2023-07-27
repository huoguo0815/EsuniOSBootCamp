//
//  SearchController.swift
//  iOSBootcamp
//
//  Created by esb23471 on 2023/7/13.
//

import UIKit
import AFNetworking
import Foundation
import SDWebImage

class SearchController {
    
    static let shared = SearchController()
    
    func fetchItems(matching query: [String: String], completion: @escaping (Result<[SearchItem], Error>) -> ()) {
        var urlComponents = URLComponents(string: "https://itunes.apple.com/search")!
        urlComponents.queryItems = query.map{URLQueryItem(name: $0.key, value: $0.value)}
        
        //print(urlComponents)
        
        let manager = AFHTTPSessionManager()
        
        //print(manager)
        
        manager.get(urlComponents.url!.absoluteString, parameters: nil, headers: nil, progress: nil, success: { (task, responseObject) in
            //print("The type of responseObject is ",type(of: responseObject!))
            let Object = self.jsonToData(jsonDic: responseObject as! NSDictionary)
            //print("The type of responseObject is ",type(of: Object!))
            if let data = Object {
                //print(Object!)
                do {
                    let searchResponse = try JSONDecoder().decode(SearchResponse.self, from: data)
                    //print(searchResponse)
                    completion(.success(searchResponse.results))
                } catch {
                    completion(.failure(error))
                    print(error)
                }
            } else {
                let error = NSError(domain: "Invalid response", code: 0, userInfo: nil)
                completion(.failure(error))
            }
        }) { (task, error) in
            completion(.failure(error))
        }
    }
    
    func jsonToData(jsonDic: NSDictionary) -> Data? {
        let data = try? JSONSerialization.data(withJSONObject: jsonDic, options: [])
        //print("The type of responseObject is ",type(of: data!))
        return data!
    }

}
