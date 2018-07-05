pragma solidity ^0.4.21;

contract Auction{
	
	struct Auction {
		uint auctionId;
		uint postId;
		address ownerAdd; // owner can be both recruiter and job seeker
		uint postTime;//maybe not neccessary, need to track the time of which auction, using which cv
		uint[] cvIds;
		mapping(uint => string) cvToStatus; //need to track the status of each applied cv --Reviewing, Shortlisted, Offered by employer, Rejected by employer, Accepted by candidate, Rejected by candidate
		string status;  //Open, Close, Offered, Cancelled
	}

	Auction[] auctions; //all the auctions in this app
	
}


