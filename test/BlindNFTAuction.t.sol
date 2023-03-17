// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/BlindNFTAuction.sol";
import "./NFTContract.sol";




contract BlindNFTAuctionTest is Test {
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

    function placeBid(address addr, uint256 bid) public {
        vm.deal(addr,100 ether);
        vm.prank(addr);
        blindNFTAuction.placeBid{value: bid}(address(myNFT),1);
    }




    function testAuctionNFT() public {
        AuctionNFT();
    }
    function testPlaceBid() public {
        AuctionNFT();
        placeBid(address(0x01), 0.08 ether);
        placeBid(address(0x02), 0.09 ether);
        placeBid(address(0x03), 0.10 ether);
        placeBid(address(0x04), 29.9 ether);
    }
    function testGetHighestBidder() public {
        AuctionNFT();
        placeBid(address(0x01), 0.08 ether);
        placeBid(address(0x02), 0.09 ether);
        placeBid(address(0x03), 0.10 ether);
        placeBid(address(0x04), 29.9 ether);
        blindNFTAuction.getHighestBidder(address(myNFT),1);
    }

    function testEndBid() public {
        AuctionNFT();
        placeBid(address(0x01), 0.08 ether);
        placeBid(address(0x02), 0.09 ether);
        placeBid(address(0x03), 0.10 ether);
        placeBid(address(0x04), 29.9 ether);
        blindNFTAuction.getHighestBidder(address(myNFT),1);
        blindNFTAuction.endBid(address(myNFT),1);
    }
    function testMyBid() public {
        AuctionNFT();
        placeBid(address(0x01), 0.08 ether);
        vm.prank(address(0x01));
        blindNFTAuction.myBidForNFT(address(myNFT),1);
        placeBid(address(0x02), 0.09 ether);
        vm.prank(address(0x01));
        blindNFTAuction.myBidForNFT(address(myNFT),1);
        placeBid(address(0x03), 0.10 ether);
        vm.prank(address(0x01));
        blindNFTAuction.myBidForNFT(address(myNFT),1);
        placeBid(address(0x04), 29.9 ether);
        vm.prank(address(0x01));
        blindNFTAuction.myBidForNFT(address(myNFT),1);
        blindNFTAuction.getHighestBidder(address(myNFT),1);
    }
}