import Foundation
import Inquiline
import Requests

public class HTTPSessionConfiguration {
  public var HTTPAdditionalHeaders = [String:String]()

  public class func defaultSessionConfiguration() -> HTTPSessionConfiguration {
    return HTTPSessionConfiguration()
  }
}

public typealias HTTPCompletionFunc = ((NSData?, NSURLResponse?, NSError?) -> Void)

public class HTTPSessionDataTask {
  let completion: HTTPCompletionFunc
  let configuration: HTTPSessionConfiguration
  let URL: NSURL

  private init(configuration: HTTPSessionConfiguration, URL: NSURL, completion: HTTPCompletionFunc) {
    self.completion = completion
    self.configuration = configuration
    self.URL = URL
  }

  private func makeError(message: String? = nil) -> NSError {
    #if os(Linux)
    var userInfo = [String:Any]()
    #else
    var userInfo = [String:String]()
    #endif

    if let message = message {
      userInfo[NSLocalizedDescriptionKey] = message
    }
    return NSError(domain:"org.vu0.RequestSession", code: 23, userInfo: userInfo)
  }

  private func perform() {
#if os(Linux)
    let urlString = URL.absoluteString!
#else
    let urlString = URL.absoluteString
#endif

    let headers = configuration.HTTPAdditionalHeaders.map { ($0.0, $0.1) }
    var response: Response?

    do {
      response = try get(urlString, headers: headers)
    } catch {
      completion(nil, nil, makeError(String(error)))
      return
    }

    if let response = response, body = response.body {
      let urlResponse = NSHTTPURLResponse(URL: URL, statusCode: 200,
        HTTPVersion: "1.1", headerFields: nil)
      completion(body.dataUsingEncoding(NSUTF8StringEncoding), urlResponse, nil)
    } else {
      completion(nil, nil, makeError("Empty HTTP response body."))
    }
  }

  public func resume() {
    async { self.perform() }
  }
}

public class HTTPSession {
  let configuration: HTTPSessionConfiguration

  public init(configuration: HTTPSessionConfiguration) {
    self.configuration = configuration
  }

  public func dataTaskWithURL(url: NSURL, completion: HTTPCompletionFunc) -> HTTPSessionDataTask {
    return HTTPSessionDataTask(configuration: configuration, URL: url, completion: completion)
  }
}
