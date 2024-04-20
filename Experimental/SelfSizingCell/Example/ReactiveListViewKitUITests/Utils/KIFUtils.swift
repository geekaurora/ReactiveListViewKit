//
//  KIFUtils.swift
//
//  Created by Cheng Zhang on 2/6/17.
//  Copyright © 2017 Cheng Zhang. All rights reserved.
//

import KIF

extension XCTestCase {
    func tester(file : String = #file, _ line : Int = #line) -> KIFUITestActor {
        return KIFUITestActor(inFile: file, atLine: line, delegate: self)
    }
    
    func system(file : String = #file, _ line : Int = #line) -> KIFSystemTestActor {
        return KIFSystemTestActor(inFile: file, atLine: line, delegate: self)
    }
}

extension KIFTestActor {
    func tester(file : String = #file, _ line : Int = #line) -> KIFUITestActor {
        return KIFUITestActor(inFile: file, atLine: line, delegate: self)
    }
    
    func system(file : String = #file, _ line : Int = #line) -> KIFSystemTestActor {
        return KIFSystemTestActor(inFile: file, atLine: line, delegate: self)
    }
}

extension KIFUITestActor {
    /**
     Return View with given `accessibilityIdentifier` if present, nil otherwise
     
     - warning: Should specify accessibilityIdentifier, instead of accessibilityLabel
     */
    func view(withAccessibilityIdentifier accessibilityIdentifier: String) -> UIView? {
        var view: UIView?
        wait(for: nil, view: &view, withIdentifier: accessibilityIdentifier, tappable: false)
        return view
    }
}
