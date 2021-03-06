//
//  ListPresenter.swift
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

protocol ListPresentationLogic {
    func presentError(response: List.Model.Response)
    func presentData(response: List.Model.Response)
    
    func presentFilteredList(response: List.Model.Response)
}

class ListPresenter: ListPresentationLogic {
    weak var viewController: ListDisplayLogic?
    
    private struct PresenterConstant{
        static var errorTitle = "Error"
    }
    
    // MARK: - ListPresentationLogic Delegate
    
    func presentError(response: List.Model.Response){
        var viewModel = List.Model.ViewModel()
        viewModel.errorTitle = PresenterConstant.errorTitle
        viewModel.errorText = response.error?.localizedDescription
        
        self.viewController?.presentError(viewModel: viewModel)
    }
    
    func presentData(response: List.Model.Response){
        var viewModel = List.Model.ViewModel()
        viewModel.videos = [List.Model.ViewModel.Video]()
        for item in response.video ?? [Video](){
            let video = List.Model.ViewModel.Video(name: item.trackName, imageUrl: item.artworkUrl100)
            viewModel.videos?.append(video)
        }
        self.viewController?.presentData(viewModel: viewModel)
    }
    
    func presentFilteredList(response: List.Model.Response){
        self.viewController?.presentFiltered(list: response.filteredVideo)
    }
}
