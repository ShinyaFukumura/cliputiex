//
//  PasteboardWatcher.swift
//  PasteboardWatcher
//
//  Created by Devarshi Kulshreshtha on 6/19/15.PasteboardWatcher
//  Customized by Shinya Fukumura on 5/5/19
//  Copyright © 2015 Devarshi Kulshreshtha. All rights reserved.
//
import Cocoa

/// Protocol defining the methods which delegate has/ can implement
protocol PasteboardWatcherDelegate {
    
    /// the method which is invoked on delegate when a new url of desired kind is copied
    /// - Parameter copiedUrl: the newly copied url of desired kind
    // fukumura ... not use newlyCopiedUrlObtained
    //func newlyCopiedUrlObtained(copiedUrl : NSURL)
    // fukumura ... create new function to check availability
    func isAvailable() -> Bool
}

/// Use this class to notify a delegate once a url with specified kind is copied
/// - Credit goes to: **Josh Goebel**
/// - His wonderful pastie: [PasteboardWatcher in objective-c](http://pastie.org/1129293)
class PasteboardWatcher : NSObject {
    
    // assigning a pasteboard object
    private let pasteboard = NSPasteboard.general
    
    // to keep track of count of objects currently copied
    // also helps in determining if a new object is copied
    private var changeCount : Int
    
    // used to perform polling to identify if url with desired kind is copied
    private var timer: Timer?
    
    // the delegate which will be notified when desired link is copied
    var delegate: PasteboardWatcherDelegate?
    
    // the kinds of files for which if url is copied the delegate is notified
    private let initialChars: [String]
    
    /// initializer which should be used to initialize object of this class
    /// - Parameter fileKinds: an array containing the desired file kinds
    // fukumura ... change variable "fileKinds" to "initialChars"
    init(initialChars: [String]) {
        // assigning current pasteboard changeCount so that it can be compared later to identify changes
        changeCount = pasteboard.changeCount
        
        // assigning passed desired file kinds to respective instance variable
        self.initialChars = initialChars
        
        super.init()
    }
    
    /// starts polling to identify if url with desired kind is copied
    /// - Note: uses an NSTimer for polling
    // fukumura ... change timeInterval value 2 to 1
    func startPolling () {
        // setup and start of timer
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(PasteboardWatcher.checkForChangesInPasteboard), userInfo: nil, repeats: true)
    }
    
    /// method invoked continuously by timer
    /// - Note: To keep this method as private I referred this answer at stackoverflow - [Swift - NSTimer does not invoke a private func as selector](http://stackoverflow.com/a/30947182/217586)
    @objc private func checkForChangesInPasteboard() {
        // check availability
        if (self.delegate?.isAvailable())! {
            // check if there is any new item copied
            // also check if kind of copied item is string
            if let copiedString = pasteboard.string(forType: NSPasteboard.PasteboardType.string), pasteboard.changeCount != changeCount {
                // define pasted string
                var resultString = ""
                // separate string to each single lines
                let stringArray = copiedString.components(separatedBy: .newlines)
                // for each line
                for str in stringArray {
                    // trim leading and trailing whitespace
                    var tmpString = str.trimmingCharacters(in: .whitespaces)
                    // check initial character
                    for char in initialChars {
                        if let range = tmpString.range(of: char) {
                            // if initical character is "#" or "$" then
                            if tmpString.distance(from: tmpString.startIndex, to: range.lowerBound) == 0 {
                                // remove initial character
                                tmpString.removeSubrange(range)
                                break
                            }
                        }
                    }
                
                    // trim again and append string
                    resultString.append(tmpString.trimmingCharacters(in: .whitespaces))
                    // append new line
                    resultString.append("\n")
                }
            
                // clear clipboard
                pasteboard.clearContents()
                // set result string to clipboard
                if pasteboard.setString(resultString, forType: NSPasteboard.PasteboardType.string) {
                    print("success paste new string.")
                }else{
                    print("fail paste new string.")
                }

                // assign new change count to instance variable for later comparison
                changeCount = pasteboard.changeCount
            }
        }
    }
}
