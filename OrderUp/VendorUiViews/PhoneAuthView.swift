//
//  PhoneAuthView.swift
//  OrderUp
//
//  Created by Nana Bonsu on 10/24/23.
//

import SwiftUI

struct PhoneAuthView: View {
    //make  binding to the code variable provided by the model class
    @EnvironmentObject var signUpModel:SignUpViewModel
    
    
    var body: some View {
        VStack {
            
            Text("We've sent the verification code via SMS")
            
            TextField("Enter Code", text: $signUpModel.phoneVerificationCode)
                .font(.title)
                .padding(8)
                .background(
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(style: .init(lineWidth: 2, dash: [6], dashPhase: 0))
                )
//                .onSubmit {
//
//                }
                .padding(10)
            
            
                
            Button("Submit") {
                signUpModel.LoginUser()
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
