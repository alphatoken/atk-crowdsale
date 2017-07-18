contract ATKToken is StandardToken {
    string public constant name = "AlphaToken";
    string public constant symbol = "ATK";
    uint256 public constant decimals = 18;

    uint256 public constant preICOFund = 800 * (10**6) * 10**decimals;   
    uint256 public constant teamFund = 2400 * (10**6) * 10**decimals;   
    uint256 public constant optionPoolFund = 1600 * (10**6) * 10**decimals;   
    uint256 public constant globalCharityFund = 1600 * (10**6) * 10**decimals;   
    uint256 public constant tokenCreationCap = 2320 * (10**6) * 10**decimals;   

    uint256 public startTime;
    bool public isFinalized;
    address public reserveFundDeposit;
    address public ethFundDeposit;

    event CreateATK(address indexed _to, uint256 _value);

    function ATKToken(address _ethFundDeposit, address _reserveFundDeposit) {
        isFinalized = false;
        startTime = now;
        ethFundDeposit = _ethFundDeposit;
        reserveFundDeposit = _reserveFundDeposit;
    }

    function createTokens() payable external {
        if (msg.value == 0) throw;

        uint256 passedWeeks = getPassedWeeks();
        if (passedWeeks > 4) throw;

        uint256 tokens = msg.value.mul(getExchangeRate(passedWeeks));
        uint256 newTotalSupply = totalSupply.add(tokens);
        if (tokenCreationCap < newTotalSupply) throw;
        totalSupply = newTotalSupply;
        balances[msg.sender] = balances[msg.sender].add(tokens);
        CreateATK(msg.sender, tokens);
    }

    function finalize() external {
        if (isFinalized) throw;
        if (msg.sender != ethFundDeposit) throw; 
        if (getPassedWeeks() < 4) throw;
        if (!ethFundDeposit.send(this.balance)) throw;  
        isFinalized = true;
        createReservedTokens();
    }

    function getExchangeRate(uint256 passedWeeks) internal returns (uint256) {
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

    function getPassedWeeks() internal returns (uint256) {
        return (now - startTime) / 1 weeks;
    }

    function createReservedTokens() internal {
        uint256 reservedToken = (tokenCreationCap - totalSupply) + teamFund + optionPoolFund + globalCharityFund + preICOFund;
        balances[reserveFundDeposit] = reservedToken;
        CreateATK(reserveFundDeposit, reservedToken);
    }
}
