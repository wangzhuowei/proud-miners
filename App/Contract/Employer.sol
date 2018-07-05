pragma solidity ^0.4.21;

import "./Auction.sol";
import "./Application.sol";
import "./Post.sol";
import "./Cv.sol";

contract Employers {
	mapping (address => Employer) addToEmployer;   
    mapping (address => uint[]) employerToPosts; 
    uint i;
	//strut for employer
	struct Employer{
		address ownerAdd; 
		//mapping (uint => Auction[]) postIdToAuctions;
        //mapping (uint => Application[]) postIdToApplications;  
    }

	//=================acct management start=============================
    function _createEmployer() internal {
    	require(addToEmployer[msg.sender].length==0);  
        addToEmployer[msg.sender]=Employer(msg.sender);
        uint[] emptyPostIds;
        employerToPosts[msg.sender]=emptyPostIds;
    }
	//===================acct management end============================

	//===============employers CRUD operation on posts starts================

	////create post with post content, post duration, and number of slots
	function createPost(string _postContent,  uint _duration, uint _noOfSlots) {
		uint postId = Post.posts.length+1;
		uint[] auctionIds;	
		uint[] applicationIds;
		Post.posts.push(Post(postId, _postContent, msg.sender, "Open",auctionIds, applicationIds,now,_duration, _noOfSlots,0,0));
		employerToPosts[msg.sender].push(postId); 
	}
	//cancel post
	//change the status of post in posts & delte this postid in employ's employerToPosts mapping
	function cancelPost(uint _postId) {
		Post.posts[_postId-1].status = "Cancelled";
		for(i = 0; i<employerToPosts[msg.sender].length; i++){
            if(employerToPosts[msg.sender][i] == _postId){
                delete employerToPosts[msg.sender][i];
                break;
            }
        }
	}

	//modify post 
	//modify post can we store the prvious versions??? then modify is to create a new one??
	//或者不同version的modified 的post有mapping? list of postContent???
	//不能瞎几把改posts里的东西吧，还有auctions里面的也是啊，怎么办？？？
	function modifyPost(uint _postId, string _postContent,uint _noOfOffer, uint _expireTime) {
		Post.posts[_postId-1].postContent = _postContent;
		Post.posts[_postId-1].expireTime = _expireTime;
		Post.posts[_postId-1].noOfOffer = _noOfOffer;
		//what else can be modified?
	}

	//retrive all not cancelled posts of this employer
	//retrive Post[], front-end will need post content, post time, expire time, noOfSlots, noOfOffers, noOfOffersAccepted
	function retriveAllPosts() returns(Post[]) {
		Post[] notCancelledPosts;
		uint[] allPostIds = employerToPosts[msg.sender];
		for(i = 0; i < allPostIds.length; i++){
			if(keccak256(Post.posts[allPostIds[i]-1].status) != keccak256("Cancelled")){
				notCancelledPosts.push(Post.posts[allPostIds[i]-1]);
			}
		}
		return notCancelledPosts;
	}

    //how we want to close a post???
	//change the status of post in posts and change the status of related auction and application to "Close"
	function closePostByOwner(uint _postId) {
		Post.posts[_postId-1].status = "Close";
		//close related auctions (not cancelled auctions)
		uint[] auctionIdsToClose = Post.posts[_postId-1].auctionIds;
		for(i = 0; i < auctionIdsToClose.length; i++) {
			if(keccak256(Auction.auctions[auctionIdsToClose[i]-1].status)!=keccak256("Cancelled")){
				Auction.auctions[auctionIdsToClose[i]-1].status = "Close";
			}
		}
		//close related applications (not cancelled applications)
		uint[] applicationIdsToClose = Post.posts[_postId-1].applicationIds;
		for(i = 0; i < applicationIdsToClose.length; i++) {
			if(keccak256(Application.applications[applicationIdsToClose[i]-1].status)!=keccak256("Cancelled")){
				Application.applications[applicationIdsToClose[i]-1].status = "Close";
			}
		}
	}

	//this function is running for all "Open" posts
	//function closeExpiredPost() {
		//????
	//}
	//==============employers CRUD operation on posts end===================

	//===============employers operation on auction/application starts================


	//retrieve auction list for one post
	//retrieve uint id list
	//function retrieveAuctionIds (uint _postId) returns(uint[]) onlyOwner {
	//	return posts[_postId-1].auctionIds;
    //}
    //retrieve Auction[]
	function retrieveAuctions (uint _postId) returns(Auction[]) {
		Auction[] allAuctions;
		uint[] actIds = Post.posts[_postId-1].auctionIds;
		for (i = 0; i < actIds.length; i++) {
			allAuctions.push(Auction.auctions[actIds[i]-1]);
		}
		return allAuctions;
    }

    //retrieve application list for one post
	//retrieve uint id list
    //function retrieveApplicationIds (uint _postId) returns(uint[]) onlyOwner {
	//	return posts[_postId-1].applicationIds;
    //}
    //retrieve Application[]
	function retrieveApplications (uint _postId) returns(Application[]) {
		Application[] allApplications;
		uint[] appIds = Post.posts[_postId-1].applicationIds;
		for (i = 0; i < appIds.length; i++) {
			allApplications.push(Application.applications[appIds[i]-1]);
		}
		return allApplications;
    }

	//CV scheduled/rejected/accepted from auction
	//original status is Viewing
	//_status is Shortlisted, Offered by employer, Rejected by employer
	function processAuction(uint _auctionId, uint _cvId, string _status) {
		require(keccak256(Auction.auctions[_auctionId-1].status) != keccak256("Close"));
		require(keccak256(Auction.auctions[_auctionId-1].status) != keccak256("Cancelled"));
		if(keccak256(_status) == keccak256("Offered by employer")){
			Auction.auctions[_auctionId-1].status = "Offered";
		}
		Auction.auctions[_auctionId-1].cvToStatus[_cvId] = _status; //Shortlisted, Offered by employer, Rejected by employer
	}

	//CV scheduled/rejected/accepted from application
	//original status is Viewing
	//_status is Shortlisted, Offered by employer, Rejected by employer
	function processApplication(uint _applicationId, string _status) {
		require(keccak256(Application.applications[_applicationId-1].status) == keccak256("Open"));
		if(keccak256(_status) == keccak256("Offered by employer")){
			Application.applications[_applicationId-1].status = "Offered";
		}
		Application.applications[_applicationId-1].cvStatus = _status; //Shortlisted, Offered by employer, Rejected by employer
	}
	
	//==============employers operation on auction/application end===================

}