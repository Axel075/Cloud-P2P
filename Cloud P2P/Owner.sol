pragma solidity 0.8.6;

contract Owner {
    address owner;

    constructor(){
        //recuperer l'addresse de la personne qui deploye le smart contract
        owner = msg.sender;
    }
    //Changer le propriétaire du smart contract
    modifier isOwner() {
        require(msg.sender == owner, "Not the owner");
        _;
    }
}