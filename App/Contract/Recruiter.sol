pragma solidity ^0.4.21;

import "./Aution.sol";
import "./Post.sol";
import "./Cv.sol";
import "./ownable.sol";



contract Recruiters is ownable{

    //Recruiter[] recruiters;
    mapping (address => Recruiter) addToRecruiter;   
    mapping (address => uint[]) recruiterToAuctions; //recruiter address map to auctionId
    mapping (address => uint[]) recruiterToCvs; //recruiter address map to cvId

	struct Recruiter{
		address ownerAdd;
        mapping (uint => string) postIdToStatus; //aucted, cancelled, no status
	}


    //=================ACCT management start=============================
    function _createRecruiter() internal {   
        //require(there is no existing address in database);
        require(addToRecruiter[msg.sender].length==0);
        uint[] emptyCvIds;
        uint[] emptyAuctionIds;
        mapping (uint => string) postIdToStatus;     
        addToRecruiter[msg.sender]=Recruiter(msg.sender, postIdToStatus);
        recruiterToAuctions[msg.sender] = emptyAuctionIds;
        recruiterToCvs[msg.sender]= emptyCvIds;
    }
    //===================ACCT management end============================




    //===============recruiter CRUD operation on auctions starts================
    //make sure recruiter can only make one auction for one post, or the preview auction is cancelled
    function makeAuction (string _postid, uint[] _cvIds) {
        require (keccak256(addToRecruiter[msg.sender].postIdToStatus[_postid])!=keccak256("Aucted")); 
        mapping (uint => string) cvIdToStatus;  //put all CV in this auction into the cvStatus mapping and make it "reviewing"
        for(uint i = 0; i<_cvIds.length; i++){
            cvIdToStatus[_cvIds[i]] = "Reviewing";
        }
    	recruiterToAuctions[msg.sender].push(auctions.length+1); //add auctionId to recruiter's own auction list
    	auctions.push(Aution(auctions.length+1, _postid, msg.sender,  now, _cvIds, cvIdToStatus, "Open")); //add auction to the global auctions list
    	posts[_postid].auctionIds.push(auctions.length+1); //add auction to this specific post
        addToRecruiter[msg.sender].postIdToStatus[_postid]="Auction Made";  // update post auction status
    }

    function  retrieveAllAuctions () returns(Auction[]) {  //?? Can't return Array???
        Auction[] notCancelledAuction;
        uint[] allAuctionId = recruiterToAuctions[msg.sender];
        for(uint i = 0; i< allAuctionId.length; i++){
            if(!keccak256(auctions[allAuctionId[i]].status) == keccak256("Cancelled")){
                notCancelledAuction.push(auctions[allAuction[i]])
            }
        }
        return notCancelledAuction;
    }

    //update auction cv quantity
    //yigang: i don't think it's necessary to have this function, need this function or not????????
    function deleteCvForAuction (uint _cvId, uint _auctionId) onlyOwner {   //only owner can delete
        for(uint i = 0; i<auctions[_auctionId-1].cvIds.length; i++){
            if(auctions[_auctionId-1].cvIds[i]==_cvId){
                delete auctions[_auctionId-1].cvIds[i];
                break;
            }
        }
        
    }

    function addCvForAuction (uint _cvId, uint _auctionId) onlyOwner {   //only owner can add
        auctions[_auctionId-1].cvIds.push(_cvId);
        auctions[_auctionId-1].cvIdToStatus[_cvId]= "Reviewing";
    }

    function cancelAuction (uint _auctionId) onlyOwner {
        uint memory auctedPostId = auctions[_auctionId].postId;
    	auctions[_auctionId-1].status = "Cancelled";
        delete addToRecruiter[msg.sender].postIdToStatus[auctedPostId]; //make sure to udpate postIdToStatus so recruiter can make new auction;
        for(uint i = 0; i<recruiterToAuctions[msg.sender].length; i++){
            if(recruiterToAuctions[msg.sender][i] == _auctionId){
                delete recruiterToAuctions[msg.sender][i];
                break;
            }
        }
        
    }  

    function checkCvStatusInAuction (uint _auctionId, uint _cvId)  returns(string) internal onlyOwner {  //check the cv status in one Auction
        return auctions[_auctionId-1].cvIdToStatus[_cvId];  //reviewing, scheduled for Interview, Offered, Rejected
    }
    

    //===============recruiter CRUD operation on auctions ends================




    //===============recruiter CRUD operation on cvs start================
    function _addCv (string _hashAdd)  {
        recruiterToCvs[msg.sender].push(cvs.length+1);
        cvs.push(Cv(cvs.length+1, _hashAdd,msg.sender));
    }

    function retrieveAllCvs () returns(uint[]) onlyOwner {   //retrieve all cvIds belongs to this recruiter
    	return recruiterToCvs[msg.sender];
    }

    function retrieveOneCv (String _cvId) returns(Cv) { //need to retrieve from database
    }

    //update with latest cv
    function updateCv (String _cvId, String hashAdd) returns(Cv) {  //??什么鸡巴玩意？
    }

    //remove cv id from recruiter's cv id list
	function deleteCv (uint _cvIds)  internal onlyOwner{  // deleted already still wanna return what? why Internal??
		delete recruiterToCvs[msg.sender][_cvIds-1];  //don't delete in the global cvId list otherwise cvId will mess up
	}
    //===============recruiter CRUD operation on cvs ends================
    
}