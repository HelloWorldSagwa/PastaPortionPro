//
//  Style.swift
//  PastaPortionPro(SwiftUI)
//
//  Created by SungHyun Kim on 2023/09/02.
//

import SwiftUI
import UIKit
import Combine


// ---인트로 버튼 스타일 설정---
struct StyledButtonModifier: ViewModifier {
    func body(content: Content) -> some View {
        
        let fixedRadius : CGFloat = 10.0
        
        content
            .font(.system(size: 25))  // 폰트 사이즈 설정
            .foregroundColor(Color.white)  // 버튼의 전경색을 하얀색으로 설정
            .frame(maxWidth: .infinity)
            .frame(height: 25)
            .padding()  // 패딩을 추가하여 버튼 주변에 여백 생성
            .background(Color.mainRed)  // 버튼의 배경색을 파란색으로 설정
            .cornerRadius(fixedRadius)  // 버튼의 모서리를 둥글게 만드는데 사용되는 코너 반지름 값 설정
            .overlay(RoundedRectangle(cornerRadius: fixedRadius)  // 스트로크 추가
                .stroke(Color.black, lineWidth: 0.5))
            .fontWeight(.bold)  // 폰트를 진하게 (Bold)
        
    }
    
    
}


// --- 타이머 버튼 스타일 설정 ---

struct StyledButtonWithoutFontSizeModifier: ViewModifier {
    func body(content: Content) -> some View {
       
        let buttonWidth : CGFloat = UIScreen.main.bounds.width / 3
        let fixedRadius : CGFloat = 10.0
        
        content
            .foregroundColor(Color.white)  // 버튼의 전경색을 하얀색으로 설정
            .frame(width: buttonWidth, height: 25)  // 너비 200, 높이 50으로 버튼 크기
            .padding()  // 패딩을 추가하여 버튼 주변에 여백 생성
            .background(Color.mainRed)  // 버튼의 배경색을 파란색으로 설정
            .cornerRadius(fixedRadius)  // 버튼의 모서리를 둥글게 만드는데 사용되는 코너 반지름 값 설정
            .overlay(RoundedRectangle(cornerRadius: fixedRadius)  // 스트로크 추가
                .stroke(Color.black, lineWidth: 0.5))
            .fontWeight(.bold)  // 폰트를 진하게 (Bold)
        
    }
    
    
}




struct StyledTextFieldModifier: ViewModifier {
    func body(content: Content) -> some View {
        
        content
            .padding()
            .overlay(RoundedRectangle(cornerRadius: 10)
                .stroke(Color.mainRed))
        
    }
    
    
    
    
}




//--------------------------------메인컬러 정의--------------------------------//

extension Color {
    
    static let mainRed = Color(red: 194/255, green: 34/255, blue: 44/255)     // 메인 빨강색
    static let mainMint = Color(red: 180/255, green: 240/255, blue: 220/255)     // 메인 민트색
    static let mainPink = Color(red: 255/255, green: 228/255, blue: 225/255)  // 메인 핑크
    
    static let mainOrange = Color(red: 255/255, green: 138/255, blue: 0)    // 서브 주황색
    static let flagGreen = Color(red: 238 / 255, green: 35 / 255, blue: 50 / 255)  // 이태리 깃발 초록색
    static let flagRed = Color(red: 70 / 255, green: 188 / 255, blue: 80 / 255)  // 인태리 깃발 빨간색
    static let mainGray =  /*@START_MENU_TOKEN@*/Color(red: 0.949, green: 0.949, blue: 0.971)/*@END_MENU_TOKEN@*/ // List, Srollview 기본배경색상
    
   
    
}



//--------------------------------IntroView디자인--------------------------------//


// 일반 버튼 - 공통적용
func groupOfTextFields(title: String, placeholder: String, text: Binding<String>) -> some View {
    VStack(alignment: .leading, spacing: 0) {  // 간격을 줄임
        Text(title)
            .font(.headline)
            .foregroundColor(.black)
        
        TextField(placeholder, text: text)
            .modifier(StyledTextFieldModifier())
    }
    .padding()  // 하단 패딩만 추가
}




//--------------------------------키보드Done버튼--------------------------------//

struct DoneButtonTextField: UIViewRepresentable {
    
    @Binding var text: String
    
    func makeUIView(context: Context) -> UITextField {
        let textField = UITextField()
        textField.delegate = context.coordinator
        textField.returnKeyType = .done
        return textField
    }
    
    func updateUIView(_ uiView: UITextField, context: Context) {
        uiView.text = text
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UITextFieldDelegate {
        var parent: DoneButtonTextField
        
        init(_ parent: DoneButtonTextField) {
            self.parent = parent
        }
        
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            textField.resignFirstResponder()
            return true
        }
        
        func textFieldDidEndEditing(_ textField: UITextField) {
            parent.text = textField.text ?? ""
        }
    }
}

//                                    키보드 입력할 때 사용법
//                                    DoneButtonTextField(text: $userName)
//                                                .frame(height: 40)
//                                                .border(Color.gray)


//--------------------------------키보드 return키 익스텐션--------------------------------//

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}


//--------------------------------숫자패드가 나오는 텍스트필드--------------------------------//

struct NumberTextField: UIViewRepresentable {
    @Binding var text: String
    var placeholder: String
    var keyType: UIKeyboardType
    
    func makeUIView(context: UIViewRepresentableContext<NumberTextField>) -> UITextField {
        let textField = UITextField(frame: .zero)
        textField.delegate = context.coordinator
        textField.keyboardType = keyType
        textField.placeholder = placeholder
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: context.coordinator, action: #selector(Coordinator.doneButtonTapped))
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar.items = [flexSpace, doneButton]
        textField.inputAccessoryView = toolbar
        
        return textField
    }
    
    func updateUIView(_ uiView: UITextField, context: UIViewRepresentableContext<NumberTextField>) {
        uiView.text = text
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UITextFieldDelegate {
        var parent: NumberTextField
        
        init(_ parent: NumberTextField) {
            self.parent = parent
        }
        
        @objc func doneButtonTapped() {
            parent.text = parent.text
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
        
        func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            if let newValue = textField.text as NSString? {
                let updatedValue = newValue.replacingCharacters(in: range, with: string)
                parent.text = updatedValue
            }
            return true
        }
    }
}

//--------------------------------커스텀텍스트필드(with Done키)--------------------------------//


struct CustomNumberTextField: UIViewRepresentable {
    @Binding var text: String
    var placeholder: String
    
    func makeUIView(context: Context) -> UITextField {
        let textField = UITextField()
        textField.keyboardType = .decimalPad
        textField.delegate = context.coordinator
        return textField
    }
    
    func updateUIView(_ uiView: UITextField, context: Context) {
        uiView.text = text
        uiView.placeholder = placeholder
        
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: uiView.frame.size.width, height: 44))
        
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: context.coordinator, action: #selector(Coordinator.doneTapped))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        toolBar.items = [flexibleSpace, doneButton]
        uiView.inputAccessoryView = toolBar
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UITextFieldDelegate {
        var parent: CustomNumberTextField
        
        init(_ parent: CustomNumberTextField) {
            self.parent = parent
        }
        
        @objc func doneTapped() {
            parent.text = parent.text
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
        
        func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            guard let text = textField.text else { return true }
            let newString = (text as NSString).replacingCharacters(in: range, with: string)
            
            // 숫자인지 확인
            let isNumeric = Double(newString) != nil || newString.isEmpty
            // 점의 수를 확인
            let numberOfDots = newString.filter { $0 == "." }.count
            // 맨 앞의 문자가 0인지 확인
            let leadingZero = newString.hasPrefix("0")
            
            // 모든 조건을 만족하는지 확인
            if isNumeric && numberOfDots <= 1 && !leadingZero {
                parent.text = newString
                return true
            } else {
                // 맨 앞의 0을 허용하지만 그 다음에는 소수점이 와야 함
                if leadingZero && numberOfDots == 1 {
                    parent.text = newString
                    return true
                }
                return false
            }
        }
        
    }
}


//---- 별 ----

struct StarRatingView: View {
    let rating: Int

    init(rating: Int) {
        self.rating = rating
    }

    var body: some View {
        ZStack{
            
            Rectangle()
                .frame(width: 32, height: 32)
                .cornerRadius(2.0)
                .foregroundColor(.mainRed)
            
            Image(systemName: "star.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 30)
                .foregroundColor(Color.white)

            Text("\(rating)")
                .fontWeight(.heavy)
                .font(.system(size: 13))
                .foregroundColor(Color.mainRed)
                .offset(y: 1.5)

        }
    }
}


// Picker() height 조절
extension UISegmentedControl {
    override open func didMoveToSuperview() {
        super.didMoveToSuperview()
//        self.setContentHuggingPriority(.defaultLow, for: .vertical)  // << here !!
    }
}



//삼각형마커 아까워서 놔둠
//struct Triangle : Shape {
//    func path(in rect:CGRect)-> Path {
//        Path{ path in
//            path.move(to:CGPoint(x:rect.midX,y:rect.maxY))  // 시작점을 아래쪽 중앙으로 변경
//            path.addLine(to:CGPoint(x:rect.minX,y:rect.minY))  // 첫 번째 선은 위쪽 왼쪽으로 그림
//            path.addLine(to:CGPoint(x:rect.maxX,y:rect.minY))  // 두 번째 선은 위쪽 오른쪽으로 그림
//            path.closeSubpath()
//        }
//    }
//}
//

