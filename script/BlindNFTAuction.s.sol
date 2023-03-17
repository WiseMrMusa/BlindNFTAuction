// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import "../src/BlindNFTAuction.sol";
import "../test/NFTContract.sol";




contract BlindNFTAuctionTest is Script {
    BlindNFTAuction public blindNFTAuction;
    NFTContract public myNFT; 

    function setUp() public {
        blindNFTAuction = new BlindNFTAuction();
        myNFT = new NFTContract("","");
        myNFT.safeMint(address(this),1);
        myNFT.approve(address(blindNFTAuction),1);
    }

    function AuctionNFT() public {
        blindNFTAuction.AuctionNFT(address(myNFT),1,44950490459045);
    }

    function placeBid(address bidder) public {
        vm.prank(bidder);
        blindNFTAuction.placeBid{value: 0.08 ether}(address(myNFT),1);
    }





    function testAuctionNFT() public {
        AuctionNFT();
    }
    function testPlaceBid() public {
        AuctionNFT();
        placeBid(address(0xd145B112a641785E2797a18c3E693818aA7e0618));
    }
}