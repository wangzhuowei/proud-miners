pragma solidity ^0.4.21;

import "./Auction.sol";
import "./Post.sol";
import "./Cv.sol";



contract Recruiters {

    //Recruiter[] recruiters;
    mapping (address => Recruiter) addToRecruiter;   
    mapping (address => uint[]) recruiterToAuctions; //recruiter address map to auctionId
    mapping (address => uint[]) recruiterToCvs; //recruiter address map to cvId

	struct Recruiter{
		address ownerAdd;
        mapping (uint => string) postIdToStatus; //aucted, cancelled, no status
	}


    //=================ACCT management start=============================
    function _createRecruiter() {   
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
        require (keccak256(posts[_postid-1].status)==keccak256("Open"));
        mapping (uint => string) cvIdToStatus;  //put all CV in this auction into the cvStatus mapping and make it "reviewing"
        for(uint i = 0; i<_cvIds.length; i++){
            cvIdToStatus[_cvIds[i]] = "Reviewing";
        }
    	recruiterToAuctions[msg.sender].push(auctions.length+1); //add auctionId to recruiter's own auction list
    	auctions.push(Auction(auctions.length+1, _postid, msg.sender,  now, _cvIds, cvIdToStatus, "Open")); //add auction to the global auctions list
    	posts[_postid-1].auctionIds.push(auctions.length+1); //add auction to this specific post
        addToRecruiter[msg.sender].postIdToStatus[_postid]="Aucted";  // update post auction status
    }

    function  retrieveAllAuctions () returns(Auction[]) {  
        Auction[] notCancelledAuction;
        uint[] allAuctionId = recruiterToAuctions[msg.sender];
        for(uint i = 0; i< allAuctionId.length; i++){
            if(!keccak256(auctions[allAuctionId[i]-1].status) == keccak256("Cancelled")){
                notCancelledAuction.push(auctions[allAuctionId[i]-1]);
            }
        }
        return notCancelledAuction;
    }

    //update auction cv quantity
    //yigang: i don't think it's necessary to have this function, need this function or not????????
    function deleteCvForAuction (uint _cvId, uint _auctionId) {   //only owner can delete
        for(uint i = 0; i<auctions[_auctionId-1].cvIds.length; i++){
            if(auctions[_auctionId-1].cvIds[i]==_cvId){
                delete auctions[_auctionId-1].cvIds[i];
                delete auctions[_auctionId-1].cvIdToStatus[_cvId];
                if(auctions[_auctionId-1].cvIds.length == 0 ){
                    cancelAuction(_auctionId);
                }
                break; 
            }
        }
        
    }

    function addCvForAuction (uint _cvId, uint _auctionId) {   //only owner can add
        auctions[_auctionId-1].cvIds.push(_cvId);
        auctions[_auctionId-1].cvIdToStatus[_cvId]= "Reviewing";
    }

    function cancelAuction (uint _auctionId) {
        uint memory auctedPostId = auctions[_auctionId-1].postId;
    	auctions[_auctionId-1].status = "Cancelled";
        delete addToRecruiter[msg.sender].postIdToStatus[auctedPostId]; //make sure to udpate postIdToStatus so recruiter can make new auction;
        for(uint i = 0; i<recruiterToAuctions[msg.sender].length; i++){
            if(recruiterToAuctions[msg.sender][i] == _auctionId){
                delete recruiterToAuctions[msg.sender][i];
                break;
            }
        }
    }  

    function checkCvStatusInAuction (uint _auctionId, uint _cvId)  returns(string) {  //check the cv status in one Auction
        return auctions[_auctionId-1].cvIdToStatus[_cvId];  //reviewing, scheduled for Interview, Offered, Rejected
    }
    

    function processOfferFromEmployer (string _status, uint _cvId, uint _auctionId)  {
        auctions[_auctionId-1].cvIdToStatus[_cvId] = _status;
        if(keccak256(_status) == keccak256("Accepted by candidate")){
            uint postId = auctions[_auctionId-1].postId;
            posts[postId-1].noOfOffersAccepted ++;
        }
    }
    

    //===============recruiter CRUD operation on auctions ends================




    //===============recruiter CRUD operation on cvs start================
    function _addCv (string _hashAdd)  {
        recruiterToCvs[msg.sender].push(cvs.length+1);
        cvs.push(Cv(cvs.length+1, _hashAdd,msg.sender));
    }

    function retrieveAllCvs () returns(uint[]) {   //retrieve all cvIds belongs to this recruiter
        return recruiterToCvs[msg.sender];
    }

    function retrieveOneCv (uint _cvId) returns(string) { //need to retrieve from database
        return Cv.cvs[_cvId]._hashAdd;
    }
    
    //remove cv id from recruiter's cv id list
	function deleteCv (uint _cvId){  
        for(uint i = 0; i<recruiterToCvs[msg.sender].length; i++){
            if(recruiterToCvs[msg.sender][i]==_cvId){
               delete recruiterToCvs[msg.sender][i];
               break;
            }
        }
	}
    //===============recruiter CRUD operation on cvs ends================
    
}