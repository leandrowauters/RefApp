//
//  DataPersisitanceManager.swift
//  RefApp
//
//  Created by Leandro Wauters on 1/12/19.
//  Copyright © 2019 Leandro Wauters. All rights reserved.
//

import Foundation

struct DataPersistanceManager {
    static func documentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    static func filepathToDocumentsDirectory(filename: String) -> URL {
        return DataPersistanceManager.documentsDirectory().appendingPathComponent(filename)
    }
}
