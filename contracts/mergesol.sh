rm -rf compressed.txt
echo "pragma solidity ^0.4.11;" >> compressed.txt
cat SafeMath.sol ERC20Basic.sol ERC20.sol BasicToken.sol StandardToken.sol ATKToken.sol >> compressed.txt 
solc compressed.txt
rm -rf output && mkdir output
solc compressed.txt --bin --optimize  -o output
solc compressed.txt --abi -o output
