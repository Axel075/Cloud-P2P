pragma solidity 0.8.6;

import './Owner.sol';

contract Wallet is Owner {
    //Paiement
    struct Payment {
        //Montant
        uint amount;
        //Signature
        uint timestamp;
    }
    //Voir son montant
    struct Balance {
        //Nombre de token dans le wallet
        uint totalBalance;
        //Combien de depot a mit sur le wallet
        uint numPayments;
        //Liste de paiement
        mapping(uint => Payment) payments;
    }
    //Chaque Balance a son adresse 
    mapping(address => Balance) Wallets;

    //Récupérer le nombre de token, seul le propriétaire du contrat peux l'exécuter
    function getBalance() public isOwner view returns(uint){
        return address(this).balance;
    }
    //Retirer tout ses tokens vers un wallet
    function withdrawAllMoney(address payable _to) public{
        //Récupère tout les token
        uint amount = Wallets[msg.sender].totalBalance;
        // Met a 0 le nombre de token du payeur
        Wallets[msg.sender].totalBalance = 0;
        //Transfert le montant a l'adresse indiquée
        _to.transfer(amount);
    }
    //retirer une certaine somme de token vers un wallet
    function withdrawMoney(address payable _to, uint _amount) public{
        //Verifie que le montant qu'il retire soit inférieure ou égale a son nombre de token 
        require(_amount <= Wallets[msg.sender].totalBalance, "Not enought funds");
        //Retire sa balance en fonction du nombre de token retirer
        Wallets[msg.sender].totalBalance -= _amount;
        //Transfert le montant a l'adresse indiquée
        _to.transfer(_amount);
    }
    //Transfert d'argent
    receive() external payable{
        //stock en mémoire
        Payment memory thisPayment = Payment(msg.value, block.timestamp);
        //Récupère le montant envoyé
        Wallets[msg.sender].totalBalance += msg.value;
        //Récupère l'index de paiement
        Wallets[msg.sender].payments[Wallets[msg.sender].numPayments] = thisPayment;
        //Incrémenter le nombre de paiements
        Wallets[msg.sender].numPayments++;
    }
}
