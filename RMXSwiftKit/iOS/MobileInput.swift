//
//  RMXMobileInput.swift
//  RattleGL
//
//  Created by Max Bilbow on 23/03/2015.
//  Copyright (c) 2015 Rattle Media. All rights reserved.
//

import Foundation
import GLKit
//import RMXKit

import CoreMotion
import UIKit
import AVFoundation

extension RMX {
    typealias DPadOrKeys = RMXMobileInput
    
}
typealias RMXInput = RMXMobileInput

class RMXMobileInput : RMXInterface {
    
     let _testing = false
     let _hasMotion = true
    var grav: Bool = true
    let motionManager: CMMotionManager = CMMotionManager()
    let rollSpeed: RMFloat = -0.01
    
    var moveButtonPad: UIImageView?// = RMXModels.getImage()
    var moveButton: UIView?
    var jumpButton: UIButton?
    var boomButton: UIButton?
    var topBar: UIView?
    var menuAccessBar: UIView?
    var pauseMenu: UIView?
    var moveSpeed: Float = -0.4 //-0.01 //-0.4
    var lookSpeed: Float = 0.03
    var turnSpeed: Float = 0.02//002
    
    override func viewDidLoad(){
        super.viewDidLoad()
        if _hasMotion {
            self.motionManager.startAccelerometerUpdates()
            self.motionManager.startDeviceMotionUpdates()
            self.motionManager.startGyroUpdates()
            self.motionManager.startMagnetometerUpdates()
        }
        

        
    }
    
   
    
    override func update() {
        super.update();
        self.accelerometer()
        if var move = delta {
            let rect = self.moveButtonCenter
            
            let limX = rect.size.width * 0.5 ; let limY = rect.size.height * 0.5
            
            move.x = _limit(move.x, limit: limX) /// limX //move.x > 0 ? x : -x
            move.y = _limit(move.y, limit: limY) /// limY //move.y > 0 ? y : -y
            
            let percentage = CGPoint(x: move.x / limX, y: move.y / limY)
            self.moveButtonPad!.center = rect.origin + rect.size * 0.5 + move * 1
            //            self.moveButtonPad?.setNeedsDisplay()
            CppBridge.moveWithDirection(UserAction.MOVE_FORWARD.description, withForce: Float(percentage.y) * self.moveSpeed)
            CppBridge.moveWithDirection(UserAction.MOVE_LEFT.description, withForce: Float(percentage.x) * self.moveSpeed)

        }
    }

    private var _count: Int = 0
   
    
    
    
    func makeButton(title: String? = nil, selector: String? = nil, view: UIView? = nil, row: (CGFloat, CGFloat), col: (CGFloat, CGFloat)) -> UIButton {
        let view = view ?? GameViewController.instance.view
        let btn = UIButton(frame: getRect(withinRect: view?.bounds, row: row, col: col))//(view!.bounds.width * col.0 / col.1, view!.bounds.height * row.0 / row.1, view!.bounds.width / col.1, view!.bounds.height / row.1))
        if let title = title {
            btn.setTitle(title, forState:UIControlState.Normal)
        }
        if let selector = selector {
            btn.addTarget(self, action: Selector(selector), forControlEvents:UIControlEvents.TouchDown)
        }
        
        btn.enabled = true
        view?.addSubview(btn)
        return btn
    }
    
    func showTopBar(recogniser: UIGestureRecognizer) {
        if let topBar = self.topBar {
            topBar.hidden = !topBar.hidden
            self.menuAccessBar!.hidden = !self.menuAccessBar!.hidden
        }
    }
    
    override func hideButtons(hide: Bool) {
        self.moveButton?.hidden = hide
        self.moveButtonPad?.hidden = hide
        self.jumpButton?.hidden = hide
        self.boomButton?.hidden = hide
        super.hideButtons(hide)
    }
    
    override func pauseGame(sender: AnyObject? = nil) -> Bool {
        self.pauseMenu?.hidden = false
        self.menuAccessBar?.hidden = true
        return super.pauseGame(sender)
    
    }
    
    override func unPauseGame(sender: AnyObject? = nil) -> Bool {
        self.pauseMenu?.hidden = true
        self.menuAccessBar?.hidden = false
        return super.unPauseGame(sender)
    }
    
    override func optionsMenu(sender: AnyObject?) {
        super.optionsMenu(sender)
    }
    
    override func exitToMainMenu(sender: AnyObject?) {
        super.exitToMainMenu(sender)
    }

    override func restartSession(sender: AnyObject?) {
        super.restartSession(sender)
    }
    
    var topBarBounds: CGRect {
        return CGRectMake(0,0, GameViewController.instance.view.bounds.width, GameViewController.instance.view.bounds.height * 0.1)
    }
    
    internal func makePauseMenu() {
        self.menuAccessBar = UIView(frame: self.topBarBounds)
        self.makeButton("      +", selector: "showTopBar:", view: self.menuAccessBar, row: (1,1), col: (self.topColumns,self.topColumns))
        self.makeButton("||     ", selector: "pauseGame:" , view: self.menuAccessBar, row: (1,1), col: (1,self.topColumns))
        
        GameViewController.instance.view.addSubview(self.menuAccessBar!)
        
        self.pauseMenu = UIView(frame: self.topBarBounds)
        self.pauseMenu!.hidden = true
        self.pauseMenu?.backgroundColor = UIColor.grayColor()
        
        self.makeButton("||     ", selector: "unPauseGame:" , view: self.pauseMenu, row: (1,1), col: (1,self.topColumns))
        self.makeButton("New Game", selector: "restartSession:", view: self.pauseMenu, row: (1,1), col: (2,6))
        self.makeButton("Reset Game", selector: "resetTransform:", view: self.pauseMenu, row: (1,1), col: (3,6))
        self.makeButton("Options", selector: "optionsMenu:", view: self.pauseMenu, row: (1,1), col: (3,4))
        self.makeButton("Exit to main menu", selector: "exitToMainMenu:", view: self.pauseMenu, row: (1,1), col: (4,4))

        
        
//        let last: CGFloat = self.topColumns; let rows: CGFloat = 1// view.bounds.height / height
        GameViewController.instance.view.addSubview(self.pauseMenu!)
    }
    
    private let topColumns: CGFloat = 7
    
    internal func makeTopBar ()  {
        
        self.topBar = UIView(frame: self.topBarBounds)
        self.topBar!.backgroundColor = UIColor.grayColor()
        self.topBar!.hidden = true
        
        let view = self.topBar!
        
        let last: CGFloat = self.topColumns; let rows: CGFloat = 1// view.bounds.height / height
        
        
        self.makeButton("  < CAM", selector: "previousCamera:", view: view, row: (1,rows), col: (1,self.topColumns))
        
        self.makeButton("  RESET", selector: "resetTransform:", view: view, row: (1,rows), col: (2,self.topColumns)) //UIButton(frame: rect(1))
        
        self.makeButton("   AI  ", selector: "toggleAi:", view: view, row: (1,rows), col: (3,self.topColumns))
        
        self.makeButton(" GRAV  ", selector: "toggleAllGravity:", view: view, row: (1,rows), col: (4,self.topColumns))
        
//        self.makeButton(" DATA  ", selector: "printData:", view: view, row: (1,rows), col: (5,self.topColumns))
        
//        self.makeButton(" Video ", selector: "startVideo:", view: view, row: (1,rows), col: (6,self.topColumns))
        self.makeButton(" SCORE ", selector: "showScores:", view: view, row: (1,rows), col: (5,self.topColumns))
        
        self.makeButton("  CAM >", selector: "nextCamera:", view: view, row: (1,rows), col: (last - 1,self.topColumns))
        
        self.makeButton("      -", selector: "showTopBar:", view: view, row: (1,rows), col: (last,self.topColumns))
        
        GameViewController.instance.view.addSubview(self.topBar!)
//        GameViewController.instance.view.addSubview(self.menuAccessBar!)
        
    }
    override func setUpViews(withView view: UIView) {
        super.setUpViews(withView: view)

        self.makeTopBar()
        self.makePauseMenu()
        
        
        
        let topBar = self.topBar!

        self.scoreboard.alpha = 0.5
       
        
        
        

        

        
        
        let w = GameViewController.instance.view.bounds.size.width
        let h = GameViewController.instance.view.bounds.size.height - topBar.bounds.height
//        let leftView: UIView = UIImageView(frame: CGRectMake(0, topBar.bounds.height, w/2, h))
        let rightView: UIView = UIImageView(frame: CGRectMake(w / 3, topBar.bounds.height, w * 2 / 3, h))
        rightView.userInteractionEnabled = true
        
        
    
        

        
        
        
        
        
        
        //setLeftView(); //setRightView()//; setUpButtons()
        
        

        var bounds = self.moveButtonCenter//CGRectMake(origin.x, origin.y, size.width, size.height)
        bounds.size = CGSize(width: bounds.size.width + 10, height: bounds.size.height + 10)
        bounds.origin.x -= 5
        bounds.origin.y -= 5
        self.moveButton = self.moveButton(bounds.size, origin: bounds.origin)
        
        
        let view = GameViewController.instance.view;
        view.addSubview(self.moveButton!)
        view.bringSubviewToFront(self.moveButton!)
        let padImage: UIImage = RMXMobileInput.getImage()
        self.moveButtonPad = UIImageView(frame: self.moveButtonCenter)//(image: padImage)
        self.moveButtonPad!.image = padImage
        self.moveButtonPad?.setNeedsDisplay()
        let handleMovement: UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self,action: "handleMovement:")
        handleMovement.minimumPressDuration = 0.0
        self.moveButtonPad!.addGestureRecognizer(handleMovement)
        self.moveButtonPad!.userInteractionEnabled = true
        view.addSubview(self.moveButtonPad!)

        
        self.jumpButton = UIButton(frame: self.jumpButtonCenter)
        self.jumpButton?.setImage(RMXMobileInput.getImage(), forState: UIControlState.Normal)
//        self.jumpButton?.setNeedsDisplay()
        let jump = UILongPressGestureRecognizer(target: self, action: "jump:")
        jump.minimumPressDuration = 0.0
        self.jumpButton?.addGestureRecognizer(jump)
        self.jumpButton!.enabled = true
        view.addSubview(self.jumpButton!)
        
        self.boomButton = UIButton(frame: self.boomButtonCenter)
        self.boomButton?.setImage(RMXMobileInput.getImage(), forState: UIControlState.Normal)
//        self.boomButton?.setNeedsDisplay()
        let explode = UILongPressGestureRecognizer(target: self, action: "explode:")
        explode.minimumPressDuration = 0.0
        self.boomButton?.addGestureRecognizer(explode)
        self.boomButton!.enabled = true
        view.addSubview(self.boomButton!)
        
        
        view.addGestureRecognizer(UIPinchGestureRecognizer(target: self, action: "zoom:"))
        // add a tap gesture recognizer
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "grabOrThrow:"))
        rightView.addGestureRecognizer(UIPanGestureRecognizer(target: self,action: "handleOrientation:"))
        view.addSubview(rightView)
        
        view.bringSubviewToFront(self.boomButton!)
        view.bringSubviewToFront(self.jumpButton!)
        
        let resetCamera = UITapGestureRecognizer(target: self, action: "resetCamera:")
        resetCamera.numberOfTapsRequired = 2
        view.addGestureRecognizer(resetCamera)
    }
    
    var i = 0
    var moveOrigin: CGPoint = CGPoint(x: 0,y: 0)
    var lookOrigin: CGPoint = CGPoint(x: 0,y: 0)

    var boomTimer: RMFloat = 1
    
    var delta: CGPoint?
    
    ///The event handling method
    func handleOrientation(recognizer: UIPanGestureRecognizer) {
        if recognizer.numberOfTouches() == 1 {
            let point = recognizer.velocityInView(GameViewController.instance.view)
            
            CppBridge.cursorDelta(Double(self.lookSpeed) * Double(point.x), dy: Double(self.turnSpeed) * Double(point.y))
            //            CppBridge.turnAboutAxis(UserAction.MOVE_PITCH.description, withForce: self.lookSpeed * Float(point.y))
            //            CppBridge.turnAboutAxis(UserAction.MOVE_YAW.description, withForce: self.turnSpeed * Float(point.x))
            
        }
        //            _handleRelease(recognizer.state)
    }
    
    func handleMovement(recogniser: UILongPressGestureRecognizer){
        let point = recogniser.locationInView(GameViewController.instance.view)
        if recogniser.state == .Began {
            self.moveOrigin = point
        } else if recogniser.state == .Ended {
            self.moveButtonPad!.frame = self.moveButtonCenter
            CppBridge.sendMessage("\(UserAction.STOP_MOVEMENT)")
            delta = nil
        } else {
            delta = CGPoint(x: point.x - self.moveOrigin.x, y: point.y - self.moveOrigin.y)
            
            
                    //            NSLog("FWD: \((x / limX).toData()), SIDE: \((y / limY).toData())),  TOTAL: \(1)")
        }
        
    }


    func accelerometer() {
        func tilt(direction: UserAction, tilt: RMFloat){
//            if RMXScene.current.hasGravity {
//                return
//            } else {
            let rollSpeed = RMFloat(self.moveSpeed)
            let rollThreshold: RMFloat = 0.1
            if tilt > rollThreshold {
                let speed = (1.0 + tilt) * rollSpeed
                CppBridge.sendMessage("tilt:\(direction):\(speed)")
            } else if tilt < -rollThreshold {
                let speed = (-1.0 + tilt) * rollSpeed
                CppBridge.sendMessage("tilt:\(direction):\(speed)")
            }
//            }
        }
        
        if let deviceMotion = self.motionManager.deviceMotion {
            tilt(UserAction.ROLL_LEFT, tilt: RMFloat(deviceMotion.gravity.y))
            //tilt("pitch", RMFloat(self.motionManager.deviceMotion.gravity.z))
            //            tilt("yaw", RMFloat(self.motionManager.deviceMotion.gravity.x)
            func updateGravity() {
                //                let g = deviceMotion.gravity
                //                self.gravity.x = RMFloat(g.x)
                //                RMX.gravity.y = RMFloat(g.y)
                //                RMX.gravity.z = RMFloat(g.z)
            }
            //            updateGravity()
            
            if !_testing { return }
            var x,y,z, q, r, s, t, u, v,a,b,c,e,f,g,h,i,j,k,l,m:Double
            x = deviceMotion.gravity.x
            y = deviceMotion.gravity.y
            z = deviceMotion.gravity.z
            q = deviceMotion.magneticField.field.x
            r = deviceMotion.magneticField.field.y
            s = deviceMotion.magneticField.field.z
            t = deviceMotion.rotationRate.x
            u = deviceMotion.rotationRate.y
            v = deviceMotion.rotationRate.z
            a = deviceMotion.attitude.pitch
            b = deviceMotion.attitude.roll
            c = deviceMotion.attitude.yaw
            e = self.motionManager.gyroData!.rotationRate.x
            f = self.motionManager.gyroData!.rotationRate.y
            g = self.motionManager.gyroData!.rotationRate.z
            if let magnetometerData = self.motionManager.magnetometerData {
                h = magnetometerData.magneticField.x
                i = magnetometerData.magneticField.y
                j = magnetometerData.magneticField.z
            } else { h=0;i=0;j=0 }
            k = deviceMotion.userAcceleration.x
            l = deviceMotion.userAcceleration.y
            m = deviceMotion.userAcceleration.z
            
            //            let d = deviceMotion.magneticField.accuracy.rawValue
            
            RMLog("           Gravity,\(x.toData()),\(y.toData()),\(z.toData())")
            RMLog("   Magnetic Field1,\(q.toData()),\(r.toData()),\(s.toData())")
            RMLog("   Magnetic Field2,\(h.toData()),\(i.toData()),\(j.toData())")
            RMLog("     Rotation Rate,\(t.toData()),\(u.toData()),\(v.toData())")
            RMLog("Gyro Rotation Rate,\(e.toData()),\(f.toData()),\(g.toData())")
            RMLog("          Attitude,\(a.toData()),\(b.toData()),\(c.toData())")
            RMLog("          userAcc1,\(k.toData()),\(l.toData()),\(m.toData())")
            
            
            if self.motionManager.accelerometerData != nil {
                print("          userAcc2,\(self.motionManager.accelerometerData!.acceleration.x.toData()),\(self.motionManager.accelerometerData!.acceleration.y.toData()),\(self.motionManager.accelerometerData!.acceleration.z.toData())")
                // println("      Magnetic field accuracy: \(d)")
            }
        }
        else {
            //            RMLog("No motion?!")
        }
        // println()
    }
    
    
}



