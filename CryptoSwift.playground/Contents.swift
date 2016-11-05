//: Please build the scheme 'CryptoSwiftPlayground' first

import PlaygroundSupport
PlaygroundPage.current.needsIndefiniteExecution = true

import CryptoSwift

func xor(_ a: Array<UInt8>, _ b:Array<UInt8>) -> Array<UInt8> {
    var xored = Array<UInt8>(repeating: 0, count: min(a.count, b.count))
    for i in 0..<xored.count {
        xored[i] = a[i] ^ b[i]
    }
    return xored
}

extension String {
    func utf8Map() -> [UTF8.CodeUnit] {
        return utf8.map { $0 }
    }
}

func xor(_ s1: String, _ s2: String) -> Array<UInt8> {
    return xor(s1.utf8Map(), s2.utf8Map())
}

extension Sequence where Iterator.Element == UInt8 {
    func ascii() -> String {
        return String(bytes: self, encoding: String.Encoding.ascii) ?? ""
    }

    func lookup(test: String, filter: String? = nil) {
        let testCount = test.characters.count

        for i in 0..<(Array(self).count - testCount) {
            let ar = Array(Array(self)[i..<i+testCount])
            let testxor = xor(test.utf8Map(), ar)
            let ascii = testxor.ascii()

            if let filter = filter {
                if ascii.contains(filter) {
                    print(ascii)
                }
            } else {
                print(ascii)
            }
        }
    }
}

extension String {
    func hexadecimal() -> Data? {
        var data = Data(capacity: characters.count / 2)

        let regex = try! NSRegularExpression(pattern: "[0-9a-f]{1,2}", options: .caseInsensitive)
        regex.enumerateMatches(in: self, options: [], range: NSMakeRange(0, characters.count)) { match, flags, stop in
            let byteString = (self as NSString).substring(with: match!.range)
            var num = UInt8(byteString, radix: 16)!
            data.append(&num, count: 1)
        }

        guard data.count > 0 else {
            return nil
        }

        return data
    }
}

//
//let m1 = "Hello World"
//let m2 = "program the"
//let key = "supersecret"
//
//let c1 = xor(m1, key)
//let c2 = xor(m2, key)
//print(c1.toHexString(), c2.toHexString())
//
//let hex = "3b101c091d53320c000910".hexadecimal()?.bytes

//
//let c1c2 = xor(c1, c2)
//print(c1c2.toHexString())
//
//let the = "        the"
//
//let c1c2the = xor(the.utf8Map(), c1c2)
//
//print(c1c2the.ascii())

let c1 = "315c4eeaa8b5f8aaf9174145bf43e1784b8fa00dc71d885a804e5ee9fa40b16349c146fb778cdf2d3aff021dfff5b403b510d0d0455468aeb98622b137dae857553ccd8883a7bc37520e06e515d22c954eba5025b8cc57ee59418ce7dc6bc41556bdb36bbca3e8774301fbcaa3b83b220809560987815f65286764703de0f3d524400a19b159610b11ef3e".hexadecimal()!.bytes
let c2 = "234c02ecbbfbafa3ed18510abd11fa724fcda2018a1a8342cf064bbde548b12b07df44ba7191d9606ef4081ffde5ad46a5069d9f7f543bedb9c861bf29c7e205132eda9382b0bc2c5c4b45f919cf3a9f1cb74151f6d551f4480c82b2cb24cc5b028aa76eb7b4ab24171ab3cdadb8356f".hexadecimal()!.bytes

let c1c2 = xor(c1, c2)
c1c2.lookup(test: "0 probably enjoy ", filter: " or the number 15")

let test = " or the number 15 "
//let test = "0 probably enjoy "

let m1 = "0 probably enjoy "
let m2 = " or the number 15"













