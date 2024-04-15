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
   
    
    @EnvironmentObject var signUpModel: AuthenticationViewModel
    @EnvironmentObject var router: Router
    
    @State var buttonState: ActionButtonState = .disabled(title: "Please enter your phone number", systemImage: "exclamationmark.circle")
    @State private var showSMSCodeEntryScreen = false
    
    
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
                    TextField("Enter Your Phone Number", text: $signUpModel.userMobileNumber)
                        .textContentType(.telephoneNumber)
                        .keyboardType(.numberPad)
                        .padding(.vertical,12)
                        .padding(.horizontal)
                        .background(
//                            //need to check the video with the
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.gray)
                        )
                        .onChange(of: signUpModel.userMobileNumber) {number in
                            verifyPhoneNumber(enteredNum: number)
                        }
                }
                
                ActionButton(state: $buttonState, onTap: {
                
                    buttonState = .loading(title: "Verifying", systemImage: "")
                    FSAuthManager.shared.phoneNumberVerfication(countryCode: signUpModel.countryCode, mobileNumber: signUpModel.userMobileNumber) { result, errMessage  in
                            
                        if(result != nil) {
                            self.signUpModel.phoneVerificationCredential = result!
                        } else {
                            //Will display error message to the use rher
                        }
                        
                            router.loginNavPath.append(ScreenRouter.VendorPhoneAuthScreen)
                    }
                    
                }, backgroundColor: .blue)
                
                //show the sms verification screen, if you se the binding to true.
//                if signUpModel.showSMSCodeVerification {
//
//                  showSMSCodeEntryScreen = true
//                }
              
            }
            .padding()
            
        
    }
    
    func verifyPhoneNumber(enteredNum:String) {
        
        let nonDigitCharacters = CharacterSet(charactersIn: enteredNum).subtracting(CharacterSet.decimalDigits)
        let filteredString = enteredNum.components(separatedBy: nonDigitCharacters).joined()
        if(enteredNum == filteredString && enteredNum.count == 10) {
            buttonState = .enabled(title: "Next", systemImage: "checkmark.circle")
        } else {
            buttonState = .disabled(title: "Please enter your phone number", systemImage: "exclamationmark.circle")
        }

    }
    
    
}





struct VendorSignUpView_Previews: PreviewProvider {
    static var previews: some View {
        VendorSignUpView()
    }
}
