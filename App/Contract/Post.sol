pragma solidity ^0.4.21;

contract Post{

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

	Post[] posts; //all the posts in this app
	
	//retrieve all posts for job board
	function _retrieveAllPosts () returns(Post[]) {
		return posts;
	}	
}