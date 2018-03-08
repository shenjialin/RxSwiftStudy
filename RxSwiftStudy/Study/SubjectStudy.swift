//
//  SubjectStudy.swift
//  RxSwiftStudy
//
//  Created by 沈家林 on 2018/3/7.
//  Copyright © 2018年 沈家林. All rights reserved.
//

import Foundation
import RxSwift

/*
 Subject既是Observer，也是Observable。因为它是一个Observer，它可以订阅一个或多个Observable;因为它是一个Observable，它又可以被其他的Observer订阅。它可以传递/转发作为Observer收到的值，也可以主动发射值。
 */
class SubjectStudyViewModel: NSObject {
    let disposeBag = DisposeBag()
    
    //PublishSubject 一般的subject
    let subjectPublish:PublishSubject<String> = PublishSubject<String>()
    
    //ReplaySubject 具有重放(replay)的功能的subject，bufferSize 代表订阅之前缓存数据的个数
    let subjectReplay:ReplaySubject<Int> = ReplaySubject<Int>.create(bufferSize: 2)
    
    /*BehaviorSubject类似于ReplaySubject具有缓存能力，但是略有不同。
        1、只缓存一个最新值，类似ReplaySubject.create(bufferSize: 1)
        2、需要提供默认值
     使用BehaviorSubject有一点好处，我们可以确定当Observer订阅时，至少可以收到最新的一个值。
     */
    let subjectBehavior:BehaviorSubject<Int> = BehaviorSubject(value: 0)
    
    /*Variable是BehaviorSubject的一个封装，具备了缓存最新值和提供默认值的能力,但是Variable没有on系列方法，只提供了value属性。
        1、直接对value进行set等同于调用了onNext()方法，Variable不能主动发射error和completed
        2、在Variable被销毁的时候会自动调用发射completed给Observer
     */
    var subjectVariable:Variable<Int>? = Variable(0)
    
    func publishSubjectStudy(){
        //订阅之后，才能接受到发送消息
        subjectPublish.onNext("1")
        subjectPublish.subscribe {
            if let element = $0.element{
                print("subjectPublish:"+element)
            }
        }.disposed(by: disposeBag)
        //dispose 之后也不能再接受消息
        
        subjectPublish.onNext("2")
        subjectPublish.onNext("3")
        subjectPublish.onCompleted()
        //接受到complete和error消息后就不能再接受消息
        subjectPublish.onNext("4")
    }
    
    func replaySubjectStudy(){
        subjectReplay.onNext(1)
//        subjectReplay.onError(ObservableError.loseBrain)
//        subjectReplay.onCompleted()
        //发送了Error和Completed之后，后面发送的消息就不会缓存，前面缓存的消息不会被清除
        subjectReplay.onNext(2)
        subjectReplay.onNext(3)
        //subjectReplay.onNext(1) 不会被打印，因为订阅前只缓存2个
        subjectReplay.subscribe {
            if let element = $0.element{
                print("subjectReplay:\(element)")
            }
        }.disposed(by: disposeBag)
        
        subjectReplay.onNext(4)
        subjectReplay.onNext(5)
        subjectReplay.onCompleted()
        subjectReplay.onNext(6)
        
    }
    
    func behaviorSubjectStudy(){
//        subjectBehavior.onNext(1)
//        subjectBehavior.onNext(2)
        //subjectBehavior(1) 不会被打印，因为订阅前只缓存1个
        subjectBehavior.subscribe {
            if let element = $0.element{
                print("subjectBehavior:\(element)")
            }
        }.disposed(by: disposeBag)
        subjectBehavior.onNext(4)
        subjectBehavior.onNext(5)
        subjectBehavior.onCompleted()
        subjectBehavior.onNext(6)
    }
    
    func variableStudy(){
        subjectVariable!.value = 1
        subjectVariable!.value = 2
        subjectVariable!.asObservable().subscribe {
//            if let element = $0.element{
                print("subjectVariable:\($0)")
//            }
        }.disposed(by: disposeBag)
        subjectVariable!.value = 3
        //在Variable被销毁的时候会自动调用发射completed给Observer
        subjectVariable = nil
    }
    
}
