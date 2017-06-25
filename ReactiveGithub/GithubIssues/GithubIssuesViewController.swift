//
//  GithubIssuesViewController.swift
//  ReactiveGithub
//
//  Created by Saurabh Yadav on 25/06/17.
//  Copyright © 2017 Saurabh Yadav. All rights reserved.
//

import UIKit
import Moya
import Moya_ModelMapper
import UIKit
import RxOptional
import RxCocoa
import RxSwift


class GithubIssuesViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    let disposeBag = DisposeBag()
    var provider: RxMoyaProvider<GitHub>!
    var issueTrackerModel: GithubIssuesModel!
    
    var latestRepositoryName: Observable<String> {
        return searchBar.rx.text
            .orEmpty
            .debounce(0.5, scheduler: MainScheduler.instance)
            .distinctUntilChanged()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupRx()
    }
    
    func setupRx() {
        // Create the Provider
        provider = RxMoyaProvider<GitHub>()
        
        // Setup the model
        issueTrackerModel = GithubIssuesModel(provider: provider, repositoryName: latestRepositoryName)
        
        issueTrackerModel
            .trackIssues()
            .bind(to: tableView.rx.items) { (tableView, row, item) in
                let cell = tableView.dequeueReusableCell(withIdentifier: "githubIssuesCell", for: IndexPath(row: row, section: 0))
                cell.textLabel?.text = item.title
                
                return cell
            }
            .addDisposableTo(disposeBag)
        
        // Here we tell table view that if user clicks on a cell,
        // and the keyboard is still visible, hide it
        tableView
            .rx.itemSelected
            .subscribe(onNext: { indexPath in
                if self.searchBar.isFirstResponder == true {
                    self.view.endEditing(true)
                }
            })
            .addDisposableTo(disposeBag)
    }
    
    func url(_ route: TargetType) -> String {
        return route.baseURL.appendingPathComponent(route.path).absoluteString
    }
}

