pragma solidity ^0.4.21;

import "./Auction.sol";
import "./Application.sol";
import "./Post.sol";
import "./Cv.sol";
import "./ownable.sol";


contract Employers is ownable{
	mapping (address => Employer) addToEmployer;   
    mapping (address => uint[]) employerToPosts; 

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

	////create post with length of post
	function createPost(string _postContent, uint _noOfSlots, uint _duration) {
		require(addToEmployer[msg.sender].length!=0);
		uint postId = posts.length+1;
		uint[] auctionIds;	
		uint[] applicationIds;
		posts.push(Post(postId, _postContent, msg.sender, "Open",auctionIds, applicationIds,now,_duration, _noOfSlots,0,0));
		employerToPosts[msg.sender].push(postId); 
	}
	//cancel post
	function cancelPost(uint _postId) onlyOwner {
		posts[_postId-1].status = "Cancelled";
		delete postIdToAuctions[_postId];
		delete postIdToApplications[_postId];
		delete employerToPosts[msg.sender]

	}
	//modify post 
	//modify post can we store the prvious versions??? then modify is to create a new one??
	//或者不同version的modified 的post有mapping? list of postContent???
	function modifyPost(uint _postId, string _postContent,uint _noOfOffer, uint _expireTime) onlyOwner {
		require(post[_postId-1].length!=0); 
		uint expireTime;//how to calculate expireTime based on startTime?
		posts[_postId-1].postContent = _postContent;
		posts[_postId-1].expireTime = _expireTime;
		posts[_postId-1].noOfOffer = _noOfOffer;
		//what else can be modified?
	}

	//retrive postList(no cancelled) for this employer
	function retriveNotCancelledPosts() returns(Post[]) onlyOwner {
		Post[] notCancelledPosts;
		uint[] allPostIds = employerToPosts[msg.sender];//postId List
		for(i=0;i<allPostIds.length;i++){
			if(keccak256(posts[allPostIds[i]-1].status)!=keccak256("Cancelled"){
				notCancelledPosts.push(posts[allPostIds[i]-1]);
			}
		}
		return notCancelledPosts;
	}
    //how we want to close a post???

	//==============employers CRUD operation on posts end===================

	//===============employers operation on auction/application starts================

	//CV scheduled/rejected/accepted from auction
	function processAuction (uint _postId, uint _auctionId, uint _cvId, string _status) onlyOwner {
		Auction[] auctions = addToEmployer[msg.sender].postIdToAuctions[_postId];
		for (uint i = 0; i < auctions.length; i++) {
			if (i == _auctionId-1) {
				auctions[i].cvToStatus[_cvId] = _status;
			}
		}
	}

	//CV scheduled/rejected/accepted from application
	function processApplication (uint _postId, uint _applicationId, string _status) onlyOwner {
		Application[] applications = addToEmployer[msg.sender].postIdToApplications[_postId];
		for (uint i = 0; i < applications.length; i++) {
			if (i == _applicationId-1) {
				applications[i].status = _status;
			}
		}
	}
	
	//retrieve auction list for one post
	function retrieveAuctions (uint _postId) view returns(Auction[]) onlyOwner {
		require(post[_postId-1].length!=0); 
		return addToEmployer[msg.sender].postIdToAuctions[_postId];
    }

    //retrieve application list for one post
    function retrieveApplications (uint _postId) view returns(Application[]) onlyOwner {
    	require(post[_postId-1].length!=0); 
    	return addToEmployer[msg.sender].postIdToApplications[_postId];
    }
	//==============employers operation on auction/application end===================

}