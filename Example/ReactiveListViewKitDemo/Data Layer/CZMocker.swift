//
//  CZMocker.swift
//  ReactiveListViewKit
//
//  Created by Cheng Zhang on 1/12/17.
//  Copyright © 2017 Cheng Zhang. All rights reserved.
//

import CZUtils
import CZNetworking
import ReactiveListViewKit

class CZMocker: NSObject {
    static let shared = CZMocker()

    /// Mocked feeds with JSON file
    var feeds: [Feed] {
        do {
            let jsonFileUrl = Bundle.main.url(forResource: "feeds", withExtension: "json")!
            let jsonData = try Data(contentsOf: jsonFileUrl)
            guard let feedsArray = CZHTTPJsonSerializer.deserializedObject(with: jsonData) as? [CZDictionary] else {
                preconditionFailure("Invalid JSON file format.")
            }
            return feedsArray.flatMap{ Feed(dictionary: $0) }
        } catch {
            assertionFailure("Failed to load JSON file. Error - \(error.localizedDescription)")
        }
        return []
    }
    
    /// Mocked hotUsers
    var hotUsers: [User] {
        let portraitUrls = [
            "https://d37t5b145o82az.cloudfront.net/portriats/fallinlight.jpg",
            "https://d37t5b145o82az.cloudfront.net/portriats/caeliyt.jpg",
            "https://d37t5b145o82az.cloudfront.net/portriats/pixlr.jpg",
            "https://d37t5b145o82az.cloudfront.net/portriats/zayn.jpg",
            "https://d37t5b145o82az.cloudfront.net/portriats/martingarrix.jpg",
            "https://d37t5b145o82az.cloudfront.net/portriats/mariale.jpg",
            "https://d37t5b145o82az.cloudfront.net/portriats/picsart_ediitor.jpg",
            "https://d37t5b145o82az.cloudfront.net/portriats/picsart_indo.jpg",
            "https://d37t5b145o82az.cloudfront.net/portriats/fetching_tigerss.jpg",
            "https://d37t5b145o82az.cloudfront.net/portriats/ppteamlesslie.jpg"
            ]
        let userNameTuples = [
            ("fallinlight","Diane"),
            ("caeliyt","Caeli"),
            ("pixlr","Pixlr"),
            ("zayn","Zayn Malik"),
            ("martingarrix","Martin Garrix"),
            ("mariale","Mariale Marrero"),
            ("picsart_ediitor","Picsart Editor"),
            ("picsart_indo","Tutorial edit PicsArt"),
            ("fetching_tigerss","Annegien"),
            ("ppteamlesslie","Lesslie Polinesia")
            ]

        var res = [User]()
        for i in 0 ..< min(portraitUrls.count, userNameTuples.count) {
            res.append(User(dictionary: ["id": String(i),
                                         "username": userNameTuples[i].0,
                                         "full_name": userNameTuples[i].1,
                                         "profile_picture": portraitUrls[i]]))
        }
        return res
    }
}
