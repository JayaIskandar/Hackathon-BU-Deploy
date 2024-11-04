// SPDX-License-Identifier: MIT

pragma solidity 0.8.18;

interface ITRC20 {
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256);
    function balance(address owner) external view returns (uint256);
}

contract Marketplace {

    
    struct Listing {
        uint256 price;
        bool bought;
        uint256 uid; // unique id for every listing
        address seller;
    }
    

    Listing[] public listings;
    
    mapping(uint256 => uint256) uidToArray;
    
    error NotEnoughMoney();
    error TransactionFailed();
    
    event NewListing(uint uid);
    
    address immutable tokenUSDD;
    constructor(address _token) {
        tokenUSDD = _token;
    }
    
    //TG1kuPqiq24MrmFYfq2kWcLMZRPKQ6ZVY2
    
    function makeListing(uint256 _price, uint256 _uid, address _seller) public {
        Listing memory newListing = Listing(_price, false, _uid, _seller);
        listings.push(newListing);
        uidToArray[listings.length - 1];
    }
    
    function getListing(uint256 index) public view returns (uint256, uint256, address) {
        Listing memory listing = listings[index];
        return (listing.price, listing.uid, listing.seller);
    }
    
    function buy(uint256 amount, uint256 uid) external {
        Listing storage listing = listings[uidToArray[uid]];

        // Ensure the listing is not already bought
        require(!listing.bought, "Listing already bought");

        // Ensure the buyer is sending enough tokens
        if (amount < listing.price) {
            revert NotEnoughMoney();
        }

        // Check that the buyer has approved the contract to spend the tokens
        ITRC20 token = ITRC20(tokenUSDD);
        if (token.balance(msg.sender) > amount) {
            revert NotEnoughMoney();
        }
        
        uint256 allowance = token.allowance(msg.sender, address(this));
        require(allowance >= listing.price, "Allowance too low");
        // Transfer tokens from buyer to the seller
        bool success = token.transferFrom(msg.sender, listing.seller, listing.price);
        if (!success) {
            revert TransactionFailed();
        }

        // Mark the listing as bought
        listing.bought = true;
    }
}