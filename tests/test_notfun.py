import pytest
from brownie import (
    NotFun,
    accounts,
    reverts,
)

ZERO_ADDRESS = "0x0000000000000000000000000000000000000000"
BASE_URI = "ftp://whatever/"


@pytest.fixture
def notfun():
    return accounts[0].deploy(NotFun, BASE_URI)


def test_mocks(notfun):
    assert notfun.address is not None


def test_token_props(notfun):
    assert notfun.baseURI() == BASE_URI
    assert notfun.symbol() == "NOTFUN"
    assert notfun.name() == "Not Fun Tokens by Mike"


def test_contract_uri(notfun):
    assert notfun.contractURI() == "{}contract.json".format(BASE_URI)


def test_token_uri_fails_before_mint(notfun):
    for i in range(1, 10):
        with reverts("ERC721Metadata: URI query for nonexistent token"):
            notfun.tokenURI(i) == "{}{}.json".format(BASE_URI, i)


def test_lazy_mint(notfun):
    # Mint 10 tokens to self
    for i in range(1, 10):
        expected_uri = "{}{}.json".format(BASE_URI, i)

        with reverts("ERC721: owner query for nonexistent token"):
            notfun.ownerOf(i)

        with reverts("ERC721Metadata: URI query for nonexistent token"):
            notfun.tokenURI(i)

        tx = notfun.safeTransferFrom(accounts[0], accounts[0], i)

        assert tx.status == 1
        assert notfun.ownerOf(i) == accounts[0]
        assert notfun.tokenURI(i) == expected_uri
