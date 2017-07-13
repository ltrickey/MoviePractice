//
//  DataStore.swift
//  MoviePracticeApp
//
//  Created by Lynn Trickey on 7/13/17.
//  Copyright © 2017 Lynn Trickey. All rights reserved.
//

import Foundation

class DataStore: NSObject, NSCoding {
    
    static let sharedInstnce = loadData()
    
    var allTakesSaved = [String:[Take]]()
    // var yogastuff: [YogaWorkout] = []
    
    private override init() {
        self.allTakesSaved = [String: [Take]]();
    }
    
    required init(coder decoder: NSCoder) {
        self.allTakesSaved = (decoder.decodeObject(forKey: "allTakesSaved") as? [String: [Take]])!
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(allTakesSaved, forKey: "allTakesSaved")
    }
    
    static var filePath: String {
        //1 - manager lets you examine contents of a files and folders in your app; creates a directory to where we are saving it
        let manager = FileManager.default
        //2 - this returns an array of urls from our documentDirectory and we take the first path
        let url = manager.urls(for: .documentDirectory, in: .userDomainMask).first
        print("this is the url path in the documentDirectory \(String(describing: url))")
        //3 - creates a new path component and creates a new file called "Data" which is where we will store our Data array.
        return (url!.appendingPathComponent("Data").path)
    }
    
    func saveTake(shot: String, take: Take) {
        if var shotArr = self.allTakesSaved[shot] {
            shotArr.append(take)
            self.allTakesSaved[shot] = shotArr
        }
        NSKeyedArchiver.archiveRootObject(self, toFile: DataStore.filePath)
    }
    
    private static func loadData() -> DataStore {
        if let data = NSKeyedUnarchiver.unarchiveObject(withFile: filePath) as? DataStore {
            return data
        } else {
            return DataStore()
        }
    }
}
