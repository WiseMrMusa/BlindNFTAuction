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
        vm.startPrank(address(0x10));
        myNFT = new NFTContract("","");
        myNFT.safeMint(address(0x10),1);
        myNFT.approve(address(blindNFTAuction),1);
        vm.stopPrank();
    }

    function AuctionNFT() public {
        vm.prank(address(0x10));
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
    // function testGetHighestBidder() public {
    //     AuctionNFT();
    //     placeBid(address(0x01), 0.08 ether);
    //     placeBid(address(0x02), 0.09 ether);
    //     placeBid(address(0x03), 0.10 ether);
    //     placeBid(address(0x04), 29.9 ether);
    //     blindNFTAuction.getHighestBidder(address(myNFT),1);
    // }

    function testEndBid() public {
        AuctionNFT();
        placeBid(address(0x01), 0.08 ether);
        placeBid(address(0x02), 0.09 ether);
        placeBid(address(0x03), 0.10 ether);
        placeBid(address(0x04), 29.9 ether);
        // blindNFTAuction.getHighestBidder(address(myNFT),1);
        vm.prank(address(0x10));
        blindNFTAuction.endBid(address(myNFT),1);
    }
    function testMyBid() public {
        AuctionNFT();
        placeBid(address(0x01), 0.08 ether);
        blindNFTAuction.myBidForNFT(address(myNFT),1);
        placeBid(address(0x02), 0.09 ether);
        blindNFTAuction.myBidForNFT(address(myNFT),1);
        placeBid(address(0x03), 0.10 ether);
        blindNFTAuction.myBidForNFT(address(myNFT),1);
        placeBid(address(0x04), 29.9 ether);
        blindNFTAuction.myBidForNFT(address(myNFT),1);
        // blindNFTAuction.getHighestBidder(address(myNFT),1);
    }


    function testFailWithDrawBid() public {
        testEndBid();
        vm.prank(address(0x02));
        blindNFTAuction.withdrawBid(address(myNFT),1);
        vm.prank(address(0x02));
        blindNFTAuction.withdrawBid(address(myNFT),1);
    }

    function testWithDrawBid() public {
        testEndBid();
        vm.prank(address(0x02));
        blindNFTAuction.withdrawBid(address(myNFT),1);
        vm.prank(address(0x03));
        blindNFTAuction.withdrawBid(address(myNFT),1);
    }
}