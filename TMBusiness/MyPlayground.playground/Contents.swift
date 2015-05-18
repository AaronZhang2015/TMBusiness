//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"

var result = [UInt8]()
result.append(27)

println(result)

var content = "12"
let cfEnc = CFStringEncodings.GB_18030_2000
let enc = CFStringConvertEncodingToNSStringEncoding(CFStringEncoding(cfEnc.rawValue))
println(content.lengthOfBytesUsingEncoding(enc))