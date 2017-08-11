contract ATKToken is StandardToken {
    string public constant name = "AlphaToken";
    string public constant symbol = "ATK";
    uint256 public constant decimals = 18;

    uint256 public constant TokenCreationCap = 8000 * (10**6) * 10**decimals;   
    uint256 public constant ICOTokenCreationCap = 2320 * (10**6) * 10**decimals;   

    uint256 public startTime;
    uint256 public icoCreatedToken;
    address public reserveFundDeposit;
    address public ethFundDeposit;

    function ATKToken(address _ethFundDeposit, address _reserveFundDeposit) {
        totalSupply = TokenCreationCap;
        startTime = now;
        ethFundDeposit = _ethFundDeposit;
        reserveFundDeposit = _reserveFundDeposit;
        balances[reserveFundDeposit] = TokenCreationCap;
    }

    function createTokens() payable external {
        if (msg.value == 0) revert();

        uint256 passedWeeks = getPassedWeeks();
        if (passedWeeks > 4) revert();

        uint256 tokens = msg.value.mul(getExchangeRate(passedWeeks));
        if (TokenCreationCap.sub(balances[reserveFundDeposit]) >  ICOTokenCreationCap.add(tokens)) revert(); 

        balances[reserveFundDeposit] = balances[reserveFundDeposit].sub(tokens);
        balances[msg.sender] = balances[msg.sender].add(tokens);
    }

    function collectEther() external {
        if (msg.sender != ethFundDeposit) revert(); 
        if (!ethFundDeposit.send(this.balance)) revert();  
    }

    function getExchangeRate(uint256 passedWeeks) internal constant returns (uint256) {
        if (passedWeeks < 1) {
            return 4000; 
        } 

        if (passedWeeks < 2) {
            return 3000; 
        }

        if (passedWeeks < 3) {
            return 2000; 
        }

        return  1000;
    }

    function getPassedWeeks() internal constant returns (uint256) {
        return (now - startTime) / 1 weeks;
    }
}
