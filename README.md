# GitHub Repo Search App
GitHub API를 활용한 깃헙 레포 검색 앱

## Preview
![GitHubSearchAppgif](https://user-images.githubusercontent.com/77793412/201511799-21c0a681-9e9f-40b0-b3e6-2e5855c8df95.gif)

## Feature
- 최소 타켓 : iOS 14.0
- Clean Architecture + MVVM 패턴 적용
- 코드 베이스 UI
- CoreData 프레임워크를 사용하여 즐겨찾기 목록 유지
- Pagination 구현

## Description
- 레포 검색 뷰
    - Pagination prefetching 방식
    - debounce
- 디테일 웹 뷰
    - WebView 기반 연결 `SFSafariViewController` 사용
- 즐겨찾기 뷰
    - 즐겨찾기 목록 관리

## Project Layer Overview
##### 참고한 CleanArchitecture Layer
![high_level_overview](https://user-images.githubusercontent.com/77793412/226510244-0614cee7-4450-48c4-98a1-4017d42f3bca.png)
- Domain Layer : Entities, UseCase, GatewayProtocol
- Data Layer : Gateway, GitHubAPI, CoreData
- Presentation Layer : View, ViewModel, UseCaseProtocol

##### 프로젝트 레이어
![Screenshot 2023-03-21 at 12 07 31 PM](https://user-images.githubusercontent.com/77793412/226509107-d5f5f5bb-80e0-4213-96dd-6f90e585545d.png)
##### 폴더트리구조
<img width="224" alt="Screenshot 2023-03-21 at 12 17 35 PM" src="https://user-images.githubusercontent.com/77793412/226510088-594947ab-ba17-43d1-a6c6-ed5e81c33e07.png">

## Dependency
- [RxSwift, RxCocoa, RxBlocking](https://github.com/ReactiveX/RxSwift)
- [RxDataSource](https://github.com/RxSwiftCommunity/RxDataSources)

## Rules
- [Airbnb Swift Style Guide](https://github.com/airbnb/swift)
- [Commit Convention](docs/CommitConvention.md)
- Git Flow 적용
    - main, feature 브랜치 운영
    - 되도록 두줄, `rebase` 활용

## [Issue](docs/Issue.md)