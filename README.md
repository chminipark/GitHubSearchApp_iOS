# GitHub Repo Search App
GitHub API를 활용한 깃헙 레포 검색 앱

# Description
- 최소 타켓 : iOS 14.0
- Clean Architecture + MVVM 패턴 적용
- 코드 베이스 UI
- CoreData 프레임워크를 사용하여 즐겨찾기 목록 유지
- Pagination 구현

# Feature
- 레포 검색 뷰
    - Pagination prefetching 방식
    - debounce
- 디테일 웹 뷰
    - WebView 기반 연결 `SFSafariViewController` 사용
    - 링크 클립보드 복사
- 즐겨찾기 뷰
    - 즐겨찾기 목록 관리

# Preview
![GitHubSearchAppgif](https://user-images.githubusercontent.com/77793412/201511799-21c0a681-9e9f-40b0-b3e6-2e5855c8df95.gif)

# Library
> RxSwift, RxCocoa, RxDataSource, RxBlocking

# Rules
- [Swift Style Guide](https://github.com/StyleShare/swift-style-guide)
- [Commit Convention](https://velog.io/@shin6403/Git-git-%EC%BB%A4%EB%B0%8B-%EC%BB%A8%EB%B2%A4%EC%85%98-%EC%84%A4%EC%A0%95%ED%95%98%EA%B8%B0)
- Git Flow 적용
    - main, feature 브랜치 운영
    - 되도록 두줄

# Issue
- [PropertyWrapper](https://github.com/chminipark/GitHubSearchApp_iOS/pull/14)
- [Clean Architecture에 맞게 코드 분리](https://github.com/chminipark/GitHubSearchApp_iOS/pull/15)
- [Pagination](https://github.com/chminipark/GitHubSearchApp_iOS/pull/22)

