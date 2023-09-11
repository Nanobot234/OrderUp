//
//  VendorSignUpView.swift
//  OrderUp
//
//  Created by Nana Bonsu on 8/23/23.
//

import SwiftUI
import ActionButton

//enum FocusableField: Hashable {
//    case phoneNumber
//}

struct VendorSignUpView: View {
    
    @StateObject var signUpModel = SignUpViewModel()
    @State var buttonState: ActionButtonState = .disabled(title: "Please enter your phone number", systemImage: "exclamationmark.circle")
  //   @FocusState var focus: FocusableField?
    
    var body: some View {
        VStack {
            //Will have a text field for signing up with mobile first as option
            //similar to uber
            
            HStack {
                
                TextField("1", text: $signUpModel.countryCode)
                    .padding(.vertical,12)
                    .padding(.horizontal)
                    .frame(width: 50)
                    .background(
                    
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(signUpModel.countryCode == "" ? Color.gray : Color("green"),lineWidth: 1.5)
                    )
                TextField("Enter Your Phone Number", text: $signUpModel.mobileNumber)
                    .textContentType(.telephoneNumber)
                    .keyboardType(.numberPad)
                    .padding(.vertical,12)
                    .padding(.horizontal)
                    .background(
                        //need to check the video with the
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(signUpModel.countryCode == "" ? Color.gray : Color("green"),lineWidth: 1.5)
                    )
                    .onChange(of: signUpModel.mobileNumber) {number in
                        let nonDigitCharacters = CharacterSet(charactersIn: number).subtracting(CharacterSet.decimalDigits)
                        let filteredString = number.components(separatedBy: nonDigitCharacters).joined()
                        if(number == filteredString && number.count == 10) {
                          buttonState = .enabled(title: "Next", systemImage: "checkmark.circle")
                        } else {
                            buttonState = .disabled(title: "Please enter your phone number", systemImage: "exclamationmark.circle")
                        }
                    }
                
                    
                //focused just binds
            }
            
            ActionButton(state: $buttonState, onTap: {
                //code here to sign up
            }, backgroundColor: .blue)
        }
        .padding()
        
    }
}

//may have another struct here for the othe  login buttone


struct VendorSignUpView_Previews: PreviewProvider {
    static var previews: some View {
        VendorSignUpView()
    }
}
