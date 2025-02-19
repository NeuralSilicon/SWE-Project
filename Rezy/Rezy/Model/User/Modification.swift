
import Foundation
import Firebase

protocol ModificationDelegate {
    func succeeded(value:Bool)
}

class Modification{
    
    var client:Client!
    var address:Address!
    var ref: DatabaseReference!
    var delegate:ModificationDelegate?
    var uuid:String!
    
    init(client:Client, address:Address) {
        ref = Database.database(url: .firebase).reference()
        self.client = client; self.address = address
        uuid = UserDefaults.standard.value(forKey: "uuid") as? String
    }
    
    init(client:Client) {
        ref = Database.database(url: .firebase).reference()
        self.client = client
        uuid = UserDefaults.standard.value(forKey: "uuid") as? String
    }
    
    init(){
        ref = Database.database(url: .firebase).reference()
        uuid = UserDefaults.standard.value(forKey: "uuid") as? String
    }
    
    func updateBilling(credit:CreditCard){
        checkUsername(exist: { found in
            if found{
                self.ref.child("Client").child(self.uuid).child("CreditCard").updateChildValues(credit.asPropertyList())
                self.delegate?.succeeded(value: true)
                print("found and updated")
            }else{
                self.delegate?.succeeded(value: false)
                print("did not found user")
            }
        })
    }
    
    func updatePaymentMethod(){
        client.uuid = uuid
        checkUsername(exist: { found in
            if found{
                self.ref.child("Client").child(self.uuid).child("User").updateChildValues(self.client.asPropertyList())
                self.delegate?.succeeded(value: true)
                print("found and updated")
            }else{
                self.delegate?.succeeded(value: false)
                print("did not found user")
            }
        })
    }
        
    func update(){
        client.uuid = uuid
        checkUsername(exist: { found in
            if found{
                self.ref.child("Client").child(self.uuid).child("User").updateChildValues(self.client.asPropertyList())
                self.ref.child("Client").child(self.uuid).child("Address").updateChildValues(self.address.asPropertyList())
                self.delegate?.succeeded(value: true)
                print("found and updated")
            }else{
                self.delegate?.succeeded(value: false)
                print("did not found user")
            }
        })
    }
    
    private func checkUsername(exist: @escaping (Bool) -> Void){
        ref.child("Client").observeSingleEvent(of: DataEventType.value, with: { (snapshot) in
            exist(snapshot.hasChild(self.uuid) ? true : false)
            self.ref.removeAllObservers()
        })
    }
}
