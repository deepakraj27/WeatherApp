//
//  Localizable+Extension.swift
//  WeatherApp
//
//  Created by Deepakraj Murugesan on 07/01/19.
//  Copyright © 2019 Noticeboard. All rights reserved.
//

import Foundation

//MARK:- Localized function
//It has tablename/Strings File name as Localizable by default and has bundle as main, comment as empty...
//if at all comment is added to the strings file in future pass the comment to the function. comment format should be like this "/* Comment */"


extension String {
    func localized(bundle: Bundle = .main, tableName: String = "Localizable", comment: String = "") -> String {
        return NSLocalizedString(self, tableName: tableName, value: "**\(self)**", comment: comment)
    }
}


/*
 USAGE
 "data_loaded" = "Data Loaded!";
 "data_loaded".localized(tableName: "DataLoader") // Strings File Name = DataLoader and Output = Data Loaded!
 "data_loaded".localized() // Data Loaded!
 */
