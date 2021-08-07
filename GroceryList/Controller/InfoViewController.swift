//
//  InfoViewController.swift
//  GroceryList
//
//  Created by olga.krjuckova on 07/08/2021.
//

import UIKit

class InfoViewController: UIViewController {
    
    @IBOutlet weak var openSettingsButton: UIButton!
    
  
    @IBAction func InfoVCButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func openSettingsButtonTapped(_ sender: Any) {
      openSettings()
    }
    func openSettings() {
            guard let settingURL = URL(string: UIApplication.openSettingsURLString) else {
                return
            }
            if UIApplication.shared.canOpenURL(settingURL){
                
                UIApplication.shared.open(settingURL, options: [:]) { success in
                    print("success :", success)
                }
            }
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
