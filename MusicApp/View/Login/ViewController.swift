//
//  ViewController.swift
//  MusicApp
//
//  Created by Constanza Hernandez Uribe on 10-04-21.
//

import UIKit
import  Foundation
import FirebaseAnalytics
import FirebaseAuth
import GoogleSignIn
class ViewController: UIViewController
{

    
    //Oulet
    @IBOutlet weak var lblUser: UITextField!
    
    @IBOutlet weak var lblPass: UITextField!
    
    @IBOutlet weak var btnRegister: UIButton!
    @IBOutlet weak var btnLoginGoogle: UIButton!
    @IBOutlet weak var btnLogin: UIButton!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        // Evento ed analitics
        Analytics.logEvent("inicio", parameters: ["inicioapp" : "integracionLista"])
        
        //Ver si usuario ya esta loggeado
        validdateSesion()
        loginGoogle ()
        
    }
    override func viewWillAppear(_ animated: Bool)
    {
        self.navigationController?.isNavigationBarHidden = true
        customElemnt()
    }
   
    //Aciones de botones
    @IBAction func loginAction(_ sender: Any)
    {
        login ()
    }
    @IBAction func LoginGoogleAction
    (_ sender: Any)
    {
        GIDSignIn.sharedInstance()?.signOut()
        GIDSignIn.sharedInstance()?.signIn()
    }
    //Funciones
    func customElemnt()
    {
        btnLogin.layer.cornerRadius = 20
        //Limpiamos campos
        lblUser.text = ""
        lblPass.text = ""
    }
    func login ()
    {
        if  let email = lblUser.text,  let pass = lblPass.text
        {
            Auth.auth().signIn(withEmail: email, password: pass)
            { (result, error) in
                if let result = result, error == nil
                {
                 let storyboard = UIStoryboard (name: "Home", bundle: nil)
                 let resultVC = storyboard.instantiateViewController(withIdentifier: "HomeViewController")as! HomeViewController
                 resultVC.email = result.user.email ?? ""
                 resultVC.provider = .basic
                 self.navigationController?.pushViewController(resultVC, animated: true)
                }
                else
                {
                 let alertController = UIAlertController(title: "Error", message: "Correo o contraseña incorrecta.", preferredStyle: .alert)
                 alertController.addAction(UIAlertAction(title: "Aceptar", style: .default))
                 self.present(alertController, animated: true, completion: nil)
                }
            }
        }
    }
    func validdateSesion()
    {
        let defaults = UserDefaults.standard
        //preguntamos si encuentra email y provider
        if let email = defaults.value(forKey: "email") as? String,
           let provider = defaults.value(forKey: "provider")as? String
        {
            //Navegamos a pantalla home
            let storyboard = UIStoryboard (name: "Home", bundle: nil)
            let resultVC = storyboard.instantiateViewController(withIdentifier: "HomeViewController")as! HomeViewController
            resultVC.email = email
            resultVC.provider = ProviderType.init(rawValue: provider)!
            self.navigationController?.pushViewController(resultVC, animated: true)
        }
    }
    func loginGoogle ()
    {
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance()?.delegate = self
    
    }
}
extension ViewController: GIDSignInDelegate
{
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!)
    {
        if error == nil && user.authentication != nil
        {
            let credential = GoogleAuthProvider.credential(withIDToken: user.authentication.idToken, accessToken: user.authentication.accessToken)
            Auth.auth().signIn(with: credential, completion: { (result, error) in
                if let result = result, error == nil
                {
                 let storyboard = UIStoryboard (name: "Home", bundle: nil)
                 let resultVC = storyboard.instantiateViewController(withIdentifier: "HomeViewController")as! HomeViewController
                 resultVC.email = result.user.email ?? ""
                    resultVC.provider = .google
                 self.navigationController?.pushViewController(resultVC, animated: true)
                }
                else
                {
                 let alertController = UIAlertController(title: "Error", message: "Correo o contraseña incorrecta.", preferredStyle: .alert)
                 alertController.addAction(UIAlertAction(title: "Aceptar", style: .default))
                 self.present(alertController, animated: true, completion: nil)
                }
            })
        }
    }
    
    
}
