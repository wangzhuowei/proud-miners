ragma solidity ^0.4.21;

contract Post{

	struct Post{
		uint postId;
		string postContent; 
		address owenerAdd;// post owner, use to check CRUD right
		string status;//Open, close, Cancelled---------only employer have the right to change
		uint[] auctionIds;	
		uint[] applicationIds;
		uint postTime;
		uint expireTime;  //max value available
		uint noOfOffer; // number of persons hired
	}

	Post[] posts; //all the posts in this app
	
	//retrieve all posts for job dashboard
	function _retrieveAllPosts () returns(Post[]) {
		return posts;
	}	
}