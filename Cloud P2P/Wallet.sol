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
    //Chaque Balance a son addresse 
    mapping(address => Balance) Wallets;

    //Recuperer le nombre de token, seul le propriotaire du contrat peux l'executer
    function getBalance() public isOwner view returns(uint){
        return address(this).balance;
    }
    //Retirer tout ses tokens vers un wallet
    function withdrawAllMoney(address payable _to) public{
        //Recupere tout les token
        uint amount = Wallets[msg.sender].totalBalance;
        // Met a 0 le nombre de token du payeur
        Wallets[msg.sender].totalBalance = 0;
        //transfer le montant a l'adresse indiqué
        _to.transfer(amount);
    }
    //retirer une certaine somme de token vers un wallet
    function withdrawMoney(address payable _to, uint _amount) public{
        //Verifie que le montant qu'il retire soit inférieure ou égale a son nombre de token 
        require(_amount <= Wallets[msg.sender].totalBalance, "Not enought funds");
        //Retire sa balance en fonction du nombre de token retirer
        Wallets[msg.sender].totalBalance -= _amount;
        //transfer le montant a l'adresse indiqué
        _to.transfer(_amount);
    }
    //transfer d'argent
    receive() external payable{
        //stock en mémoire
        Payment memory thisPayment = Payment(msg.value, block.timestamp);
        //Recupere le montant envoyé 
        Wallets[msg.sender].totalBalance += msg.value;
        //Recupere l'index de paiement
        Wallets[msg.sender].payments[Wallets[msg.sender].numPayments] = thisPayment;
        //incrementer le nombre de paiement
        Wallets[msg.sender].numPayments++;
    }
}