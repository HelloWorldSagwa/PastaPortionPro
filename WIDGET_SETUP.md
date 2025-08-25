# PastaPortionPro Widget Setup Guide

## 위젯 타이머 기능 구현 완료

### 구현된 기능
1. **실시간 타이머 위젯**: 앱을 닫아도 위젯에서 타이머가 계속 표시됩니다
2. **App Group을 통한 데이터 공유**: 메인 앱과 위젯이 타이머 데이터를 공유합니다
3. **자동 업데이트**: 타이머가 실행 중일 때 매초 자동으로 업데이트됩니다

### Xcode에서 설정 필요 사항

#### 1. Widget Extension 추가
1. Xcode에서 프로젝트 선택
2. File → New → Target
3. "Widget Extension" 선택
4. Product Name: "PastaTimerWidget"
5. Include Configuration Intent 체크 해제
6. Finish

#### 2. App Groups 설정

##### 메인 앱 설정:
1. PastaPortionPro 타겟 선택
2. Signing & Capabilities 탭
3. "+ Capability" 클릭
4. "App Groups" 추가
5. App Group 이름: `group.com.studio5.pastaportionpro`

##### 위젯 Extension 설정:
1. PastaTimerWidget 타겟 선택
2. Signing & Capabilities 탭
3. "+ Capability" 클릭
4. "App Groups" 추가
5. 동일한 App Group 선택: `group.com.studio5.pastaportionpro`

#### 3. 파일 추가
위젯 타겟에 다음 파일들을 추가해야 합니다:
- `PastaTimerWidget.swift` (이미 생성됨)
- `TimerDataStore.swift` (Target Membership에 위젯도 추가)

#### 4. Build Phases 설정
1. PastaTimerWidget 타겟 선택
2. Build Phases → Compile Sources
3. `TimerDataStore.swift` 추가 확인

### 사용 방법

#### 앱에서 타이머 시작:
```swift
// 타이머 시작 (8분)
TimerDataStore.shared.startTimer(duration: 480)

// 타이머 일시정지
TimerDataStore.shared.pauseTimer()

// 타이머 재개
TimerDataStore.shared.resumeTimer()

// 타이머 중지
TimerDataStore.shared.stopTimer()
```

#### 위젯 추가:
1. 홈 화면 길게 누르기
2. "+" 버튼 탭
3. "PastaPortionPro" 검색
4. "Pasta Timer" 위젯 선택
5. 원하는 크기 선택 (Small 또는 Medium)
6. 위젯 추가

### 위젯 기능

- **실행 중**: 초록색 점과 함께 남은 시간이 카운트다운으로 표시
- **일시정지**: 회색으로 남은 시간과 "PAUSED" 표시
- **비활성**: "No Timer" 메시지 표시

### 주의사항

1. **App Group ID**: 실제 앱 배포 시 Bundle Identifier에 맞게 수정 필요
2. **Background Modes**: 백그라운드에서 타이머가 정확히 작동하려면 Background Modes 설정 필요
3. **위젯 새로고침**: iOS는 위젯 업데이트 빈도를 제한할 수 있음

### 추가 개선 사항 (선택)

1. **Live Activity** (iOS 16.1+): Dynamic Island와 Lock Screen에서 실시간 타이머 표시
2. **Interactive Widget** (iOS 17+): 위젯에서 직접 타이머 제어
3. **Multiple Timers**: 여러 파스타 타이머 동시 지원
4. **Complications**: Apple Watch 지원

### 테스트 방법

1. 앱에서 타이머 시작
2. 홈 화면으로 나가기
3. 위젯에서 타이머 확인
4. 앱 완전히 종료
5. 위젯이 계속 업데이트되는지 확인

### 문제 해결

**위젯이 업데이트되지 않는 경우:**
- App Groups 설정 확인
- Bundle Identifier 일치 확인
- 위젯 제거 후 다시 추가

**타이머가 부정확한 경우:**
- Date() 기반 계산으로 정확도 보장
- Background refresh 설정 확인