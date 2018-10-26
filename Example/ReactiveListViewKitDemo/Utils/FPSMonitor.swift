//
//  FPSMonitor.swift
//
//  Created by Cheng Zhang on 10/24/18.
//  Copyright © 2018 LinkedIn. All rights reserved.
//

import UIKit

public protocol FPSMonitorDelegate: class {
    func framesDropped(_ framesDroppedCount: Double, cumulativeFramesDropped: Double, cumulativeFrameDropEvents: Int)
}

public class FPSMonitor: NSObject {
    fileprivate static let logPrefix = "[FPSMonitor]"
    fileprivate static let durationOffset: Double = 0.1

    fileprivate var lastTime: CFTimeInterval?
    fileprivate var count: Double = 0
    fileprivate var currentFrameDropCount: Double = 0
    fileprivate var currentFrameDropEventCount = 0
    fileprivate let workerQueue = DispatchQueue(label: "com.fps-monitor.serial")
    public weak var delegate: FPSMonitorDelegate?

    fileprivate lazy var displaylink: CADisplayLink = {
        let displaylink = CADisplayLink(target: self, selector: #selector(tick))
        displaylink.isPaused = true
        displaylink.add(to: .current, forMode: .commonModes)
        return displaylink
    }()

    public override init() {
        super.init()
        registerLifecyleNotifications()
    }

    deinit {
        displaylink.invalidate()
        NotificationCenter.default.removeObserver(self)
    }

    public func resume() {
        lastTime = nil
        displaylink.isPaused = false
    }

    public func pause() {
        displaylink.isPaused = true
    }

    @objc
    func tick(link: CADisplayLink) {
        workerQueue.async {
            guard let lastTime = self.lastTime else {
                self.lastTime = link.timestamp
                return
            }

            let duration = link.duration
            guard duration > 0 else {
                return
            }
            /**
             `duration` is regular duration between two frames, generally is 16ms for 60 FPS,
             link.timestamp - lastTime is time gap between last rendering and current rendering(Frame),
             `framesSinceLastRender` should be 1 for 60 FPS, if `framesSinceLastRender` islarger than 1, meaning there're frames dropped
             droppedFrames = framesSinceLastRender - 1
             */
            let framesSinceLastRender = self.roundDouble((link.timestamp - lastTime) / duration)
            self.lastTime = link.timestamp
            self.calculateDroppedFrames(framesSinceLastRender)
        }
    }

    @objc
    func notifyActive(_ notification: NSNotification) {
        resume()
    }

    @objc
    func notifyDeactive(_ notification: NSNotification) {
        pause()
    }

    public static func log(_ message: String) {
        print(FPSMonitor.logPrefix + " " + message)
    }
}

// MARK: - fileprivate methods

fileprivate extension FPSMonitor {
    func calculateDroppedFrames(_ framesSinceLastRender: Double) {
        let droppedFrameCount: Double = framesSinceLastRender - 1
        guard droppedFrameCount > FPSMonitor.durationOffset else {
            return
        }
        currentFrameDropCount += droppedFrameCount
        currentFrameDropEventCount += 1
        delegate?.framesDropped(
            droppedFrameCount,
            cumulativeFramesDropped: currentFrameDropCount,
            cumulativeFrameDropEvents: currentFrameDropEventCount)
    }

    func registerLifecyleNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(notifyActive(_:)),
            name: .UIApplicationDidBecomeActive,
            object: nil)

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(notifyDeactive(_:)),
            name: .UIApplicationWillResignActive,
            object: nil)
    }
    
    func roundDouble(_ number: Double) -> Double {
        return floor(number * 10) / 10
    }
}
