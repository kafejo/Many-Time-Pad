# Many Time Pad

Swift playground with example of attack to OTP where key is used to encrypt multiple messages.

## Example

Lets say we have four ciphers encrypted by OTP but all of them used the same key.

```Swift
let c1 = "315c4eeaa8b5f8aaf9174145bf43e1784b8fa00dc71d885a804e5ee9fa40b16349c146fb778cdf2d3aff021dfff5b403b510d0d0455468aeb98622b137dae857553ccd8883a7bc37520e06e515d22c954eba5025b8cc57ee59418ce7dc6bc41556bdb36bbca3e8774301fbcaa3b83b220809560987815f65286764703de0f3d524400a19b159610b11ef3e".hexadecimal()!.bytes
let c2 = "234c02ecbbfbafa3ed18510abd11fa724fcda2018a1a8342cf064bbde548b12b07df44ba7191d9606ef4081ffde5ad46a5069d9f7f543bedb9c861bf29c7e205132eda9382b0bc2c5c4b45f919cf3a9f1cb74151f6d551f4480c82b2cb24cc5b028aa76eb7b4ab24171ab3cdadb8356f".hexadecimal()!.bytes

let c3 = "32510ba9a7b2bba9b8005d43a304b5714cc0bb0c8a34884dd91304b8ad40b62b07df44ba6e9d8a2368e51d04e0e7b207b70b9b8261112bacb6c866a232dfe257527dc29398f5f3251a0d47e503c66e935de81230b59b7afb5f41afa8d661cb".hexadecimal()!.bytes

let c4 = "32510ba9aab2a8a4fd06414fb517b5605cc0aa0dc91a8908c2064ba8ad5ea06a029056f47a8ad3306ef5021eafe1ac01a81197847a5c68a1b78769a37bc8f4575432c198ccb4ef63590256e305cd3a9544ee4160ead45aef520489e7da7d835402bca670bda8eb775200b8dabbba246b130f040d8ec6447e2c767f3d30ed81ea2e4c1404e1315a1010e7229be6636aaa".hexadecimal()!.bytes
```

We start by xoring c1 and c2 and looking up for most common english word " the "

```Swift
let c1c2 = xor(c1, c2)

let test = " the "

c1c2.lookup(test: test, filter: nil)

// -> found "robab" -> maybe "probably" ?

```

We found ascii sequence "robab" which may be word " probably ". Lets continue digging.

```
c1c2.lookup(test: " probably ", filter: "the")

// -> found " or the num" -> maybe " or the number " ?

c1c2.lookup(test: " or the number ", filter: " probably ")

// -> found "0 probably enjo" -> maybe "0 probably enjoy " ?
// and so on so on..

c1c2.lookup(test: "0 probably enjoy ", filter: "the")

```

Now we know that m1 or m2 contains string "0 probably enjoy " starting from 10th to 27th position (result of lookup). Now we can recover part of the key

```
let k = c2.recoverKey(m: "0 probably enjoy ", from: 10)
let m = c4.decrypt(key: k, offset: 10)
print("m:", m.ascii())

// recovered - key [part 10-27 bytes]
// 612acd6395102eafce78aa7fed28a07f6b
```

See the playground for more details.

## Author

Ales Kocur
