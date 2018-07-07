pragma solidity ^0.4.0;
contract Utility{

	struct Post{
		uint postId; //postId starts from 1,2,3,4.....
		string postContent; 
		address owenerAdd;// post owner, use to check CRUD right
		string status;//Open, close, Cancelled---------only employer have the right to change
		uint[] auctionIds;	
		uint[] applicationIds;
		uint postTime;
		uint duration; //max value available
		uint noOfSlots; // number of persons hired
		uint noOfOffers;
		uint noOfOffersAccepted;
	}
	
	struct Application {
		uint applicationId;
		uint postId;
		address ownerAdd; // to record job seeker
		uint postTime;//maybe not neccessary, need to track the time of which application, using which cv
		uint cvId; //job seeker's cv 
		string cvStatus;  //Reviewing, Shortlisted, Offered by employer, Rejected by employer, Accepted by candidate, Rejected by candidate
		string status;////Open, close, offered, Cancelled
	}
	
	struct Auction {
		uint auctionId;
		uint postId;
		address ownerAdd; // owner can be both recruiter and job seeker
		uint postTime;//maybe not neccessary, need to track the time of which auction, using which cv
		uint[] cvIds;
		string status;  //Open, Close, Offered, Cancelled
		mapping(uint => string) cvToStatus; //need to track the status of each applied cv --Reviewing, Shortlisted, Offered by employer, Rejected by employer, Accepted by candidate, Rejected by candidate
	}
	
	struct Cv{
		uint  cvId;
		string hashAdd;// the hash value generate from ipfs
		address ownerAdd;
	}
	Post[] posts; //all the posts in this app
	Application[] applications; //all the applications from job seekers in this app
	Auction[] auctions; //all the auctions in this app
	Cv[] cvs; // global cv list
}