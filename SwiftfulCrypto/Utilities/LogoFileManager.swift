//
//  LogoFileManager.swift
//  SwiftfulCrypto
//
//  Created by Vladyslav Mi on 20.03.2024.
//

import Foundation
import SwiftUI

class LogoFileManager {
    
    static let instance = LogoFileManager()
    
    private init(){
        
    }
    
    func saveImage(image : UIImage, imageName : String,folderName: String){
        //create folder
        createFolderIfNeeded(folderName: folderName)
        //get url for image
        guard
            let data = image.pngData(),
            let url = URL(string: "")
        else {return }
        
        //save image to path
        do {
            try data.write(to: url)
        } catch let error{
            print ("Error saving image.ImageName: \(imageName).\(error)")
        }
    }
    
    func getImage(imageName : String,folderName: String)-> UIImage?{
        guard
            let url = getURLForImage(imageName: imageName, folderName: folderName),
            FileManager.default.fileExists(atPath: url.path) else {return nil}
        return UIImage(contentsOfFile: url.path)
    }
    
    private func createFolderIfNeeded (folderName : String) {
        guard let url = getURLForFolder(folderName: folderName) else {return}
        
        if !FileManager.default.fileExists(atPath: url.path){
            do {
                try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
            } catch let error {
                print ("Error creating directory.FolderName: \(folderName) .\(error)")
            }
        }
    }
    private func getURLForFolder(folderName: String) -> URL?{
        guard let url = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else {return nil}
        return url.appendingPathComponent(folderName)
    }
    
    private func getURLForImage(imageName : String,folderName: String) -> URL? {
        guard let folderURL = getURLForFolder(folderName: folderName) else {return nil}
        return folderURL.appendingPathComponent(imageName + ".png")
    }
    
}
