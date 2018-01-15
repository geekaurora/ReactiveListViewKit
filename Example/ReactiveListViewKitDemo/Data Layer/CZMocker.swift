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
            "https://scontent.cdninstagram.com/t51.2885-19/s150x150/15876365_735808813238573_5209783394333884416_n.jpg",
            "https://scontent.cdninstagram.com/t51.2885-19/s150x150/17932205_1873589956192972_4070576927188975616_a.jpg",
            "https://scontent.cdninstagram.com/t51.2885-19/11848925_1533801120173991_2075936696_a.jpg",
            "https://scontent.cdninstagram.com/t51.2885-19/s320x320/12976159_1725524527701278_1667923884_a.jpg",
            "https://scontent.cdninstagram.com/t51.2885-19/s320x320/12346207_957997364275563_865945097_a.jpg",
            "https://scontent.cdninstagram.com/t51.2885-19/10986348_437266659769074_1534648574_a.jpg",
            "https://scontent.cdninstagram.com/t51.2885-19/s150x150/20766151_129416397674687_1011941475153346560_n.jpg",
            "https://scontent.cdninstagram.com/t51.2885-19/s320x320/12093737_1642531946014435_1468116990_a.jpg",
            "https://scontent.cdninstagram.com/t51.2885-19/17495183_276607699428941_346402392461279232_a.jpg",
            "https://scontent.cdninstagram.com/t51.2885-19/s320x320/14733622_204530439986130_324838435409887232_a.jpg",
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
            ("ppteamlesslie","Lesslie Polinesia"),
            ("pics_go_art","Pics Go Art!"),
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
