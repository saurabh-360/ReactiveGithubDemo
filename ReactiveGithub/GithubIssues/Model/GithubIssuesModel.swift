//
//  GithubIssuesModel.swift
//  ReactiveGithub
//
//  Created by Saurabh Yadav on 25/06/17.
//  Copyright © 2017 Saurabh Yadav. All rights reserved.
//

import UIKit
import Foundation
import Moya
import Mapper
import Moya_ModelMapper
import RxOptional
import RxSwift

struct GithubIssuesModel {
    
    let provider: RxMoyaProvider<GitHub>
    let repositoryName: Observable<String>
    
    func trackIssues() -> Observable<[Issues]> {
        return repositoryName
            .observeOn(MainScheduler.instance)
            .flatMapLatest { name -> Observable<Repository?> in
                return self
                    .findRepository(name)
            }
            .flatMapLatest { repository -> Observable<[Issues]?> in
                guard let repository = repository else { return Observable.just(nil) }
                
                print("Repository: \(repository.fullName)")
                return self.findIssues(repository)
            }
            .replaceNilWith([])
    }
    
    internal func findIssues(_ repository: Repository) -> Observable<[Issues]?> {
        return self.provider
            .request(GitHub.issues(repositoryFullName: repository.fullName))
            .debug()
            .mapArrayOptional(type: Issues.self)
    }
    
    internal func findRepository(_ name: String) -> Observable<Repository?> {
        return self.provider
            .request(GitHub.repo(fullName: name))
            .debug()
            .mapObjectOptional(type: Repository.self)
    }
}
