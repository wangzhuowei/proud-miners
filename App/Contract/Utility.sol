pragma solidity ^0.4.0;

contract Utility{

	struct Post {
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
	
		
	struct Auction {
		uint auctionId;
		uint postId;
		address ownerAdd; // owner can be both recruiter and job seeker
		uint postTime;//maybe not neccessary, need to track the time of which auction, using which cv
		uint[] cvIds;
		string status;  //Open, Close, Offered, Cancelled by employer, Cancelled by owner
		mapping(uint => string) cvToStatus; //need to track the status of each applied cv --Reviewing, Shortlisted, Offered by employer, Rejected by employer, Accepted by candidate, Rejected by candidate
	}

	struct Application {
		uint applicationId;
		uint postId;
		address ownerAdd; // to record job seeker
		uint postTime;//maybe not neccessary, need to track the time of which application, using which cv
		uint cvId; //job seeker's cv 
		string cvStatus;  //Reviewing, Shortlisted, Offered by employer, Rejected by employer, Accepted by candidate, Rejected by candidate
		string status;////Open, Close, Offered, Cancelled by employer, Cancelled by owner
	}

	struct Cv {
		uint  cvId;
		string hashAdd;// the hash value generate from ipfs
		address ownerAdd;
	}

	Post[] public posts; //all the posts in this app
	Auction[] public auctions; //all the auctions in this app
	Application[] public applications; //all the applications from job seekers in this app
	Cv[] public cvs; // global cv list

	//=================post functions start=============================
	function addPost(uint _postId, string _postContent, address _ownerAdd, string _status, uint[] _auctionIds, uint[] _applicationIds, uint _postTime, uint _duration, uint _noOfSlots, uint _noOfOffers, uint _noOfOffersAccepted) {
		posts.push(Post(_postId,_postContent, _ownerAdd, _status, _auctionIds, _applicationIds, _postTime, _duration, _noOfSlots, _noOfOffers, _noOfOffersAccepted ));
	}

	function countNewPostId() public returns(uint) {
		return posts.length+1;
	}

	function getPostStatus(uint _postId) public returns(string)  {
		return posts[_postId-1].status;
	}

	function changePostStatus(uint _postId, string _status) public {
		posts[_postId-1].status = _status;
	}

	function getPostContent (uint _postId) public constant returns(string) {
		return posts[_postId-1].postContent;
	}

	function addAuctionIdToOnePost(uint _postId, uint _auctionId)  {
		posts[_postId-1].auctionIds.push(_auctionId);
	}

	function addApplicationIdToOnePost(uint _postId, uint _applicationId)  {
		posts[_postId-1].applicationIds.push(_applicationId);
	}
	//=================post functions end=============================

	//=================auction functions start=============================
	function addAuction(uint _auctionId, uint _postId, address _ownerAdd, uint _postTime, uint[] _cvIds, string _status) {
		auctions.push(Auction(_auctionId, _postId, _ownerAdd, _postTime, _cvIds, _status));
	}

	function countNewAuctionId() public returns(uint) {
		return auctions.length+1;
	}

	function changeCvStatusForOneAuction(uint _auctionId, uint _cvId, string _status)  {
		auctions[_auctionId-1].cvToStatus[_cvId]= _status;
	}

	function changeAuctionStatus(uint _auctionId, string _status) {
		auctions[_auctionId-1].status =  _status;
	}

	function getAuctionStatus(uint _auctionId) public returns(string)  {
		return auctions[_auctionId-1].status;
	}

	function retrieveAuctionIds(uint _postId) public returns(uint[]) {
		//return posts[_postId-1].auctionIds;

		uint[] result = posts[_postId-1].auctionIds;
		//Only return not cancelled Ids

		for(uint i = 0; i<result.length; i++ ){
			if(keccak256(getAuctionStatus(result[i]))==keccak256("Cancelled")){

				delete result[i];
				for (uint m = i; m<result.length-1; m++){
                    result[m] = result[m+1];
                }
                delete result[result.length-1];
                result.length--;

                i--;
			}

		} 
		
		return result;


    }



    function deleteCvForAuction (uint _cvId, uint _auctionId) {      
        for(uint i = 0; i<auctions[_auctionId-1].cvIds.length; i++){
            if(auctions[_auctionId-1].cvIds[i] ==_cvId){
                delete auctions[_auctionId-1].cvIds[i];
                delete auctions[_auctionId-1].cvToStatus[_cvId];
                break;
            }
        }
    }

    function retrieveNoOfCvsForAuction(uint _auctionId) public returns(uint) {
		return auctions[_auctionId-1].cvIds.length;
    }

    function addCvToAuction (uint _cvId, uint _auctionId) {
        auctions[_auctionId-1].cvIds.push(_cvId);
        changeCvStatusForOneAuction(_auctionId, _cvId, "Reviewing");
    }

    function getPostIdForAuction (uint _auctionId) public returns(uint) {
        return auctions[_auctionId-1].postId;
    }

    function getCvStatusForAuction (uint _auctionId, uint _cvId) public constant returns(string) {
        //return: Reviewing, Shortlisted, Rejected by eployer, Offered by employer, Accepted by candidate, Rejected by candiate
        return auctions[_auctionId-1].cvToStatus[_cvId]; 
    }

	//=================auction functions end=============================	

	//=================application functions start=============================
	function addApplication(uint _applicationId, uint _postId, address _ownerAdd, uint _postTime, uint _cvId, string _cvStatus, string _status) {
		applications.push(Application(_applicationId, _postId, _ownerAdd, _postTime, _cvId, _cvStatus, _status));
	}	

	function countNewApplicationId() public returns(uint) {
		return applications.length+1;
	}

	function changeApplicationCvStatus(uint _applicationId, string _status) {
		applications[_applicationId-1].cvStatus = _status;
	}

	function changeApplicationStatus(uint _applicationId, string _status) {
		applications[_applicationId-1].status = _status;
	}

	function getApplicationStatus(uint _applicationId) public returns(string)  {
		return applications[_applicationId-1].status;
	}

	function getApplicationCvStatus(uint _applicationId) public returns(string)  {
		return applications[_applicationId-1].cvStatus;
	}

	function getPostIdForApplication (uint _applicationId) public returns(uint) {
        return applications[_applicationId-1].postId;
    }

	function retrieveApplicationIds(uint _postId) public returns(uint[]) {

	
		uint[] result = posts[_postId-1].applicationIds;
		//Only return not cancelled Ids

		for(uint i = 0; i<result.length; i++ ){
			if(keccak256(getApplicationStatus(result[i]))==keccak256("Cancelled")){

				delete result[i];
				for (uint m = i; m<result.length-1; m++){
                    result[m] = result[m+1];
                }
                delete result[result.length-1];
                result.length--;

                i--;
			}

		} 
		
		return result;
    }


	//=================application functions end=============================


	//=================cv functions start=============================
	function countNewCvId() public returns(uint) {
		return cvs.length+1;
	}

	function addCv (uint _cvId,string _hashAdd,address _ownerAdd) {
		cvs.push(Cv(_cvId,_hashAdd,_ownerAdd));
	}

	function getCvHashAdd(uint _cvId) public returns(string) {
		return cvs[_cvId-1].hashAdd;
	}

	//=================cv functions end=============================

	//================= complex functions =============================
	function cancelPost(uint _postId) {
		require(keccak256(getPostStatus(_postId)) == keccak256("Open"));
		changePostStatus(_postId, "Cancelled");
		//change the status of related auctions (not cancelled auctions) to Cancelled by employer
		uint[] auctionIdsToCancel = posts[_postId-1].auctionIds;
		for(uint c = 0; c < auctionIdsToCancel.length; c++) {
			if(keccak256(getAuctionStatus(auctionIdsToCancel[c]))!=keccak256("Cancelled by owner")){
				changeAuctionStatus(auctionIdsToCancel[c],"Cancelled by employer");
			}
		}
		//change the status of related applications (not cancelled applications) to Cancelled by employer
		uint[] applicationIdsToCancel = posts[_postId-1].applicationIds;
		for(uint d = 0; d < applicationIdsToCancel.length; d++) {
			if(keccak256(getApplicationStatus(applicationIdsToCancel[d]))!=keccak256("Cancelled by owner")){
				changeApplicationStatus(applicationIdsToCancel[d],"Cancelled by employer");
			}
		}
	}

	function closePost(uint _postId) {
		require(keccak256(getPostStatus(_postId)) == keccak256("Open"));
		changePostStatus(_postId, "Close");
		//change the status of related auctions (not cancelled auctions) to Close
		uint[] auctionIdsToClose = posts[_postId-1].auctionIds;
		for(uint a = 0; a < auctionIdsToClose.length; a++) {
			if(keccak256(getAuctionStatus(auctionIdsToClose[a]))!=keccak256("Cancelled by owner")){
				changeAuctionStatus(auctionIdsToClose[a],"Close");
			}
		}
		//change the status of related applications (not cancelled applications) to Close
		uint[] applicationIdsToClose = posts[_postId-1].applicationIds;
		for(uint b = 0; b < applicationIdsToClose.length; b++) {
			if(keccak256(getApplicationStatus(applicationIdsToClose[b]))!=keccak256("Cancelled by owner")){
				changeApplicationStatus(applicationIdsToClose[b],"Close");
			}
		}
	}

	function processAuctionOffer (string _status, uint _cvId, uint _auctionId) {
        changeCvStatusForOneAuction(_auctionId,_cvId,_status);
        if(keccak256(_status) == keccak256("Accepted by candidate")){
            posts[getPostIdForAuction(_auctionId)-1].noOfOffersAccepted++;
        }
    }

    function processApplicationOfferByJobSeeker (string _status,uint _applicationId) {
    	changeApplicationCvStatus(_applicationId,_status);
        if(keccak256(_status) == keccak256("Accepted by candidate")){
            posts[getPostIdForApplication(_applicationId)-1].noOfOffersAccepted ++;
        }
    }
}