pragma solidity ^0.4.24;
//pragma experimental ABIEncoderV2;
import "./Utility.sol";
import "./CandidToken.sol";

contract Employer {
	mapping (address => Employer) public addToEmployer;   
    mapping (address => uint[]) public employerToPosts; 

    address utilityAdd;
    address coinContractAddress;

	//strut for employer
	struct Employer{
		address ownerAdd;
		uint checker; 
    }

	//=================acct management start=============================
    function createEmployer(address _utilityAdd,address _coinContractAddress) {
    	require(addToEmployer[msg.sender].checker != 8);  
        addToEmployer[msg.sender]=Employer(msg.sender,8);
        uint[] emptyPostIds;
        employerToPosts[msg.sender]=emptyPostIds;
        utilityAdd=_utilityAdd;
        coinContractAddress = _coinContractAddress;
    }
	//===================acct management end============================

	//===============employers CRUD operation on posts starts================

	////create post with post content, post duration, and number of slots
	function createPost(string _postContent,  uint _duration, uint _noOfSlots,address receiver, uint amount) returns (bool a){
		uint[] auctionIds;	
		uint[] applicationIds;
		uint newPostId = Utility(utilityAdd).countNewPostId();
		Utility(utilityAdd).addPost(newPostId, _postContent, msg.sender, "Open",auctionIds, applicationIds,now,_duration, _noOfSlots,0,0);
		//Utility.getPosts().push(Utility.Post((Utility.getPosts().length+1), _postContent, msg.sender, "Open",auctionIds, applicationIds,now,_duration, _noOfSlots,0,0));
		employerToPosts[msg.sender].push(newPostId);
		a=CandidToken(coinContractAddress).transfer(receiver, amount);
	}
	function getBalance(address _acc) public constant returns (uint balance){
		balance = CandidToken(coinContractAddress).balanceOf(_acc);
	}
	//cancel post
	function cancelPostByOwner(uint _postId) {
		//need to require the msg.sender is the creater of this post!
		//change the status of post in posts & auctions & applicaitons(Utility) 
		Utility(utilityAdd).cancelPost(_postId);
		//delete this postid in Employer's employerToPosts mapping
		uint[] postsId = employerToPosts[msg.sender];

		for(uint i = 0; i<postsId.length; i++){
            if(postsId[i] == _postId){
                delete postsId[i];

                for (uint m = i; m<postsId.length-1; m++){
            		postsId[m] = postsId[m+1];
        		}
        		delete postsId[postsId.length-1];
        		postsId.length--;

                break;
            }
        }
        //employerToPosts[msg.sender] = postsId; ?? need or not?
	}

	//we don't allow modifying post! employer only can cancel post or add new post 

	//retrive all not cancelled posts of this employer
	function retrieveAllNotCancelledPostIds() public constant returns(uint[]) {
		return employerToPosts[msg.sender];
	}
	//retrive all open posts of this employer
	function retrieveAllOpenPostIds() public constant returns(uint[]) {
		uint[] notCancelledPostIds1 = employerToPosts[msg.sender];
		uint[] openPostIds;
		for(uint j = 0; j < notCancelledPostIds1.length; j++){
			if (keccak256(Utility(utilityAdd).getPostStatus(notCancelledPostIds1[j])) == keccak256("Open")){
				openPostIds.push(notCancelledPostIds1[j]);
			}
		}
		return openPostIds;
	}
	//retrive all close posts of this employer
	function retrieveAllClosePostIds() public constant returns(uint[]) {
		uint[] notCancelledPostIds2 = employerToPosts[msg.sender];
		uint[] closePostIds;
		for(uint j = 0; j < notCancelledPostIds2.length; j++){
			if (keccak256(Utility(utilityAdd).getPostStatus(notCancelledPostIds2[j])) == keccak256("Close")){
				closePostIds.push(notCancelledPostIds2[j]);
			}
		}
		return closePostIds;
	}

    //close a post
	function closePostByOwner(uint _postId) {
		//change the status of post in posts & auctions & applicaitons(Utility) 
		Utility(utilityAdd).closePost(_postId);
	}

	//this function is running for all "Open" posts
	//function closeExpiredPost() {
		//usingAlarm
	//}

	//==============employers CRUD operation on posts end===================

	//===============employers operation on auction/application starts================
	function retrieveAuctions (uint _postId) public constant returns(uint[]) {
		return Utility(utilityAdd).retrieveAuctionIds(_postId);
    }

	function retrieveApplications (uint _postId) public constant returns(uint[]) {
		return Utility(utilityAdd).retrieveApplicationIds(_postId);
    }

    //test return empty Arrary
    function returnArray () public constant returns(uint[]) {
    	uint[] array;
    	return array;
    }
    

	//CV scheduled/rejected/accepted from auction
	//original status is Viewing
	//_status is Shortlisted, Offered by employer, Rejected by employer
	function processAuction(uint _auctionId, uint _cvId, string _status) {
		if(keccak256(_status) == keccak256("Offered by employer")){
			Utility(utilityAdd).changeAuctionStatus(_auctionId,"Offered");
		}
		Utility(utilityAdd).changeCvStatusForOneAuction(_auctionId,_cvId,_status); //Shortlisted, Offered by employer, Rejected by employer
	}

	//CV scheduled/rejected/accepted from application
	//original status is Viewing
	//_status is Shortlisted, Offered by employer, Rejected by employer
	function processApplication(uint _applicationId, string _status) {
		if(keccak256(_status) == keccak256("Offered by employer")){
			Utility(utilityAdd).changeApplicationStatus(_applicationId,"Offered");
		}
		Utility(utilityAdd).changeApplicationCvStatus(_applicationId,_status);//Shortlisted, Offered by employer, Rejected by employer
	}
	
	//==============employers operation on auction/application end===================

}