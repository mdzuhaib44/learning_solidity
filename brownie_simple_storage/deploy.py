from brownie import accounts, config, SimpleStorage, network
import os

def deploy_simple_storage():
    myaccount = get_account()

    #Various ways in whcih you ccan read your hashed public key
    #myaccount = accounts.load("freecodecamp_account")
    #myaccount = accounts.add(os.getenv("PRIVATE_KEY"))
    #myaccount = accounts.add(config["wallets"]["from_key"])
   
  
    simple_storage = SimpleStorage.deploy({"from":myaccount})

    #Reading the current Favorite Number
    stored_value = simple_storage.get()
    print(stored_value)

    #Update the Favorite Number
    transaction  = simple_storage.store(44,{"from":myaccount})
    transaction.wait(1)

    updated_stored_value = simple_storage.get()
    print(updated_stored_value)


#Update the public address based on the network - development or rinkeby
def get_account():
    if(network.show_active() == "development"):
        return accounts[0]
    else:
        myaccount = accounts.add(config["wallets"]["from_key"])
        return myaccount

    
def main():
    deploy_simple_storage()
