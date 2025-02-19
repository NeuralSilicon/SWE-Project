

import UIKit

extension ReVC{
    
    
    func addsubviews(){
               
        view.addSubview(label)
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: -50),
            label.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            label.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            label.heightAnchor.constraint(greaterThanOrEqualToConstant: 120)
        ])
                        
        username.delegate = self
        view.addSubview(username)
        NSLayoutConstraint.activate([
            username.topAnchor.constraint(equalTo: label.bottomAnchor, constant: .topConstant*2),
            username.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: .leftConstant),
            username.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: .rightConstant),
            username.heightAnchor.constraint(greaterThanOrEqualToConstant: 40),
            username.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
   
        
        password.delegate = self
        view.addSubview(password)
        NSLayoutConstraint.activate([
            password.topAnchor.constraint(equalTo: username.bottomAnchor, constant: .topConstant),
            password.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: .leftConstant),
            password.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: .rightConstant),
            password.heightAnchor.constraint(greaterThanOrEqualToConstant: 40),
            password.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        let button = UIButton()
        button.setImage(UIImage(systemName: "eye.slash"), for: .normal)
        button.frame.size = CGSize(width: 50, height: 40)
        button.backgroundColor = .clear
        button.tintColor = .Dark
        password.rightView = button
        password.rightViewMode = .always
        button.addTarget(self, action: #selector(passwordSecureKey), for: .touchUpInside)
        
        view.addSubview(passwordRequirement)
        NSLayoutConstraint.activate([
            passwordRequirement.topAnchor.constraint(equalTo: password.bottomAnchor, constant: .topConstant),
            passwordRequirement.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: .leftConstant),
            passwordRequirement.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: .rightConstant),
            passwordRequirement.heightAnchor.constraint(greaterThanOrEqualToConstant: 40),
            passwordRequirement.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        
        view.addSubview(loadmore)
        NSLayoutConstraint.activate([
            loadmore.topAnchor.constraint(equalTo: passwordRequirement.bottomAnchor, constant: .topConstant),
            loadmore.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadmore.widthAnchor.constraint(greaterThanOrEqualToConstant: 100),
            loadmore.heightAnchor.constraint(equalToConstant: 40),
        ])
        loadmore.addTarget(self, action: #selector(LoadMore), for: .touchUpInside)

    }
    
    @objc private func passwordSecureKey(){
        password.isSecureTextEntry = password.isSecureTextEntry ? false : true
    }
    
    @objc private func LoadMore(){
        if !checkUserPass(){
            let activity = UIAlertController(title: nil, message: "Email/Password is either empty or does not meet the requirement!", preferredStyle: .alert)
            activity.addAction(UIAlertAction(title: "Done", style: .cancel, handler: nil))
            self.present(activity, animated: true, completion: nil)
            return
        }

        let regist = Registeration(client: client, address: address)
        regist.delegate = self
        regist.createUser()
    }
    
    private func checkUserPass()->Bool{
        guard let username = username.text, let password = password.text else {return false}
        client.username = username.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        client.password = password.trimmingCharacters(in: .whitespacesAndNewlines)
        return Validation().validateformtextFields(fields: .username, client: client, address: nil)
            && Validation().validateformtextFields(fields: .password, client: client, address: nil)
    }
    
    
    @objc func RegisterInformation(){
        
        guard
            ValidateTextField.isTextEmpty(registerationForm.fullname),
            ValidateTextField.isTextEmpty(registerationForm.phoneNumber),
            ValidateTextField.isTextEmpty(registerationForm.addresslineone),
            ValidateTextField.isTextEmpty(registerationForm.city),
            ValidateTextField.isTextEmpty(registerationForm.state),
            ValidateTextField.isTextEmpty(registerationForm.zipcode),

            ValidateTextField.isValidInput(registerationForm.fullname, 2, "Name is too short!"),
            ValidateTextField.isValidInput(registerationForm.phoneNumber, 10, "Phone number is too short!"),
            ValidateTextField.isValidInput(registerationForm.addresslineone, 5, "Address is too short!"),
            ValidateTextField.isValidInput(registerationForm.city, 2, "City name is too short!"),
            ValidateTextField.isValidInput(registerationForm.zipcode, 5, "Zipcode is too short!")
        else{return}
        
        guard let fullname = registerationForm.fullname.text,
              let phonenumber = registerationForm.phoneNumber.text,
              let addressline1 = registerationForm.addresslineone.text,
              let addressline2 = registerationForm.addresslinetwo.text,
              let city = registerationForm.city.text,
              let state = registerationForm.state.text,
              let zipcode = registerationForm.zipcode.text
        else{return}
        
        client.fullname = fullname.trimmingCharacters(in: .whitespacesAndNewlines)
        
        address.useruuid = client.uuid
        address.phoneNumber = phonenumber.trimmingCharacters(in: .whitespacesAndNewlines)
        address.addressLineOne = addressline1.trimmingCharacters(in: .whitespacesAndNewlines)
        address.addressLineTwo = addressline2.trimmingCharacters(in: .whitespacesAndNewlines)
        address.city = city.trimmingCharacters(in: .whitespacesAndNewlines)
        address.state = state.trimmingCharacters(in: .whitespacesAndNewlines)
        address.zipcode = zipcode.trimmingCharacters(in: .whitespacesAndNewlines)
        
        
        Validation().checkvalidation(client: client, address: address, parent: self) { valid in
            if valid{
                let regist = Registeration(client: self.client, address: self.address)
                regist.delegate = self
                regist.saveClient()
            }
        }
    }

}
