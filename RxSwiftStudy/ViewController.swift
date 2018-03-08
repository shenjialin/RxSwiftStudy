//
//  ViewController.swift
//  RxSwiftStudy
//
//  Created by 沈家林 on 2018/3/1.
//  Copyright © 2018年 沈家林. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let observableVM = ObservableStudyViewModel()
        observableVM.subscribeStudy()
        
        let subjectVM = SubjectStudyViewModel()
        subjectVM.publishSubjectStudy()
        subjectVM.replaySubjectStudy()
        subjectVM.behaviorSubjectStudy()
        subjectVM.variableStudy()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

