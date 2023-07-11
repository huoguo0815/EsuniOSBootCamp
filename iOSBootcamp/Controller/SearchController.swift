//
//  SearchController.swift
//  iOSBootcamp
//
//  Created by esb23471 on 2023/7/11.
//

import UIKit

class SearchController: UISearchController {
    
    static let shared = SearchController()
    
    //抓資料
    func fethItems(matching query:[String: String], completion: @escaping (Result<[SearchItem], Error>) ->()) {
        var urlComponents = URLComponents(string: "https://itunes.apple.com/search")!
        urlComponents.queryItems = query.map{URLQueryItem(name: $0.key, value: $0.value)}
        URLSession.shared.dataTask(with: urlComponents.url!) {
            (data, respones, error) in
            if let data = data {
                do {
                    let searchResponse = try JSONDecoder
                }
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    


}
