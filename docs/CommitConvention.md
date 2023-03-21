# Git - Commit Message Convention

## 1. Commit Message Structure

기본적으로 커밋 메시지는 아래와 같이 제목/본문/꼬리말로 구성한다.

```
// subject
[Feat] : 기능 추가

// body
data fetch 로직 추가

// footer
Git: #1
```

## 3. subject
- [Tag Name] : Description
#### 3-1. Commit Type
|Tag Name|Description|
|---|---|
|Feat|새로운 기능을 추가|
|Fix|버그 수정|
|Design|사용자 UI 디자인 변경|
|Refactor|프로덕션 코드 리팩토링|
|Test|테스트 코드, 리펙토링 테스트 코드 추가, Production Code(실제로 사용하는 코드) 변경 없음|
|Docs|문서 수정|
|Chore|빌드 업무 수정, 패키지 매니저 수정, 패키지 관리자 구성 등 업데이트, Production Code 변경 없음|

## 4. body
- 선택사항이기 때문에 모든 커밋에 본문내용을 작성할 필요는 없다.
- 부연설명이 필요하거나 커밋의 이유를 설명할 경우 작성해준다.
- 어떻게 변경했는지보다 무엇을, 왜 변경했는지 작성한다.

## 5. fotter
- 선택사항이기 때문에 모든 커밋에 꼬리말을 작성할 필요는 없다.
- issue tracker id를 작성할 때 사용한다.