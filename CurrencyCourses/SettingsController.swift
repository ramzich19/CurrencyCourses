//
//  SettingsController.swift
//  CurrencyCourses
//
//  Created by Рамазан Нуриев on 30.10.2021.
//

import UIKit

class SettingsController: UIViewController {

    @IBOutlet weak var datePicker: UIDatePicker!
    
    
    @IBAction func pushCancelAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        
    }
    
    
    @IBAction func pushShowCourses(_ sender: Any) {
        Model.shared.loadXMLFile(date: datePicker.date)
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
