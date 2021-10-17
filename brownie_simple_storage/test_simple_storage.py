from brownie import accounts, SimpleStorage

def test_deploy():
    # Arrange
    myaccount = accounts[0]
    # Acting
    simple_storage = SimpleStorage.deploy({"from":myaccount})
    start_value = simple_storage.get()
    expected = 0
    # Asserting
    assert start_value == expected

def test_updating_storage():
    # Arrange
    myaccount = accounts[0]
    simple_storage = SimpleStorage.deploy({"from":myaccount})
    # Acting
    expected = 15
    simple_storage.store(expected,{"from":myaccount})
    # Asserting
    assert expected == simple_storage.get()

