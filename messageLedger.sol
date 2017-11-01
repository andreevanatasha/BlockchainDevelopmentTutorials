pragma solidity ^0.4.11;

contract messageLedger {

    struct LedgerStruct {
        bytes32 message;
        address sender;
        bool set;
    }

    mapping (bytes32 => LedgerStruct) public ledgerStructs;

    bytes32[] keys;

    address public beneficiary;
    uint public submitTime;
    uint public price;

    function messageLedger(
        uint _submitTime,
        address _beneficiary,
        uint _price
    ) {
        beneficiary = _beneficiary;
        submitTime = _submitTime;
        price = _price;
    }

    function getKeyArray() constant returns (bytes32[]) {
        return keys;
    }

    function setMessage (bytes32 key, bytes32 message) payable returns (bool success) {

    //Check if a user has sent enough money, if not send the money back
    require(msg.value > price);

    //Check is this message was added to the ledger already
    if (ledgerStructs[key].set) {
        revert();
    }

    //Add the message to the ledger
    ledgerStructs[key].message = message;
    ledgerStructs[key].sender = msg.sender;
    ledgerStructs[key].set = true;
    keys.push(key);

    //Transfer money to the beneficiary
    beneficiary.transfer(msg.value);

    return true;
    }

    function getMessage (bytes32 key) public constant returns (bytes32, address) {

        //Check if it's okay to publish the message
        require(now >= submitTime);

        var message = ledgerStructs[key].message;
        var sender = ledgerStructs[key].sender;
        return (message, sender);
    }
}