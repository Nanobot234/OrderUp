//
//  PhoneAuthView.swift
//  OrderUp
//
//  Created by Nana Bonsu on 10/24/23.
//

import SwiftUI

struct PhoneAuthView: View {
    //make  binding to the code variable provided by the model class
    @EnvironmentObject var signUpModel:AuthenticationViewModel
    
    
    var body: some View {
        VStack {
            
            Text("We've sent the verification code via SMS")
            
            TextField("Enter Code", text: $signUpModel.phoneVerificationCode)
                .font(.title)
                .padding(8)
               
//                .onSubmit {
//
//                }
                .padding(10)
            
            
                
            Button("Submit") {
                FSAuthManager.shared.userSignIn(phoneCredential: self.signUpModel.phoneVerificationCredential, phoneVerificationCode: self.signUpModel.phoneVerificationCode)
            }
            
            if signUpModel.loginStatus {
                MainView()
            }
        }
    }
    
    
}



//struct PhoneAuthView_Previews: PreviewProvider {
//   static var previews: some View {
////        @Binding var code:String
////
////        code = "100011"
////       PhoneAuthView(code: $code)
//   }
//
//}
