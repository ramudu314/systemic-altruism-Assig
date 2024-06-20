// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract BondingCurve {
    // State variables
    // Initiating Liquidity pool

    uint256 public constant INITIAL_ETH_BALANCE = 10 ether;
    uint256 public constant INITIAL_TOKEN_BALANCE = 1000;
    uint256 public constant K = INITIAL_ETH_BALANCE * INITIAL_TOKEN_BALANCE;

    uint256 public ethBalance;
    uint256 public tokenBalance;

    // Events
    event TokensPurchased(address buyer, uint256 ethAmount, uint256 tokensBought);
    event TokensSold(address seller, uint256 ethAmount, uint256 tokensSold);

    // Constructor
    constructor() {
        ethBalance = INITIAL_ETH_BALANCE;
        tokenBalance = INITIAL_TOKEN_BALANCE;
    }

    // Function to calculate the price of tokens in terms of ETH
    function getPriceInETH() public view returns (uint256) { 
        return (ethBalance)/(tokenBalance);
    }

    

    // Function to buy tokens from the bonding curve
    function buyTokens(uint256 tokensToBuy) public payable {

        // Ensure that the buyer has sent some ETH
        require(msg.value > 0, "ETH amount must be greater than 0");
        
        require(tokensToBuy < tokenBalance, "Not enough tokens in POOL");

        uint256 price=getPriceInETH();

        uint256 amountSpend=price*tokensToBuy;
        if (msg.value > amountSpend) {
            payable(msg.sender).transfer(msg.value - amountSpend);
        }
        //Till now we bought the tokens 
        // Now we update the account

        tokenBalance-=tokensToBuy;
        ethBalance=K/(tokenBalance-tokensToBuy);
        emit TokensPurchased(msg.sender, msg.value, tokensToBuy);
        
    }
    // Function to buy tokens from the bonding curve
    function sellTokens(uint256 tokensToSell) public payable {

        require(tokensToSell <= 0, "Not enough tokens to sell");

        
        uint256 price=getPriceInETH();
        
        uint256 amountAfterSelling=price*tokensToSell;
        payable(msg.sender).transfer(amountAfterSelling);

        tokenBalance+=tokensToSell;
        ethBalance=K/(tokenBalance+tokensToSell);

           
    }
}
