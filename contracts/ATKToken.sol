contract ATKToken is StandardToken {
    string public constant name = "AlphaToken";
    string public constant symbol = "ATK";
    uint256 public constant decimals = 18;

    uint256 public constant TokenCreationCap = 4000 * (10**6) * 10**decimals;   
    uint256 public constant ICOTokenCreationCap = 1160 * (10**6) * 10**decimals;   

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
        if (passedWeeks > 5) revert();

        uint256 tokens = msg.value.mul(getExchangeRate(passedWeeks));
        if (TokenCreationCap.sub(balances[reserveFundDeposit]) >  ICOTokenCreationCap.sub(tokens)) revert(); 

        balances[reserveFundDeposit] = balances[reserveFundDeposit].sub(tokens);
        balances[msg.sender] = balances[msg.sender].add(tokens);
    }

    function collectEther() external {
        if (msg.sender != ethFundDeposit) revert(); 
        if (!ethFundDeposit.send(this.balance)) revert();  
    }

    function getExchangeRate(uint256 passedWeeks) internal constant returns (uint256) {
        if (passedWeeks < 1) {
            return 10267; 
        }   

        if (passedWeeks < 2) {
            return 8800; 
        }   

        return  7700;
    }

    function getPassedWeeks() internal constant returns (uint256) {
        return (now - startTime) / 1 weeks;
    }
}
