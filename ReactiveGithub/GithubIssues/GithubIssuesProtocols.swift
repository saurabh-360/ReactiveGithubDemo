//
//  GithubIssuesProtocols.swift
//  ReactiveGithub
//
//  Created by Saurabh Yadav on 25/06/17.
//  Copyright © 2017 Saurabh Yadav. All rights reserved.
//

import Mapper

struct Repository: Mappable {
    
    let identifier: Int
    let name: String
    let fullName: String
    
    init(map: Mapper) throws {
        try identifier = map.from("id")
        try name = map.from("name")
        try fullName = map.from("full_name")
    }
}

struct Issues: Mappable {
    
    let identifier: Int
    let number: Int
    let title: String
    let body: String
    
    init(map: Mapper) throws {
        try identifier = map.from("id")
        try number = map.from("number")
        try title = map.from("title")
        try body = map.from("body")
    }
}

