# Live Activity 디버깅 및 활성화 가이드

## 현재 상황
- Live Activity 코드는 작성되었지만 Xcode 프로젝트에 추가되지 않음
- 타이머가 다이나믹 아일랜드와 잠금화면에서 동작하지 않음

## 해결 방법

### 1. PastaTimerActivity.swift를 Xcode 프로젝트에 추가

#### 단계별 방법:
1. **Xcode 열기**
2. **왼쪽 Navigator에서 `PastaPortionPro(SwiftUI)` → `Model` 폴더 우클릭**
3. **"Add Files to PastaPortionPro..." 선택**
4. **`PastaTimerActivity.swift` 파일 찾아서 선택**
5. **Options 확인:**
   - ✅ Copy items if needed (체크 해제 - 이미 있음)
   - ✅ PastaPortionPro (Target에 체크)
6. **"Add" 클릭**

### 2. Info.plist 설정 추가

#### Xcode에서:
1. **프로젝트 Navigator에서 PastaPortionPro 타겟 선택**
2. **Info 탭**
3. **Custom iOS Target Properties에 추가:**
   ```
   Key: NSSupportsLiveActivities
   Type: Boolean  
   Value: YES
   ```

### 3. StopWatch.swift 주석 해제

파일 위치: `/PastaPortionPro(SwiftUI)/View/Main/Timer/StopWatch.swift`

#### 주석 해제할 부분들:
- **라인 720-729**: 타이머 시작 시 Live Activity 시작
- **라인 742-748**: 타이머 완료 시 Live Activity 종료
- **라인 757-763**: 타이머 일시정지 시 Live Activity 일시정지

주석 기호 `/*` 와 `*/`를 제거하면 됩니다.

### 4. 빌드 및 실행

1. **Clean Build Folder** (Shift+Cmd+K)
2. **Build** (Cmd+B)
3. **Run** (Cmd+R)

### 5. 콘솔 로그 확인

Xcode 콘솔에서 다음 로그들을 확인:
```
🚀 Timer started with 480 seconds
✅ Started Live Activity
   - ID: [activity-id]
   - Pasta: Pasta
   - Duration: 480 seconds
   - End Time: [timestamp]
⏱️ Timer tick: 479 seconds remaining
⏱️ Timer tick: 478 seconds remaining
...
⏸️ Timer paused
⏸️ Paused Live Activity with 450s remaining
```

### 6. Live Activity 테스트

#### 다이나믹 아일랜드 (iPhone 14 Pro+):
1. 타이머 시작
2. 홈 화면으로 나가기
3. 다이나믹 아일랜드에 타이머 표시 확인
4. 다이나믹 아일랜드 길게 눌러 확장 뷰 확인

#### 잠금화면:
1. 타이머 실행 중 화면 잠금
2. 잠금화면에 큰 타이머 표시 확인
3. 실시간 카운트다운 확인

## 주요 변경사항

### Text(timerInterval:) 사용
기존 방식:
```swift
Text(formatTime(context.state.remainingTime))
```

새로운 방식 (자동 카운트다운):
```swift
Text(timerInterval: Date.now...context.state.endTime, countsDown: true)
```

이렇게 하면 SwiftUI가 자동으로 1초마다 업데이트합니다.

### Date 기반 카운트다운
- `remainingTime: Int` → `endTime: Date`
- 매초 업데이트 불필요
- 시스템이 자동으로 카운트다운 처리

## 문제 해결

### "Cannot find 'PastaTimerActivityManager' in scope" 에러
→ PastaTimerActivity.swift를 프로젝트에 추가

### Live Activity가 표시되지 않음
→ Info.plist에 NSSupportsLiveActivities 추가

### 타이머가 카운트다운되지 않음
→ Text(timerInterval:) 사용 확인

### 콘솔에 로그가 안 보임
→ Xcode 콘솔 필터 확인 (All Output 선택)

## 디버깅 팁

1. **설정 확인**
   - 설정 → Face ID 및 암호 → Live Activities 활성화
   - 설정 → PastaPortionPro → Live Activities 활성화

2. **시뮬레이터 한계**
   - 다이나믹 아일랜드는 실제 기기에서만 완전히 테스트 가능
   - 시뮬레이터는 잠금화면 Live Activity만 테스트 가능

3. **로그 레벨**
   - ✅ 성공: 녹색 체크마크
   - ❌ 실패: 빨간 X
   - ⚠️ 경고: 노란 경고
   - 📱 업데이트: 폰 아이콘
   - ⏸️ 일시정지: 일시정지 아이콘
   - 🛑 정지: 정지 신호