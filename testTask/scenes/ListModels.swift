//
//  ListModels.swift
//  testTask
//
//  Created by Mac on 4/27/18.
//  Copyright (c) 2018 kovtuns. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

enum List {
    // MARK: Use cases
    
    enum Model {
        struct Request {
            var term: String?
            var media: String?
        }
        
        struct Response {
            var error: Error?
            var video: [Video]?
            
            var filteredVideo: [List.Model.ViewModel.Video]?
        }
        
        struct ViewModel {
            struct Video {
                var name: String?
                var imageUrl: String?
            }
            
            var videos: [Video]?
            var errorTitle: String?
            var errorText: String?
            
            var filteredVideo: [List.Model.ViewModel.Video]?
        }
    }
}