pragma solidity 0.8.6;

contract Owner {
    address owner;

    constructor(){
        //récupérer l'adresse de la personne qui a déployé le smart contract
        owner = msg.sender;
    }
    //Changer le propriétaire du smart contract
    modifier isOwner() {
        require(msg.sender == owner, "Not the owner");
        _;
    }
}
