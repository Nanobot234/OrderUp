//
//  PhoneAuthView.swift
//  OrderUp
//
//  Created by Nana Bonsu on 10/24/23.
//

import SwiftUI

///  Screen that displays textboc 
struct PhoneAuthView: View {
    //make  binding to the code variable provided by the model class
    @EnvironmentObject var signUpModel:AuthenticationViewModel
    @EnvironmentObject var navRouter: Router
    @State var userType:String //specifies the type of user thats trying to sign in
   // @State private var navBackButtonIsHidden = false
    
    var body: some View {
        VStack {
            
            Text("We've sent the verification code via SMS")
            
            TextField("Enter Code", text: $signUpModel.phoneVerificationCode)
                .font(.title)
                .padding(8)
                .padding(10)
                .textFieldStyle(.roundedBorder)
            
            
            
                
            Button("Submit") {
                if(userType == "vendor") {
                    Task {
                        signUpModel.vendorSignIn() //sign in here
        
                        //need to add code to show alert to the user, when there is an error
                       // gotoVendorHome()
                    }
                }
            }
            .frame(maxWidth: .infinity,maxHeight: 50)
            .padding(.horizontal,20)
            
            
        }
        .onDisappear {
            print("Count of nav when leaving phone auth screen is: \(navRouter.loginNavPath.count.description)")
        }
       
    }
    
    func gotoVendorHome(){
        navRouter.loginNavPath.append(ScreenRouter.VendorHomeScreen)
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
