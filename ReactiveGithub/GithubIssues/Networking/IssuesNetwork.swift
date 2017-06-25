//
//  IssuesNetwork.swift
//  ReactiveGithub
//
//  Created by Saurabh Yadav on 25/06/17.
//  Copyright © 2017 Saurabh Yadav. All rights reserved.
//

import UIKit


import Foundation
import Moya

private extension String {
    var URLEscapedString: String {
        return self.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlHostAllowed)!
    }
}

enum GitHub {
    case repo(fullName: String)
    case issues(repositoryFullName: String)
}

extension GitHub: TargetType {
    var baseURL: URL { return URL(string: "https://api.github.com")! }
    var path: String {
        switch self {
        case .repo(let name):
            return "/repos/\(name)"
        case .issues(let repositoryName):
            return "/repos/\(repositoryName)/issues"
        }
    }
    var method: Moya.Method {
        return .get
    }
    var parameters: [String: Any]? {
        return nil
    }
    var sampleData: Data {
        switch self {
        case .repo(_):
            return "{\"id\": \"1\", \"language\": \"Swift\", \"url\": \"https://api.github.com/repos/mjacko/Router\", \"name\": \"Router\"}".data(using: .utf8)!
        case .issues(_):
            return "{\"id\": 132942471, \"number\": 405, \"title\": \"Updates example with fix to String extension by changing to Optional\", \"body\": \"Fix it pls.\"}".data(using: .utf8)!
        }
    }
    var task: Task {
        return .request
    }
    var parameterEncoding: ParameterEncoding {
        return JSONEncoding.default
    }
}
