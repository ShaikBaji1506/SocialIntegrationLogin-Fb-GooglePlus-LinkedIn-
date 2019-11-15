//
//  ViewController.swift
//  SocialLoginDemo
//
//  Created by Shaik Baji on 01/03/19.
//  Copyright © 2019 smartitventures.com. All rights reserved.
//

import UIKit
import FacebookCore
import FacebookLogin
import GoogleSignIn


class ViewController: UIViewController,GIDSignInUIDelegate,GIDSignInDelegate
{
    
    
   override func viewDidLoad()
    {
        super.viewDidLoad()
       
        
    }
    
    

    @IBAction func fbLoginBtnTapped(_ sender: UIButton)
    {
        let manager = LoginManager()
        manager.logIn(readPermissions:[.email,.publicProfile], viewController:self) { (result) in
            
            switch result
            {
            case.cancelled:
                
                print("User cancelled login process")
                break
            case.failed(let error) :
                print("Login failed with error = \(error.localizedDescription)")
                break
            case .success(let grantedPermissions, let declinedPermissions, let accessToken):
                print("Logged in : \(grantedPermissions), \n \(declinedPermissions), \n \(accessToken.appId), \n \(accessToken.authenticationToken), \n \(accessToken.expirationDate), \n \(accessToken.userId!), \n \(accessToken.refreshDate), \n \(accessToken.grantedPermissions!)")
                
                let request = GraphRequest(graphPath: "me", parameters: ["fields": "id, email, name, first_name, last_name, picture.type(large)"], accessToken: AccessToken.current, httpMethod: .GET, apiVersion: FacebookCore.GraphAPIVersion.defaultVersion)
                request.start { (response, result) in
                    switch result
                    {
                    case .success(let value):
                        
                        print(value.dictionaryValue!)
                        
//                        let vc = self.storyboard?.instantiateViewController(withIdentifier:"Second") as! Second
//                        self.navigationController?.pushViewController(vc, animated:true)
                        
                        print("Email Id == \(String(describing: value.dictionaryValue!["email"] as? String))")
                        
                    case .failed(let error):
                        print(error)
                    }
                }
        }
    }
    }
 
    @IBAction func logOutFB(_ sender: UIButton)
    {
        let manager = LoginManager()
        manager.logOut()
    }
    
    
    
    
    @IBAction func googlePlusLogin(_ sender: UIButton)
    {
        GIDSignIn.sharedInstance()?.delegate = self
        GIDSignIn.sharedInstance()?.uiDelegate = self
        GIDSignIn.sharedInstance()?.signIn()
    }
    
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!)
    {
        if let error = error
        {
            print("We have error \(error)")
        }
        else
        {
            if let gmailUser = user
            {
                print("The USer Email Id == \(gmailUser.profile.email!)")
                
                print("The USer Email Id == \(gmailUser.profile.familyName!)")
                
                print("The USer Email Id == \(gmailUser.profile.givenName!)")
                
                
                
            }
        }
    }

    @IBAction func linkedInBtnTapped(_ sender: UIButton)
    {
        
//        let permissions = [LISDK_BASIC_PROFILE_PERMISSION]
//
//        LISDKSessionManager.createSession(withAuth:permissions, state:nil, showGoToAppStoreDialog:true, successBlock: { (returnState) in
//
//            let session = LISDKSessionManager.sharedInstance()?.session
//
//            print("The Session == \(String(describing: session?.description))")
//
//            LISDKAPIHelper.sharedInstance()?.getRequest("https://api.linkedin.com/v1/people/-", success: { (response)
//                in
//
//                if let response = response
//                {
//                    let data = response.data.data(using:.utf8)
//                    let dictResponse = try! JSONSerialization.jsonObject(with:data!, options:.mutableContainers) as! NSDictionary
//                    let name = dictResponse.value(forKey:"firstName")
//                    let detail = dictResponse.value(forKey:"headline")
//                    let imgUrl = dictResponse.value(forKey:"siteStandardProfileRequest.url")
//
//                    print("The Name == \(name)")
//
//                    print("The detail == \(detail)")
//
//                }
//
//            }, error: { (error) in
//                print("The Error == \(String(describing: error?.localizedDescription))")
//            })
//
//        }) { (error) in
//
//            print("The Error == \(String(describing: error?.localizedDescription))")
//        }
//
        
        
        /*LISDKSessionManager.createSession(withAuth:[LISDK_BASIC_PROFILE_PERMISSION], state:nil, showGoToAppStoreDialog:true, successBlock: { (success) in
            
            let session = LISDKSessionManager.sharedInstance()?.session
            let url = "https://api.linkedin.com/v1/people/-"
            
            if(LISDKSessionManager.hasValidSession())
            {
                LISDKAPIHelper.sharedInstance()?.getRequest(url, success: { (response) in
                    
                    print(response?.data)
                    
                }, error: { (error) in
                    
                    print("The Error == \(error)")
                })
            }
            
        }) { (error) in
        
             print("The Error == \(error)")
        }
 */
        
        
        
        let permission = [LISDK_BASIC_PROFILE_PERMISSION,LISDK_EMAILADDRESS_PERMISSION]
        LISDKSessionManager.createSession(withAuth: permission, state: nil, showGoToAppStoreDialog: true, successBlock: { (returnState) in
            let  session = LISDKSessionManager.sharedInstance().session
            print(session?.description as Any)
            LISDKAPIHelper.sharedInstance().getRequest("https://api.linkedin.com/v1/people/~:(id,first-name,last-name,headline,public-profile-url,picture-url,email-address,picture-urls::(original))", success: {(response) in
                
                if let response = response{
                    let data = response.data.data(using: .utf8)
                    let dictResponse = try! JSONSerialization.jsonObject(with: data!, options: .mutableContainers ) as! NSDictionary
                    let fName:String = dictResponse.value(forKey: "firstName") as! String
                    print("First_Name.......\(String(describing: fName))")
                    
                    let lName:String = dictResponse.value(forKey: "lastName") as! String
                    print("Last_Name.......\(String(describing: lName))")
                    
                    let userID = dictResponse.value(forKey: "id") as! String
                    print("Client_Id.......\(String(describing: userID))")
                    
                    let emailID = dictResponse.value(forKey: "emailAddress") as! String
                    print("EMAIL.......\(String(describing: emailID))")
                    
                    let imgUrl = dictResponse.value(forKeyPath: "pictureUrl") as! String
                    print("IMG_URL.......\(String(describing: imgUrl))")
                    
                    
                }
            }, error: {(error) in
                print(error?.localizedDescription as Any )
            })
        }){(error) in
            print(error?.localizedDescription  as Any)
            
        }
        
        
        
       }
}


