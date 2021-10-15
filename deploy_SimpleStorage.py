#Lesson4
#The code is basically doing following items
#1. How to read a sol file and compile it
#2. How to deploy the contract to a local blockchain using Ganache
#3. How to deploy the contract TestNet(Rinkbey) using infura.io

#pragma solidity >=0.6.0 <0.9.0;

from solcx import compile_standard, install_solc
import json
from web3 import Web3

#Import the sol file containing the smart contract and read it
with open("./SimpleStorage.sol", "r") as file:
    simple_storage_file = file.read()

# Compile using Solidity
install_solc("0.8.0")
compiled_sol = compile_standard(
    {
        "language": "Solidity",
        "sources": {"SimpleStorage.sol": {"content": simple_storage_file}},
        "settings": {
            "outputSelection": {
                "*": {"*": ["abi", "metadata", "evm.bytecode", "evm.sourceMap"]}
            }
        },
    },
    solc_version="0.8.0",
)

#save the output to a file
with open("compiled_code.json", "w") as file:
    json.dump(compiled_sol, file)


# Get Bytecode
bytecode = compiled_sol["contracts"]["SimpleStorage.sol"]["SimpleStorage"]["evm"][
    "bytecode"
]["object"]

# Get abi
abi = compiled_sol["contracts"]["SimpleStorage.sol"]["SimpleStorage"]["abi"]

# We can run a local blockchain like Ganache or use https://infura.io/ to deploy in testnet(Rinkbey)
# w3 = Web3(Web3.HTTPProvider("http://127.0.0.1:7545"))
w3 = Web3(
    Web3.HTTPProvider("https://rinkeby.infura.io/v3/dd7c75ce8a7d4882bd817b625cf45746")
)
chain_id = 4
my_address = "" # your public key
private_key = "" # your private key
# We can use Environment Variables to read in the sensitive data
# private_key = os.get_env("PRIVATE_KEY")

# Create a contract in Python
SimpleStorage = w3.eth.contract(abi=abi, bytecode=bytecode)
# print(SimpleStorage)

# Get the latest tranasction
nonce = w3.eth.getTransactionCount(my_address)
# print(nonce)  # will be zero because no tranaction

# Steps to Make a transaction on the chain
# 1. Build a transaction
# 2. Sign a transaction
# 3. Send a transaction

print("Deploying the contract.")
# Step 1- Build a transaction
transaction = SimpleStorage.constructor().buildTransaction(
    {"chainId": chain_id, "from": my_address, "nonce": nonce}
)

# Step 2 - Sign a transaction
signed_txn = w3.eth.account.sign_transaction(transaction, private_key=private_key)

# Step 3 - Send a transaction
tx_hash = w3.eth.send_raw_transaction(signed_txn.rawTransaction)
tx_receipt = w3.eth.wait_for_transaction_receipt(tx_hash)
print("Contract deployed.")

# working with the contract
# contract address and abi
simple_storage = w3.eth.contract(address=tx_receipt.contractAddress, abi=abi)
# Call -> simulation of getting a value no gas fees
# Transact -> actually make a state change
# Initial value of favorite number
print(simple_storage.functions.get().call())

# Creae a transaction to store the favorite number
# nonce can only be used once for a single tranasction. We need unique value everytime.
# Step 1- Build a transaction
fav_number_store_transaction = simple_storage.functions.store(444).buildTransaction(
    {"chainId": chain_id, "from": my_address, "nonce": nonce + 1}
)
# Step 2 - Sign a transaction
signed_fav_number_store_transaction_txn = w3.eth.account.sign_transaction(
    fav_number_store_transaction, private_key=private_key
)
# Step 3 - Send a transaction
send_fav_number_store = w3.eth.send_raw_transaction(
    signed_fav_number_store_transaction_txn.rawTransaction
)
tx_receipt_fav_number_store = w3.eth.wait_for_transaction_receipt(send_fav_number_store)
# Get the stored value of favorite Number
print(simple_storage.functions.get().call())
