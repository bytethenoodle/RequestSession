#if os(Linux)
import Glibc

func async(block: (Void) -> Void) {
  block()
}

import Foundation

extension String {
  func dataUsingEncoding(encoding: UInt) -> NSData? {
    self.withCString { (bytes) in
      return NSData(bytes: bytes, length: Int(strlen(bytes)))
    }
    return nil
  }
}
#else
import Dispatch

func async(block: @escaping (Void) -> Void) {
    
    DispatchQueue.global(qos: .background).async {
        block()
    }    
}
#endif

