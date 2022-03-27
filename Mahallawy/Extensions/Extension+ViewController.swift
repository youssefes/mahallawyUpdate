//
//  Extension+ViewController.swift
//  Opportunities
//
//  Created by youssef on 12/6/20.
//  Copyright © 2020 youssef. All rights reserved.
//

import UIKit
import WebKit

extension UIViewController {
    
    func cellAnimation(cell : UITableViewCell){
        let retaionAngelInRadian = 180 * CGFloat(Double.pi / 90)
        let rotationTransform = CATransform3DMakeRotation(retaionAngelInRadian, 0, 0, 1)
        cell.layer.transform = rotationTransform
        
        UIView.animate(withDuration: 1.2) {
            cell.layer.transform = CATransform3DTranslate(CATransform3DIdentity, 500, 100, 0)
        }
    }
    
    
    func getYoutubeId(youtubeUrl: String) -> String? {
        return URLComponents(string: youtubeUrl)?.queryItems?.first(where: { $0.name == "v" })?.value
    }

}

extension UIViewController {
    var isModal: Bool {
        if let index = navigationController?.viewControllers.firstIndex(of: self), index > 0 {
            return false
        } else if presentingViewController != nil {
            return true
        } else if navigationController?.presentingViewController?.presentedViewController == navigationController {
            return true
        } else if tabBarController?.presentingViewController is UITabBarController {
            return true
        } else {
            return false
        }
    }
}


// singly rather than doubly linked list implementation
// private, as users of Queue never use this directly
private final class QueueNode<T> {
    // note, not optional – every node has a value
    var value: T
    // but the last node doesn't have a next
    var next: QueueNode<T>? = nil

    init(value: T) { self.value = value }
}

// Ideally, Queue would be a struct with value semantics but
// I'll leave that for now
public final class Queue<T> {
    // note, these are both optionals, to handle
    // an empty queue
    private var head: QueueNode<T>? = nil
    private var tail: QueueNode<T>? = nil

    public init() { }
}


extension Queue {
    // append is the standard name in Swift for this operation
    public func append(newElement: T) {
        let oldTail = tail
        self.tail = QueueNode(value: newElement)
        if  head == nil { head = tail }
        else { oldTail?.next = self.tail }
    }

    public func dequeue() -> T? {
        if let head = self.head {
            self.head = head.next
            if head.next == nil { tail = nil }
            return head.value
        }
        else {
            return nil
        }
    }
}
