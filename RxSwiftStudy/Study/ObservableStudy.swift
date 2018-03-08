//
//  ObservableStudy.swift
//  RxSwiftStudy
//
//  Created by 沈家林 on 2018/3/1.
//  Copyright © 2018年 沈家林. All rights reserved.
//

import Foundation
import RxSwift

enum ObservableError:Error {
    case loseNetwork
    case loseLink
    case loseBrain
}

//数据模型
struct ObservableStudyModel {
    let one:Int
    let two:Double
    let three:String
}

//class ObservableStudyModel: NSObject {
//    var one:Int
//    var two:Double
//    var three:String
//    init(one: Int, two: Double, three: String) {
//        self.one=one
//        self.two=two
//        self.three=three
//        super.init()
//    }
//}

//ViewModel
class ObservableStudyViewModel: NSObject {
    
    let model:ObservableStudyModel
    let disposeBag = DisposeBag()
    let observableJust:Observable<Int>
    let observableOf:Observable<Any>
    let observableFrom:Observable<Any>
    let observableEmpty:Observable<Void>
    let observableNever:Observable<Any>
    let observableRange:Observable<Int>
    let observableCreate:Observable<String>
    let observableDeferred:Observable<String>
    
    override init() {
        
        model = ObservableStudyModel(one: 1, two: 2.0, three: "3")
        
        // just 创建一个只有一个元素的Observable序列
        observableJust = Observable.just(model.one)
        
        //of 创建一个固定数量元素的Observable序列
        observableOf = Observable.of(model.one,model.two,model.three)
        
        //from 从一个序列(如Array/Dictionary/Set)中创建一个Observable序列
        observableFrom = Observable.from([model.one,model.two,model.three])
    
        //empty 创建一个只发送completed事件的空Observable序列
        observableEmpty = Observable.empty()
        
        //never 创建一个永不终止且不发出任何事件的序列
        observableNever = Observable.never()
        
        //range 创建一个Observable序列，它会发出一系列连续的整数，然后终止
        observableRange = Observable.range(start: 1, count: 10)
        
        //创建一个自定义的Observable序列
        /*create(<#T##subscribe: (Anyobservable<_>) -> Disposable##(Anyobservable<_>) -> Disposable#>)
         参数是尾部闭包
         闭包的参数是：Anyobservable 类型
            Anyobservable 继承于observableType
         
            有常用三个方法如下：
                public func onNext(_ element: E)   发送消息，消息的类型是被观察的类型
                public func onCompleted()          发送complete消息
                public func onError(_ error: Swift.Error) 发送error，参数需要遵从Error协议
            注意：一个Observable发出一个error事件(Event.error(ErrorType))或者一个completed事件(Event.completed)，那么这个Observable序列就不能给订阅者发送其他的事件了
         
         闭包的返回值：Disposable 类型
         
         */
        observableCreate = Observable<String>.create({
            $0.onNext("发了一条消息")
            $0.onNext("发了第二条消息")
            $0.onCompleted()
//            $0.onError(ObservableError.loseBrain)
            $0.onNext("发了第三条消息")
            return Disposables.create()
        })
        
        
        self.observableDeferred = Observable<String>.deferred({ () -> Observable<String> in
            print("哈哈")
            return Observable.create({
                $0.onNext("🐷")
                $0.onNext("🐑")
                $0.onCompleted()
                return Disposables.create()
            })
        })
    }
    
    func subscribeStudy(){
        
        /*订阅信息，当发送消息、error、complete都会调用这个方法
         subscribe(<#T##on: (Event<Any>) -> Void##(Event<Any>) -> Void#>)
         参数是尾部闭包
         闭包的参数是：Event类型
            Event是一个枚举
                public enum Event<Element> {
                    case next(Element)
                    case error(Swift.Error)
                    case completed
                }
         
         subscribe(_:)返回一个一次性的实例，通过这个实例，我们就能进行资源的释放了。
         对于RxSwift中资源的释放，也就是解除绑定、释放空间，有两种方法，分别是显式释放以及隐式释放
         */
//        observableCreate.subscribe { (event) in
//            print(event)
//        }
//        observableJust.subscribe(<#T##on: (Event<Int>) -> Void##(Event<Int>) -> Void#>)
        
        observableJust.subscribe {
            if let element = $0.element {
                print(element)
            }
        }.dispose() //显式释放
        /*
         隐式释放 则通过DisposeBag来进行，它类似于Objective-C ARC中的自动释放池机制，当我们创建了某个实例后，会被添加到所在线程的自动释放池中，而自动释放池会在一个RunLoop周期后进行池子的释放与重建；DisposeBag对于RxSwift就像自动释放池一样，我们把资源添加到DisposeBag中，让资源随着DisposeBag一起释放
         */
        observableOf.subscribe {
            if let element = $0.element {
                print(element)
            }
        }.disposed(by: disposeBag) //隐式释放
        
        /*subscribe(onNext: <#T##((Any) -> Void)?##((Any) -> Void)?##(Any) -> Void#>, onError: <#T##((Error) -> Void)?##((Error) -> Void)?##(Error) -> Void#>, onCompleted: <#T##(() -> Void)?##(() -> Void)?##() -> Void#>, onDisposed: <#T##(() -> Void)?##(() -> Void)?##() -> Void#>)
         
         onNext: 是在接受到消息之后调用
         onError:是在接受到error消息之后调用
         onCompleted:是在接受到complete消息之后调用
         onDisposed:是在销毁之后调用
         
         */
//        observableCreate.subscribe(onNext: {
//            print($0)
//        })
        observableCreate.subscribe(onNext: {
            print($0)
        }, onError: {
            print($0)
        }, onCompleted: {
            print("complete")
        }) {
            print("disposed")
        }.disposed(by: disposeBag)
        
        observableDeferred.subscribe(onNext: { print($0)}).disposed(by: disposeBag)
    }
}




