finalSol=CompressedATKToken.sol 
rm -rf $finalSol
echo "pragma solidity ^0.4.13;" >> $finalSol
cat SafeMath.sol ERC20Basic.sol ERC20.sol BasicToken.sol StandardToken.sol ATKToken.sol >> $finalSol
solc $finalSol
rm -rf output && mkdir output
solc $finalSol --bin --optimize  -o output
solc $finalSol --abi -o output
