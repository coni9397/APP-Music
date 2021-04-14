//
//  RegisterController.swift
//  MusicApp
//
//  Created by Constanza Hernandez Uribe on 10-04-21.
//
import  Foundation
import UIKit
import FirebaseAuth

class RegisterController: UIViewController {
    
    
    @IBOutlet weak var txtPass: UITextField!
    @IBOutlet weak var txtCorreo: UITextField!
    @IBOutlet weak var lblDateBirth: UITextField!
    
    @IBOutlet weak var btnRegister: UIButton!
    
    var datePicker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.navigationController?.isNavigationBarHidden = false
        setupdddadtePicker()
    }
    override func viewWillAppear(_ animated: Bool)
    {
        self.navigationController?.isNavigationBarHidden = false
        btnRegister.layer.cornerRadius = 20
    }
    func setupdddadtePicker(){
        
        self.datePicker = UIDatePicker.init(frame: CGRect(x:0, y: 0, width: self.view.bounds.width, height:200))
        datePicker.locale = Locale(identifier: "es")
        datePicker.datePickerMode = .date
        datePicker.addTarget(self, action: #selector(self.dateChange), for: .allEvents)
        
        if #available(iOS 13.4, *)
        {
            datePicker.preferredDatePickerStyle = .wheels
        }
        
        self.lblDateBirth.inputView = datePicker
        let  toolBar : UIToolbar = UIToolbar.init(frame: CGRect(x:0,y:0,width : self.view.bounds.width, height : 44))
        let  spaceButton:UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action:nil)
        let  dondeButton:UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: #selector(self.tapOnDoneButton))
        
        toolBar.setItems([spaceButton, dondeButton], animated: true)
        
        self.lblDateBirth.inputAccessoryView = toolBar
    }
    
    @objc func dateChange()
    {
        let dateFormat = DateFormatter()
        dateFormat.dateStyle = .short
        
        self.lblDateBirth.text = dateFormat.string(from: datePicker.date)
    }
    @objc func tapOnDoneButton()
    {
        lblDateBirth.resignFirstResponder()
    }
    @IBAction func Register(_ sender: Any)
    {
        if  let email = txtCorreo.text,  let pass = txtPass.text
        {
            Auth.auth().createUser(withEmail: email, password: pass)
            {
                (result, error) in
                if let result = result,error == nil
                {
                    self.navigationController?.pushViewController(ViewController(), animated: true)
                }
                else
                {
                    let alertController = UIAlertController(title: "Error", message: "Error Al registrar Usuario", preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: "Aceptar", style: .default))
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
    }
}
