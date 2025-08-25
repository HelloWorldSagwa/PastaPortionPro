# Live Activity (다이나믹 아일랜드) 설정 가이드

## 구현 완료 사항

### 1. 생성된 파일들
- **PastaTimerActivity.swift**: Live Activity 구현 코드
  - 다이나믹 아일랜드 UI
  - 잠금화면 타이머 UI
  - ActivityManager로 타이머 제어

### 2. StopWatch.swift 연동
- 타이머 시작 시 Live Activity 자동 시작
- 매초 업데이트
- 일시정지/재개 지원
- 타이머 종료 시 자동 제거

## Xcode 설정 필요 사항

### 1. Info.plist 설정
메인 앱 타겟의 Info.plist에 다음 항목 추가:

1. **프로젝트 Navigator에서 앱 타겟 선택**
2. **Info 탭 선택**
3. **Custom iOS Target Properties에 추가:**

```
Key: NSSupportsLiveActivities
Type: Boolean
Value: YES
```

또는 Info.plist 소스 코드에 직접 추가:
```xml
<key>NSSupportsLiveActivities</key>
<true/>
```

### 2. 앱 Capabilities 설정
1. **프로젝트 파일 선택**
2. **메인 앱 타겟 선택**
3. **Signing & Capabilities 탭**
4. **"+ Capability" 클릭**
5. **"Push Notifications" 추가** (Live Activity 업데이트용)

### 3. Build Settings 확인
1. **메인 앱 타겟 선택**
2. **Build Settings 탭**
3. **검색: "Deployment Target"**
4. **iOS Deployment Target: 16.1 이상** 확인

### 4. PastaTimerActivity.swift 파일 추가
1. **Xcode에서 PastaPortionPro(SwiftUI)/Model 폴더 선택**
2. **File → Add Files to "PastaPortionPro"**
3. **PastaTimerActivity.swift 선택**
4. **Target Membership:**
   - ✅ PastaPortionPro (메인 앱)
   - ✅ PastaTimerWidget (위젯 익스텐션)

## 사용 방법

### 타이머 시작
1. 앱에서 타이머 시작
2. 자동으로 다이나믹 아일랜드에 표시
3. 홈 화면으로 나가면 계속 표시

### 다이나믹 아일랜드 상태
- **최소화**: 타이머 아이콘과 남은 시간
- **확장**: 진행 바, 일시정지 상태, 남은 시간 표시
- **탭하면**: 앱으로 돌아감

### 잠금화면
- 큰 타이머 디스플레이
- 진행률 표시
- 일시정지 상태 표시

## 기능

### 구현된 기능
✅ 타이머 시작 시 Live Activity 자동 생성
✅ 실시간 카운트다운 업데이트
✅ 일시정지/재개 상태 표시
✅ 진행률 표시 (원형, 바 형태)
✅ 다이나믹 아일랜드 UI (최소화/확장)
✅ 잠금화면 UI
✅ 타이머 종료 시 자동 제거

### 추가 가능한 기능
- [ ] 버튼으로 직접 일시정지/재개 (iOS 17+)
- [ ] 여러 타이머 동시 지원
- [ ] 알림음 커스터마이징
- [ ] Apple Watch 연동

## 테스트 방법

### 다이나믹 아일랜드 테스트 (iPhone 14 Pro 이상)
1. 앱에서 타이머 시작
2. 홈으로 나가기
3. 다이나믹 아일랜드 확인
4. 길게 눌러 확장 뷰 확인

### 잠금화면 테스트
1. 타이머 실행 중 화면 잠금
2. 잠금화면에서 타이머 확인
3. Face ID/Touch ID 없이도 타이머 보임

## 문제 해결

### Live Activity가 표시되지 않는 경우
1. **설정 → Face ID 및 암호 → 잠금 상태에서 액세스 허용**
   - Live Activities 활성화 확인
2. **설정 → 앱 이름 → Live Activities**
   - 활성화 확인
3. **iOS 16.1 이상** 확인

### 다이나믹 아일랜드가 없는 기기
- iPhone 14 Pro 이전 모델은 잠금화면에만 표시
- 알림 센터에서도 확인 가능

## 디자인 커스터마이징

### 색상 변경
`PastaTimerActivity.swift`에서:
- `Color("mainRed")` → 원하는 색상으로 변경

### 레이아웃 수정
- `LockScreenLiveActivityView`: 잠금화면 UI
- `DynamicIsland` 블록: 다이나믹 아일랜드 UI

## 주의사항

1. **배터리 사용**: Live Activity는 8시간 후 자동 종료
2. **시스템 제한**: 동시에 여러 Live Activity 실행 시 제한 있음
3. **업데이트 빈도**: 너무 자주 업데이트하면 제한될 수 있음

## 개발자 참고사항

### ActivityKit 문서
- [Apple Developer Documentation](https://developer.apple.com/documentation/activitykit)
- [Human Interface Guidelines](https://developer.apple.com/design/human-interface-guidelines/live-activities)

### 디버깅 팁
- Console에서 "Live Activity" 필터로 로그 확인
- `print("Started Live Activity with ID: \(activity.id)")` 확인