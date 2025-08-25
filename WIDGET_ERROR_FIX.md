# 위젯 실행 에러 해결 가이드

## 에러 메시지
```
Please specify the widget kind in the scheme's Environment Variables 
using the key '_XCWidgetKind' to be one of: 'PastaTimerWidget'
```

## 해결 방법

### 1. 위젯 Scheme 설정

#### 방법 A: 새 Scheme 생성 (권장)
1. **Xcode 상단 메뉴 → Product → Scheme → Edit Scheme**
2. **좌측 하단 "+" 버튼 클릭**
3. **Target: PastaTimerWidgetExtension 선택**
4. **Name: "PastaTimerWidget" 입력**
5. **OK 클릭**

#### 방법 B: 기존 Scheme 수정
1. **Scheme 선택 드롭다운 → PastaTimerWidgetExtension 선택**
2. **Product → Scheme → Edit Scheme**
3. **Run → Arguments 탭**
4. **Environment Variables 섹션에 추가:**
   - Name: `_XCWidgetKind`
   - Value: `PastaTimerWidget`

### 2. 위젯 실행 방법

#### 시뮬레이터에서 테스트
1. **Scheme을 "PastaTimerWidgetExtension"으로 변경**
2. **시뮬레이터 선택 (iPhone 16 등)**
3. **Run (⌘+R)**
4. **위젯 선택 화면이 나타남**
5. **PastaTimerWidget 선택**

#### 실제 기기에서 테스트
1. **메인 앱 실행 (PastaPortionPro scheme)**
2. **홈 화면으로 나가기**
3. **홈 화면 길게 누르기**
4. **"+" 버튼 탭**
5. **PastaPortionPro 검색**
6. **Pasta Timer 위젯 추가**

### 3. Live Activity 테스트 (다이나믹 아일랜드)

#### Xcode에서 설정 필요
1. **메인 앱 타겟 선택**
2. **Info.plist에 추가:**
   ```xml
   <key>NSSupportsLiveActivities</key>
   <true/>
   ```

#### 코드 활성화
1. **PastaTimerActivity.swift를 프로젝트에 추가**
   - Xcode Navigator에서 PastaPortionPro(SwiftUI)/Model 폴더 우클릭
   - Add Files to "PastaPortionPro"
   - PastaTimerActivity.swift 선택
   - Target Membership: PastaPortionPro 체크

2. **StopWatch.swift의 주석 해제**
   - 715-738 라인의 TODO 주석 제거
   - PastaTimerActivityManager 호출 활성화

### 4. 빌드 설정 확인

#### Widget Extension Info.plist
```xml
<key>NSExtension</key>
<dict>
    <key>NSExtensionPointIdentifier</key>
    <string>com.apple.widgetkit-extension</string>
</dict>
```

#### Widget 코드 확인
```swift
struct PastaTimerWidget: Widget {
    let kind: String = "PastaTimerWidget"  // 이 값이 _XCWidgetKind와 일치해야 함
    // ...
}
```

### 5. 일반적인 문제 해결

#### 위젯이 나타나지 않을 때
1. **Clean Build Folder** (⇧⌘K)
2. **Derived Data 삭제**
   - ~/Library/Developer/Xcode/DerivedData
3. **시뮬레이터 재시작**
4. **Xcode 재시작**

#### Live Activity가 작동하지 않을 때
1. **iOS 16.1 이상 확인**
2. **설정 → Face ID 및 암호 → 잠금 상태에서 액세스 허용**
   - Live Activities 활성화
3. **iPhone 14 Pro 이상** (다이나믹 아일랜드)

### 6. 디버깅 팁

#### 콘솔 로그 확인
```swift
print("Widget kind: \(kind)")
print("Live Activity started: \(activity.id)")
```

#### Widget Preview
```swift
#Preview(as: .systemSmall) {
    PastaTimerWidget()
} timeline: {
    SimpleEntry(date: .now, emoji: "😀")
}
```

### 7. 추가 참고사항

- Widget과 Live Activity는 별개 기능
- Widget: 홈 화면 위젯
- Live Activity: 다이나믹 아일랜드 + 잠금화면
- 둘 다 동시에 사용 가능

## 요약 체크리스트

- [ ] Widget Scheme 생성 또는 수정
- [ ] _XCWidgetKind 환경 변수 설정
- [ ] NSSupportsLiveActivities를 Info.plist에 추가
- [ ] PastaTimerActivity.swift를 프로젝트에 추가
- [ ] StopWatch.swift 주석 해제
- [ ] Clean Build 수행
- [ ] 시뮬레이터에서 테스트