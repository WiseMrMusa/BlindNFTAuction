// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.18;

import "../lib/openzeppelin-contracts/contracts/token/ERC721/IERC721.sol";
import "../lib/openzeppelin-contracts/contracts/token/ERC721/ERC721.sol";


/// @title NFT Blind Auction
/// @author Musa AbdulKareem (@WiseMrMusa)
/// @notice This contract allows people to list their NFT for blind auction
contract BlindNFTAuction is ERC721("","") {

    event AuctionStarted(address indexed nftOwner, address nftContractAddress, uint256 tokenID, uint256 period);
    event BidforNFT(address);
    event WithdrawBidNFT(address);

    struct NFTAuction {
        address payable nftOwner;

        uint256 auctionStartTime;
        uint256 auctionEndTime;

        address[] bidders;
    }

    struct Bid {
        address payable bidder;
        uint256 bid;
    }

    /// @notice This holds each NFT's details
    mapping (address => mapping(uint256 => NFTAuction)) public nftAuctionDetails;
    mapping (address => mapping(uint256 => mapping(address => Bid))) private bidInformation;
    mapping (address => mapping(uint256 => address[])) private nftBidders;
    
    /// @notice This holds the contract addresses NFTs are auctioned
    address[] public nftContractAddress;

    /// @notice This holds the list of tokenIDs in each stored NFT Collection
    mapping (address => uint256[]) public tokenIDperAddress;

    function AuctionNFT(address _nftContractAddress, uint256 _nftTokenID, uint256 _auctionPeriod) public {
        nftContractAddress.push(_nftContractAddress);
        tokenIDperAddress[_nftContractAddress].push(_nftTokenID);
        NFTAuction storage myNftAuction = nftAuctionDetails[_nftContractAddress][_nftTokenID];
        myNftAuction.nftOwner = payable(msg.sender);
        myNftAuction.auctionStartTime = block.timestamp;
        myNftAuction.auctionEndTime = block.timestamp + _auctionPeriod;
        IERC721(_nftContractAddress).transferFrom(msg.sender,address(this),_nftTokenID);
        emit AuctionStarted(msg.sender, _nftContractAddress, _nftTokenID, _auctionPeriod);
    }

    function placeBid(address _nftContractAddress, uint256 _nftTokenID) public payable {
        NFTAuction storage bidNFT = nftAuctionDetails[_nftContractAddress][_nftTokenID];
        require(bidNFT.nftOwner != address(0), "This NFT is not for auction");
        require(bidNFT.auctionEndTime > block.timestamp, "The auction has ended");
        bidNFT.bidders.push(payable(msg.sender));
        Bid storage myBid = bidInformation[_nftContractAddress][_nftTokenID][msg.sender];
        nftBidders[_nftContractAddress][_nftTokenID].push(msg.sender);
        myBid.bidder = payable(msg.sender);
        myBid.bid += msg.value;
        emit BidforNFT(msg.sender);
    }
    function withdrawBid(address _nftContractAddress, uint256 _nftTokenID) public {
        NFTAuction storage bidNFT = nftAuctionDetails[_nftContractAddress][_nftTokenID];
        require(bidNFT.nftOwner != address(0), "This NFT is not for auction");
        bidNFT.bidders.push(payable(msg.sender));
        Bid storage myBid = bidInformation[_nftContractAddress][_nftTokenID][msg.sender];
        require(myBid.bidder == payable(msg.sender), "Only bidder can withdraw!");
        (payable(msg.sender)).transfer(myBid.bid);
        emit WithdrawBidNFT(msg.sender);
    }

    // This will be changed to internal later
    function getHighestBidder(address _nftContractAddress, uint256 _nftTokenID) public view returns (Bid memory) {
        Bid memory agbaBidder;
        uint256 nftBiddersLength = nftBidders[_nftContractAddress][_nftTokenID].length;
        address[] memory nftBiddders = nftBidders[_nftContractAddress][_nftTokenID];
        for (uint256 i; i < nftBiddersLength; i++){
            Bid memory Bidder =  bidInformation[_nftContractAddress][_nftTokenID][nftBiddders[i]];
                if(Bidder.bid > agbaBidder.bid){
                    agbaBidder = Bidder;
                }
                    // agbaBidder = Bidder;
        }
        return agbaBidder;
    }

    function endBid(address _nftContractAddress, uint256 _nftTokenID) public {
        require(msg.sender == nftAuctionDetails[_nftContractAddress][_nftTokenID].nftOwner, "Only owner can end bid");
        Bid memory winner = getHighestBidder(_nftContractAddress,_nftTokenID);
        IERC721(_nftContractAddress).transferFrom(address(this),winner.bidder,_nftTokenID);
    }

}
