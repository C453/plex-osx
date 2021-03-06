//
//  WindowController.swift
//  Netflix
//
//  Created by Case Wright on 11/25/15.
//  Copyright © 2015 Case Wright. All rights reserved.
//

import Cocoa

class WindowController: NSWindowController, NSWindowDelegate {
    
    var fullScreen: Bool = false
    var aspectRatio: CGFloat = 0

    override func windowDidLoad() {
        Static.windowController = self
        self.window?.titleVisibility = NSWindowTitleVisibility.Hidden
        self.window?.titlebarAppearsTransparent = true
        self.window?.movableByWindowBackground = true
        self.window?.makeKeyAndOrderFront(self)
        self.window?.alphaValue = CGFloat(NSUserDefaults.standardUserDefaults().floatForKey("windowOpacity"))
        
        if(NSUserDefaults.standardUserDefaults().integerForKey("alwaysOnTop") == 1) {
            self.window?.level =  Int(CGWindowLevelForKey(.FloatingWindowLevelKey))
        }
        
        super.windowDidLoad()
    }
    
    override func mouseEntered(theEvent: NSEvent) {
        self.window?.setTitleBarHidden(false)
    }
    
    override func mouseExited(theEvent: NSEvent) {
        self.window?.setTitleBarHidden(true)
    }
    
    func windowShouldClose(sender: AnyObject) -> Bool {
        if(window?.contentView is wview) {
            (window?.contentView as! wview).saveLocalData()
        }
        return true
    }
    
    func windowWillEnterFullScreen(notification: NSNotification) {
        fullScreen = true
    }
    
    func windowDidExitFullScreen(notification: NSNotification) {
        fullScreen = false
    }
    
    func windowWillResize(sender: NSWindow, toSize frameSize: NSSize) -> NSSize {
        if(!fullScreen) {
            if(aspectRatio != 0) {
                return NSSize(width: frameSize.height * aspectRatio, height: frameSize.height)
            }
        }
        
        return frameSize
    }
}

extension NSWindow {
    func setTitleBarHidden(hidden: Bool, animated: Bool = true) {
        
        let buttonSuperView = standardWindowButtonSuperView()
        if buttonSuperView == nil {
            return
        }
        let view = buttonSuperView!
        if hidden {
            if view.alphaValue > 0.1 {
                if !animated {
                    view.alphaValue = 0
                    return
                }
                view.animator().alphaValue = 0
            }
            return
        }
        
        if view.alphaValue < 1 {
            if !animated {
                view.alphaValue = 1
                return
            }
            view.animator().alphaValue = 1
        }
    }
    
    func standardWindowButtonSuperView() -> NSView? {
        return standardWindowButton(NSWindowButton.ZoomButton)?.superview
    }
}
