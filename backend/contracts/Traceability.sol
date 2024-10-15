pragma solidity ^0.8.0;

contract Traceability {
    struct Product {
        uint id;
        string name;
        string origin;
        string status;
        uint timestamp;
    }

    mapping(uint => Product) public products;

    function addProduct(uint _id, string memory _name, string memory _origin, string memory _status) public {
        products[_id] = Product(_id, _name, _origin, _status, block.timestamp);
    }

    function getProduct(uint _id) public view returns (string memory, string memory, string memory, uint) {
        Product memory product = products[_id];
        return (product.name, product.origin, product.status, product.timestamp);
    }
}
