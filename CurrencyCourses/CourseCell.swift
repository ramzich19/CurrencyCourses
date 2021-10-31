//
//  CourseCell.swift
//  CurrencyCourses
//
//  Created by Рамазан Нуриев on 31.10.2021.
//

import UIKit

class CourseCell: UITableViewCell {
    @IBOutlet weak var imageFlag: UIImageView!
    @IBOutlet weak var labelCurrencyName: UILabel!
    @IBOutlet weak var labelCourse: UILabel!
    
    func initCell(currency: Currency) {
        imageFlag.image = currency.imageFlag
        labelCurrencyName.text = currency.Name
        labelCourse.text = currency.Value
        
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
