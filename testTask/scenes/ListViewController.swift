//
//  ListViewController.swift
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

protocol ListDisplayLogic: class {
    func presentError(viewModel: List.Model.ViewModel)
    func presentData(viewModel: List.Model.ViewModel)
    func presentFiltered(list: [List.Model.ViewModel.Video]?)
}

class ListViewController: UITableViewController {
    var interactor: ListBusinessLogic?
    var router: (NSObjectProtocol & ListRoutingLogic & ListDataPassing)?
    
    fileprivate struct ListConstants{
        static let alertButtonTitle = "OK"
        static let searchBarPlaceholder = "Search song"

        static let excludeWord = "Documentary"
    }
    
    let searchController = UISearchController(searchResultsController: nil)
    fileprivate var currentViewModel: List.Model.ViewModel = List.Model.ViewModel()
    
    // MARK: Object lifecycle
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    // MARK: Routing
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let scene = segue.identifier {
            let selector = NSSelectorFromString("routeTo\(scene)WithSegue:")
            if let router = router, router.responds(to: selector) {
                router.perform(selector, with: segue)
            }
        }
    }
    
    // MARK: View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ProgressLoader.show()
        self.interactor?.getList(ListConstants.excludeWord)
        self.tableView.tableFooterView = UIView(frame: .zero)
        self.refreshControl?.addTarget(self, action: #selector(handleRefresh(_:)), for: .valueChanged)
    }
    
    // MARK: Action
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        self.interactor?.getList(ListConstants.excludeWord)
    }
}

extension ListViewController{
    // MARK: UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
    // MARK: UITableViewDataSource
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: AppTableViewCell.self), for: indexPath) as! AppTableViewCell
        if let filteredVideo = currentViewModel.filteredVideo{
            cell.titleLabel.text = filteredVideo[indexPath.row].name
            cell.imageUrl = URL(string: filteredVideo[indexPath.row].imageUrl ?? "")
        }else if let videos = currentViewModel.videos{
            cell.titleLabel.text = videos[indexPath.row].name
            cell.imageUrl = URL(string: videos[indexPath.row].imageUrl ?? "")
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if currentViewModel.filteredVideo == nil{
            if let videos = currentViewModel.videos {
                return videos.count
            }else{
                return 0
            }
        }else{
            return currentViewModel.filteredVideo!.count
        }
    }
}

private extension ListViewController{
    // MARK: Setup
    
    func setup() {
        let viewController = self
        let interactor = ListInteractor()
        let presenter = ListPresenter()
        let router = ListRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
        
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = ListConstants.searchBarPlaceholder
        searchController.searchBar.tintColor = UIColor.warmGrey
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
        if #available(iOS 11.0, *) {
            navigationItem.hidesSearchBarWhenScrolling = false
            navigationItem.searchController = searchController
        }
    }
}

extension ListViewController: ListDisplayLogic{
    // MARK: - ListDisplayLogic Delegate
    
    func presentData(viewModel: List.Model.ViewModel) {
        currentViewModel = viewModel
        self.tableView.reloadData()
        self.refreshControl?.endRefreshing()
    }
    
    func presentError(viewModel: List.Model.ViewModel) {
        let alertController = UIAlertController(title: viewModel.errorTitle ?? "", message: viewModel.errorText ?? "", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: ListConstants.alertButtonTitle, style: .cancel, handler: nil))
        self.present(alertController, animated: true, completion: nil)
        self.refreshControl?.endRefreshing()
    }
    
    func presentFiltered(list: [List.Model.ViewModel.Video]?) {
        if searchController.searchBar.text?.count != 0{
            currentViewModel.filteredVideo = list
        }
        self.tableView.reloadData()
    }
}

extension ListViewController: UISearchResultsUpdating {
    // MARK: - UISearchResultsUpdating Delegate
    
    func updateSearchResults(for searchController: UISearchController) {
        self.interactor?.getFilteredList(searchController.searchBar.text ?? "", currentViewModel.videos ?? [])
    }
}

extension ListViewController: UISearchBarDelegate{
    // MARK: - UISearchBarDelegate Delegate
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        currentViewModel.filteredVideo = nil
        self.tableView.reloadData()
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        self.tableView.contentOffset = CGPoint(x: 0, y: 0 - self.tableView.contentInset.top - searchController.view.frame.height)
        return true
    }
}