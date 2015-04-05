////
////  ViewControllerWNav.swift
////  Echo
////
////  Created by Hansa Srinivasan on 4/4/15.
////  Copyright (c) 2015 Quartet. All rights reserved.
////
//
//import UIKit
//
//class ViewControllerWNav: UIViewController, ENSideMenuDelegate {
//    
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        self.sideMenuController()?.sideMenu?.delegate = self
//    }
//    
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
//    
//    
//    @IBAction func toggleSideMenu(sender: AnyObject) {
//        toggleSideMenuView()
//    }
//    
//    // MARK: - ENSideMenu Delegate
//    func sideMenuWillOpen() {
//        println("sideMenuWillOpen")
//    }
//    
//    func sideMenuWillClose() {
//        println("sideMenuWillClose")
//    }
//    
//    func sideMenuShouldOpenSideMenu() -> Bool {
//        println("sideMenuShouldOpenSideMenu")
//        return true
//    }
//}