//
//  VendorSignUpView.swift
//  OrderUp
//
//  Created by Nana Bonsu on 8/23/23.
//

import SwiftUI
import ActionButton


///  Displays  SMS login fields to user
struct VendorSignUpView: View {
    
    @EnvironmentObject var signUpModel: SignUpViewModel
    @EnvironmentObject var router: Router
    
    @State var buttonState: ActionButtonState = .disabled(title: "Please enter your phone number", systemImage: "exclamationmark.circle")
    @State private var showSMSCodeEntryScreen = false
    
//    if signUpModel.showSMSCodeVerification {
//      showSMSCodeEntryScreen = true
//
//    }
    
  //   @FocusState var focus: FocusableField?
    
    var body: some View {
      
            
            VStack {
                //Will have a text field for signing up with mobile first as option
                //similar to uber
             
                
                Text("Enter your phone number")
                    .padding(20)
                
                HStack {
                    
                    TextField("1", text: $signUpModel.countryCode)
                        .padding(.vertical,12)
                        .padding(.horizontal)
                        .frame(width: 50)
                        .background(

                            RoundedRectangle(cornerRadius: 8)
                                .stroke( Color.gray)
                        )
                    TextField("Enter Your Phone Number", text: $signUpModel.mobileNumber)
                        .textContentType(.telephoneNumber)
                        .keyboardType(.numberPad)
                        .padding(.vertical,12)
                        .padding(.horizontal)
                        .background(
//                            //need to check the video with the
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.gray)
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
                }
                
                ActionButton(state: $buttonState, onTap: {
                
                    buttonState = .loading(title: "Verifying", systemImage: "")
                    signUpModel.verifyUserPhoneNumber { result in
                        if(result == "true") {
                            router.loginNavPath.append(Router.ScreenRouter.PhoneAuthScreen)
                        }
                    } //will verify the phone number now!!
                    //then make a condition, where the
                    
                    
                }, backgroundColor: .blue)
                
                //show the sms verification screen, if you se the binding to true.
//                if signUpModel.showSMSCodeVerification {
//
//                  showSMSCodeEntryScreen = true
//                }
              
            }
            .padding()
            
        
    }
}





struct VendorSignUpView_Previews: PreviewProvider {
    static var previews: some View {
        VendorSignUpView()
    }
}
