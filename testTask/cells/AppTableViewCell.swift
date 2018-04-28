//
//  AppTableViewCell.swift
//  testTask
//
//  Created by Mac on 4/27/18.
//  Copyright © 2018 kovtuns. All rights reserved.
//

import UIKit

class AppTableViewCell: UITableViewCell {
    
    @IBOutlet weak var appImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    var imageUrl: URL? {
        didSet{
            self.appImageView.image = nil
            self.setImage()
        }
    }
}

private extension AppTableViewCell{
    func setImage(){
        if let url = imageUrl{
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                if let imageData = data{
                    DispatchQueue.main.async {
                        if url == self.imageUrl{
                            if let image = UIImage(data: imageData){
                                self.appImageView.image = image
                            }
                        }
                    }
                }
            }
            task.resume()
        }
    }
}
