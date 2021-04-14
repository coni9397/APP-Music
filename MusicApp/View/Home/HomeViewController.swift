//
//  HomeViewController.swift
//  MusicApp
//
//  Created by Constanza Hernandez Uribe on 13-04-21.
//

import  Foundation
import UIKit
import FirebaseAuth
import GoogleSignIn
enum ProviderType : String {
    case basic, google
}

class HomeViewController: UIViewController
{
    @IBOutlet weak var lblCorreo: UILabel!
    
    @IBOutlet weak var btnOutSesion: UIButton!
    public var email : String = ""
    public var provider : ProviderType = ProviderType(rawValue: "") ?? .basic
   
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        title = "Home"
        navigationItem.setHidesBackButton(true, animated: false)
        lblCorreo.text = email
        
        //Guardar sesion
        
        let defaults = UserDefaults.standard
        defaults.set(email, forKey: "email")
        defaults.set(provider.rawValue, forKey : "provider")
        defaults.synchronize()
    }
    override func viewWillAppear(_ animated: Bool)
    {
        
    }
    
    @IBAction func OutSesionAction(_ sender: Any)
    {
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: "email")
        defaults.removeObject(forKey : "provider")
        defaults.synchronize()
        switch provider{
        case .basic:
           fireBaseLogOut()
            
        case .google:
            GIDSignIn.sharedInstance()?.signOut()
            fireBaseLogOut()
        }
        navigationController?.popViewController(animated: true)
    }
    private func fireBaseLogOut()
    {
        do
        {
            try Auth.auth().signOut()
        }
        catch
        {
            //ERROr
        }
    }
}

