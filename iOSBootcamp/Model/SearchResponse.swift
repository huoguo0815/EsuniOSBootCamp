//
//  SearchResponse.swift
//  iOSBootcamp
//
//  Created by esb23471 on 2023/7/11.
//

import Foundation

struct SearchItem: Hashable, Codable {
    var wrapperType: String
    var trackId: Int
    var trackName: String
    var artistName: String
    var artworkUrl100: URL
    var trackViewUrl: URL
    var description: String
    var kind: String
    var collectionName: String
    var trackTimeMillis: Int64
    var isFullDescriptionVisible: Bool = false
    
    
    
    
    //列舉所有資料，有不同的則輸入名字在rawValue
    enum CodingKeys: String, CodingKey {
        case wrapperType
        case trackName
        case artistName
        case artworkUrl100
        case trackViewUrl
        case description
        case kind
        case collectionName
    }
    
    //加入另一個enum列舉同一個資料的另一個名字
    enum AddKeys: String, CodingKey {
        case description = "longDescription"
        case collectionName = "collectionName"
    }
    
    enum IDKeys: Int, CodingKey {
        case trackId
        case trackTimeMillis
    }
        
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.wrapperType = try container.decode(String.self, forKey: .wrapperType)
        self.trackName = try container.decode(String.self, forKey: .trackName)
        self.artistName = try container.decode(String.self, forKey: .artistName)
        self.artworkUrl100 = try container.decode(URL.self, forKey: .artworkUrl100)
        self.trackViewUrl = try container.decode(URL.self, forKey: .trackViewUrl)
        self.kind = try container.decode(String.self, forKey: .kind)
        
        self.collectionName = (try? container.decode(String.self, forKey: .collectionName)) ?? ""
        
        if let description = try? container.decode(String.self, forKey: .description) {
            self.description = description
        } else {
            let container = try decoder.container(keyedBy: AddKeys.self)
            self.description = (try? container.decode(String.self, forKey: .description)) ?? ""
        }
        let IDcontainer = try decoder.container(keyedBy: IDKeys.self)
        self.trackId = try IDcontainer.decode(Int.self, forKey: .trackId)
        
        self.trackTimeMillis = (try? IDcontainer.decode(Int64.self, forKey: .trackTimeMillis)) ?? 0
    }
}

//所有資料
struct SearchResponse: Codable {
    let results: [SearchItem]
}
