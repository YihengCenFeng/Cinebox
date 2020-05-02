//
//  SavedViewController.swift
//  Cinebox
//
//  Created by Yiheng Cen Feng on 5/2/20.
//  Copyright © 2020 Yiheng. All rights reserved.
//

import UIKit

class SavedViewController: UIViewController {

    @IBOutlet weak var navBar: UINavigationBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navBar.delegate = self
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension SavedViewController: UINavigationBarDelegate {
    // Unified the status bar area with the navigation bar
    func position(for bar: UIBarPositioning) -> UIBarPosition {
        return .topAttached
    }
}

