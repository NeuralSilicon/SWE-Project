

import UIKit
import Firebase


class RVC: UIViewController, StateDelegate, RegisterationDelegate {
    
    func createdUser(value: Bool) {
        if value == false{
            let activity = UIAlertController(title: nil, message: "Failed to register, this Email may be in used already.", preferredStyle: .alert)
            activity.addAction(UIAlertAction(title: "Done", style: .cancel, handler: nil))
            self.present(activity, animated: true, completion: nil)
            return
        }
        
        guard registerationForm == nil else {
            return
        }
        
        guard let uuid = UserDefaults.standard.value(forKey: "uuid") as? String else {return}
        client.uuid = uuid
        
        registerationForm = RegisterationForm(frame: self.view.bounds)
        registerationForm.parentPage = self
        registerationForm.clipsToBounds = false
        view.addSubview(registerationForm)
        NSLayoutConstraint.activate([
            registerationForm.topAnchor.constraint(equalTo: label.bottomAnchor, constant: .topConstant),
            registerationForm.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            registerationForm.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            registerationForm.heightAnchor.constraint(equalToConstant: view.frame.height*0.4),
            registerationForm.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        self.registerationForm.transform = CGAffineTransform(translationX: 0, y: self.view.frame.height)
        self.registerationForm.fullname.becomeFirstResponder()
        DispatchQueue.main.async {
            self.registerationForm.contentSize.height += 400
        }
        
        view.addSubview(register)
        NSLayoutConstraint.activate([
            register.topAnchor.constraint(equalTo: registerationForm.bottomAnchor, constant: .topStandAloneConstant),
            register.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            register.widthAnchor.constraint(greaterThanOrEqualToConstant: 100),
            register.heightAnchor.constraint(equalToConstant: 40),
        ])
        register.addTarget(self, action: #selector(RegisterInformation), for: .touchUpInside)
        
        UIView.animate(withDuration: 0.5) {
            self.username.alpha = 0.0; self.password.alpha = 0.0; self.loadmore.alpha = 0.0; self.passwordRequirement.alpha = 0.0
            self.registerationForm.transform = .identity
        }
        
    }
    
    func savedClient(value: Bool) {
        if value{
            self.dismiss(animated: true, completion: {
                self.delegate?.finishedRegisteration()
            })
        }
    }
    
    func selectedStated(with abbreviation: String) {
        DispatchQueue.main.async{
            self.registerationForm.state.text = "  " + abbreviation
        }
    }
    
    var label:UILabel={
        let label = UILabel()
        label.Label(textColor: .black, textAlignment: .left, fontSize: 30, font: .AppleSDGothicNeo_Regular)
        label.text = "\n  Register"
        label.backgroundColor = .Indicator
        
        return label
    }()

    var username:TextField={
        let text = TextField()
        text.placeholder = "Email Address"
        text.textAlignment = .left
        text.textColor = .Dark
        text.tag = 0
        text.textContentType = .none
        text.returnKeyType = .next
        text.keyboardType = .emailAddress
        return text
    }()
    
    var password:TextField={
        let text = TextField()
        text.placeholder = "Password"
        text.textAlignment = .left
        text.textColor = .Dark
        text.tag = 1
        text.returnKeyType = .next
        text.isSecureTextEntry = true
        return text
    }()
    
    var passwordRequirement:UILabel={
        let label = UILabel()
        label.Label(textColor: .Light, textAlignment: .center, fontSize: 15, font: .AppleSDGothicNeo_Regular)
        label.text = "Password req: uppercase and lowercase letter (A, z), numeric character (0-9), special character, and length between 6-12"
        return label
    }()
    
    var loadmore:UIButton={
        let button = UIButton()
        button.Button(text: "Next")
        return button
    }()
    
    var register:UIButton={
        let button = UIButton()
        button.Button(text: "Register")
        return button
    }()
        
    var close:UIButton={
        let button = UIButton()
        button.Button(text: "")
        button.setImage(UIImage(systemName: "xmark")?.applyingSymbolConfiguration(.init(pointSize: 15, weight: .regular)), for: .normal)
        button.tintColor = .white
        button.backgroundColor = .black
        return button
    }()
    
    var registerationForm:RegisterationForm!
    var client=Client()
    var address=Address()
    weak var delegate:ReserveVCDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        addsubviews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.username.becomeFirstResponder()
    }

}

extension RVC:UITextFieldDelegate{

    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.addRightView(rightView: "")
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.addRightView(rightView: "")
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.tag == 0{
            password.becomeFirstResponder()
        }else{
            textField.resignFirstResponder()
        }
        return true
    }
}
