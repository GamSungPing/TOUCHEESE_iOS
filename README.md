# 📷 TOUCHEESE_iOS
> **쉽고 빠르게 원하는 스튜디오를 예약하는 플랫폼 서비스**

***TOUCH*** 는 셔터 촬영의 순간과 플랫폼을 통해 검색하는 터치의 의미를 갖으며, <br>
***CHEESE*** 는 촬영 시 모든 이들의 미소를 짓게 하는 마법 같은 의성어를 의미해요.

<br>

## 🧀 프로젝트 소개
### 개발 기간
**2024년 11월 14일 ~ 2024년 12월 23일 (총 40일)**

- **Sprint 1**: 2024년 11월 14일 ~ 2024년 11월 20일  
  원하는 컨셉과 정보에 따라 쉽게 스튜디오 정보를 필터링할 수 있다.
- **Sprint 2**: 2024년 11월 27일 ~ 2024년 12월 05일  
  각각의 스튜디오에 대한 객관적이고 신뢰할 수 있는 정보를 확인할 수 있다.
- **Sprint 3**: 2024년 12월 06일 ~ 2024년 12월 11일  
  사용자가 원하는 스튜디오를 예약하고 정보를 확인할 수 있다.
- **Sprint 4**: 2024년 12월 18일 ~ 2024년 12월 23일  
  소셜 로그인이 가능하며 로그인된 정보를 내 정보 탭에서 확인할 수 있다.
  
### 개발 및 테스트 환경

- **프로젝트 실행 방법**
```
프로젝트 빌드 시 GoogleService-Info.plist, Secrets.configs 파일이 필요합니다.
위의 두 파일은 본 프로젝트 실행 시 spdlqjrkdrjs@naver.com으로 요청해주세요.
```

- **Client**
  - Xcode 16.0
  - Swift 6.0
  - iOS 16.0+
  - SwiftUI
  - Portrait Only
  - LightMode Only
- **Database**
  - 서버: AWS EC2에서 Docker로 실행되는 Java 기반 Spring Boot 애플리케이션
  - 저장소: AWS RDS (MySQL) - 주 데이터베이스
  - Redis - 캐시 관리 (디바이스 토큰)
  - AWS S3 - 이미지 파일 스토리지
  - 알림: Firebase FCM을 통한 푸시 알림
  - 배포: GitHub Actions를 통한 CI/CD

### 사용 기술

- **Skills**
  - REST API 통신 (Alamofire 활용)
  - Kakao 로그인
  - 이미지 캐싱 처리
- **Library**
  - KakaoOpenSDK
  - Alamofire
  - Kingfisher
  - Firebase
<br>

## 🧀 앱 특징
### 스튜디오 찾기
> 🔍 터치즈만의 차별화된 검색 기능으로 사용자가 원하는 스튜디오를 쉽게 찾을 수 있어요.

<img src="/Previews/1.gif" width="30%"></img>

<br>

### 스튜디오 예약
> 📝 원하는 스튜디오를 찾았다면 터치즈를 통해서 간편하게 예약을 할 수 있어요.

<img src="/Previews/2.gif" width="30%"></img>

<br>

### 예약 일정 확인
> 🗓️ 예약 일정 및 상태를 확인하고, 원한다면 예약을 취소할 수 있어요.

<img src="/Previews/3.gif" width="30%"></img>

<br>

### 스튜디오 찜하기
> ❣️ 마음에 드는 스튜디오를 찜 해놓고, 나중에 바로 확인할 수 있어요.

<img src="/Previews/4.gif" width="30%"></img>

<br>

## 🧀 팀원 소개
<img src="https://avatars.githubusercontent.com/u/141600830?v=4" width="180">

[강건](https://github.com/kangsworkspace)<br>
내용을 작성하세요
<br><br>

<img src="https://avatars.githubusercontent.com/u/72730841?v=4" width="180">

[김성민](https://github.com/marukim365)
<br>

**담당 역할**
- Apple 로그인
- Access Token과 Refresh Token을 이용한 네트워크 통신
- Custom Navigation Bar & Tab Bar
- 스튜디오, 찜, 예약 목록 UI
<br>

**소감**<br><br>
다른 직군과의 첫 개발 경험! DTO? 스웨거?가 뭔지도 몰랐던 나인데... 이번 프로젝트를 마치고 나서 다음에도 충분히 API 통신을 할 수 있겠다는 자신감이 생겼다. 역시 처음에는 뭐든지 어렵지만 일단 부딪히고 경험하다 보면 생각보다 별거 아니구나!? 라는 생각이 든다.(그렇다고 자만하지 말고 계속 열심히 공부해야 한다!)<br><br>
물론 아쉬운 점도 많았다. 초반 계획 단계에서는 테스트 코드나 의존성 주입 등을 구현해보고자 했으나 개발 기간에 쫓겨 기능 구현에 바빴다. 이번 프로젝트를 이대로 끝내지 말고, 꼭! 리팩토링을 통해 공부와 기술적 도전을 해보고자 한다.<br><br>
부족한 나였지만, 옆에서 많이 도와주고 성장시켜준 팀장님과 팀원분들께 감사하다. 감성핑, 앞으로도 화이팅 👏

<br>

## 🧀 공지
앱에 대한 문의사항이나 사용 이미지에 문제가 있을 경우 아래의 이메일로 연락주세요.
```
spdlqjrkdrjs@naver.com
```
<br>

## 🧀 라이센스
Copyright (c) 2024 GamSungPing. All rights reserved.     
Licensed under the [MIT](LICENSE) license.
<br>
