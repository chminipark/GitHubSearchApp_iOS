# Issue
1. Pagination이 10번 넘어가면 api호출 하는 부분에서 에러를 반환함
2. GitHub Search API가 1분당 10개로 제한되어있음
10개의 적은 Request Limit을 어떻게 처리할것인가 🧐  
#


1
``` swift
protocol Provider {
//    기존코드 Single로 반환
//    func request<E: RequestResponsable, R: Decodable>(endpoint: E) -> Single<R> where E.Response == R

//    Result로 Response와 Error를 모두 반환
    func request<E: RequestResponsable, R: Decodable>(endpoint: E) -> Observable<Result<R, Error>> where E.Response == R
}
```
기존 코드는 Single로 값을 하나만 반환해서 만약 `.failure`, 즉 `error`를 반환하면 Pagination 전체 스트림이 Dispose 되어버려 다음 Pagination이 동작하지 않음
그래서 `Result`를 사용하여 `response`, `error` 모두 반환한 다음 ViewModel에서 `switch`문으로 에러를 처리함  
#


2
``` swift
enum ViewState {
    case idle
    case isLoading
    case requestLimit
}
```
ViewState에 requestLimit 추가

``` swift
func checkResult(_ result: Result<[MySection], Error>) -> [MySection] {
        switch result {
        case .success(let mySection):
            return mySection
        case .failure(let error):
            guard let error = error as? NetworkError else {
                print(error.localizedDescription)
                return []
            }
            
// 에러타입이 .requestLimitError이면 viewState를 `.requestLimit`으로 변경,
            if error == .requestLimitError {
                viewState = .requestLimit
                currentPage -= 1
                return []
            }
            
            print(error.description)
            return []
        }
    }
```
에러타입이 .requestLimitError이면 viewState를 `.requestLimit`으로 변경

``` swift
var viewState: ViewState = .idle {
    didSet {
      switch viewState {
      case .requestLimit:
        alertRequestLimit.onNext(())
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(10)) { [weak self] in
          guard let `self` = self else {
            return
          }
          `self`.viewState = .idle
        }
      default:
        break
      }
    }
  }
```
`viewState == .requestLimit` 일때 10초 후에 `.idle`로 값 변경


``` swift
// `filter`를 사용하여 search viewState != .isLoading일때만 스트림 시작
func checkPagination() -> Bool {
    let originData = mySection.items as Array<Repository>
    if searchText == "" || viewState == .isLoading || originData.isEmpty {
      return false
    }
    
    return true
}
```
`filter`를 사용하여 search viewState != .isLoading일때만 스트림 시작



- [전체 PR 링크](https://github.com/chminipark/GitHubSearchApp_iOS/pull/22)

### 그외
- [PropertyWrapper](https://github.com/chminipark/GitHubSearchApp_iOS/pull/14)
- [Clean Architecture에 맞게 코드 분리](https://github.com/chminipark/GitHubSearchApp_iOS/pull/15)