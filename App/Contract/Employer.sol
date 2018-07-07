pragma solidity ^0.4.0;
//pragma experimental ABIEncoderV2;
import "./Utility.sol";

contract Employer is Utility{
	mapping (address => Employer) addToEmployer;   
    mapping (address => uint[]) employerToPosts; 
    uint i;
	//strut for employer
	struct Employer{
		address ownerAdd;
		uint checker; 
    }
//=================acct management start=============================
    function createEmployer(address add) {
    	require(addToEmployer[msg.sender].checker != 8);  
        addToEmployer[msg.sender]=Employer(add,8);
        uint[] memory emptyPostIds;
        employerToPosts[msg.sender]=emptyPostIds;
    }
	//===================acct management end============================

	//===============employers CRUD operation on posts starts================

	////create post with post content, post duration, and number of slots
	function createPost(string _postContent,  uint _duration, uint _noOfSlots) {
		uint[] memory auctionIds;	
		uint[] memory applicationIds;
		posts.push(Post((posts.length+1), _postContent, msg.sender, "Open",auctionIds, applicationIds,now,_duration, _noOfSlots,0,0));
		employerToPosts[msg.sender].push(posts.length+1); 
	}
	
	//cancel post
	//change the status of post in posts & delte this postid in employ's employerToPosts mapping
	function cancelPost(uint _postId) {
		posts[_postId-1].status = "Cancelled";
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
	function modifyPost(uint _postId, string _postContent,uint _noOfOffer, uint _duration) {
	    Post memory temp = posts[_postId-1]; 
		temp.postContent = _postContent;
		temp.duration = _duration;
		temp.noOfOffers = _noOfOffer;
		//what else can be modified?
	}

	//retrive all not cancelled posts of this employer
	//retrive Post[], front-end will need post content, post time, expire time, noOfSlots, noOfOffers, noOfOffersAccepted
	function retriveAllPosts() returns(uint[]) {
		uint[] memory allPostIds = employerToPosts[msg.sender];
		for(i = 0; i < allPostIds.length; i++){
			if(keccak256(posts[allPostIds[i]-1].status) != keccak256("Cancelled")){
				delete allPostIds[i];
			}
		}
		return allPostIds;
	}

    //how we want to close a post???
	//change the status of post in posts and change the status of related auction and application to "Close"
	function closePostByOwner(uint _postId) {
		posts[_postId-1].status = "Close";
		//close related auctions (not cancelled auctions)
		uint[] auctionIdsToClose = posts[_postId-1].auctionIds;
		for(i = 0; i < auctionIdsToClose.length; i++) {
			if(keccak256(auctions[auctionIdsToClose[i]-1].status)!=keccak256("Cancelled")){
				auctions[auctionIdsToClose[i]-1].status = "Close";
			}
		}
		//close related applications (not cancelled applications)
		uint[] applicationIdsToClose = posts[_postId-1].applicationIds;
		for(i = 0; i < applicationIdsToClose.length; i++) {
			if(keccak256(applications[applicationIdsToClose[i]-1].status)!=keccak256("Cancelled")){
				applications[applicationIdsToClose[i]-1].status = "Close";
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
	function retrieveAuctions (uint _postId) returns(uint[]) {
		//uint[] allAuctions;
		return posts[_postId-1].auctionIds;
		//for (i = 0; i < actIds.length; i++) {
		//	allAuctions.push(actIds[i]);
		//}
		//return allAuctions;
    }

    //retrieve application list for one post
	//retrieve uint id list
    //function retrieveApplicationIds (uint _postId) returns(uint[]) onlyOwner {
	//	return posts[_postId-1].applicationIds;
    //}
    //retrieve Application[]
	function retrieveApplications (uint _postId) returns(uint[]) {
		//Application[] allApplications;
		return posts[_postId-1].applicationIds;
		//for (i = 0; i < appIds.length; i++) {
		//	allApplications.push(Applications.applications[appIds[i]-1]);
		//}
		//return allApplications;
    }

	//CV scheduled/rejected/accepted from auction
	//original status is Viewing
	//_status is Shortlisted, Offered by employer, Rejected by employer
	function processAuction(uint _auctionId, uint _cvId, string _status) {
		require(keccak256(auctions[_auctionId-1].status) != keccak256("Close"));
		require(keccak256(auctions[_auctionId-1].status) != keccak256("Cancelled"));
		if(keccak256(_status) == keccak256("Offered by employer")){
			auctions[_auctionId-1].status = "Offered";
		}
		auctions[_auctionId-1].cvToStatus[_cvId] = _status; //Shortlisted, Offered by employer, Rejected by employer
	}

	//CV scheduled/rejected/accepted from application
	//original status is Viewing
	//_status is Shortlisted, Offered by employer, Rejected by employer
	function processApplication(uint _applicationId, string _status) {
		require(keccak256(applications[_applicationId-1].status) == keccak256("Open"));
		if(keccak256(_status) == keccak256("Offered by employer")){
			applications[_applicationId-1].status = "Offered";
		}
		applications[_applicationId-1].cvStatus = _status; //Shortlisted, Offered by employer, Rejected by employer
	}
	
	//==============employers operation on auction/application end===================

}