//
//  Provider.swift
//  GitHubSearchApp
//
//  Created by chmini on 2022/10/17.
//

import Foundation
import RxSwift

protocol Provider {
  func request<E: RequestResponsable, R: Decodable>(endpoint: E)
  -> Observable<Result<R, NetworkError>> where E.Response == R
}

class ProviderImpl: Provider {
  static let shared = ProviderImpl(session: URLSession.shared)
  let session: URLSessionable
  
  init(session: URLSessionable) {
    self.session = session
  }
  
  func request<E: RequestResponsable, R: Decodable>(endpoint: E)
  -> Observable<Result<R, NetworkError>> where E.Response == R {
    return Observable.create { [weak self] emitter in
      guard let `self` = self else {
        return Disposables.create()
      }
      
      do {
        let urlRequest = try endpoint.makeURLRequest()
        
        `self`.session.dataTask(with: urlRequest) { data, response, error in
          `self`.checkError(data: data, response: response, error: error) { result in
            switch result {
            case .success(let data):
              do {
                let decodedData = try JSONDecoder().decode(R.self, from: data)
                emitter.onNext(.success(decodedData))
              } catch {
                emitter.onNext(.failure(NetworkError.decodingError))
              }
            case .failure(let error):
              emitter.onNext(.failure(error))
            }
          }
        }.resume()
      } catch {
        emitter.onNext(.failure(.urlReqeustError(error as! URLRequestError)))
      }
      
      return Disposables.create()
    }
  }
  
  func checkError(data: Data?,
                  response: URLResponse?,
                  error: Error?,
                  completion: @escaping (Result<Data, NetworkError>) -> Void) {
    if let error = error {
      completion(.failure(NetworkError.responseError(error)))
      return
    }
    
    guard let response = response as? HTTPURLResponse else {
      completion(.failure(NetworkError.unknownError))
      return
    }
    
    if response.statusCode != 200 {
      if response.statusCode == 403 {
        completion(.failure(NetworkError.requestLimitError))
      }
      completion(.failure(NetworkError.statusCodeError(response.statusCode)))
      return
    }
    
    guard let data = data else {
      completion(.failure(NetworkError.noDataError))
      return
    }
    
    completion(.success(data))
  }
}
