pragma solidity ^0.4.0;

import "./Utility.sol";

contract Recruiter {

    mapping (address => Recruiter) public addToRecruiter;   
    mapping (address => uint[]) public recruiterToAuctions; //recruiter address map to auctionId
    mapping (address => uint[]) public recruiterToCvs; //recruiter address map to cvId

    address utilityAdd;

	struct Recruiter{
		address ownerAdd; 
        uint checker;
        mapping (uint => string) postIdToStatus; //aucted, cancelled, no status
	}

    //=================ACCT management start=============================
    function createRecruiter (address _utilityAdd) { 
        require(addToRecruiter[msg.sender].checker!=8);
        uint[] emptyCvIds;
        uint[] emptyAuctionIds;

        addToRecruiter[msg.sender]=Recruiter(msg.sender, 8);
        recruiterToAuctions[msg.sender] = emptyAuctionIds;
        recruiterToCvs[msg.sender]= emptyCvIds;

        utilityAdd=_utilityAdd;
    }
    //===================ACCT management end============================
    
        
    //===============recruiter CRUD operation on auctions starts================
    //make sure recruiter can only make one auction for one post, or the preview auction is cancelled
    function makeAuction (uint _postid, uint[] _cvIds) {
        require (keccak256(addToRecruiter[msg.sender].postIdToStatus[_postid])!=keccak256("Aucted")); 
        require (keccak256(Utility(utilityAdd).getPostStatus(_postid))==keccak256("Open"));
        
        uint newAuctionId = Utility(utilityAdd).countNewAuctionId();
        Utility(utilityAdd).addAuction(newAuctionId, _postid, msg.sender, now, _cvIds, "Open");
        Utility(utilityAdd).addAuctionIdToOnePost(_postid, newAuctionId);

    	recruiterToAuctions[msg.sender].push(newAuctionId); //add auctionId to recruiter's own auction list
        addToRecruiter[msg.sender].postIdToStatus[_postid]="Aucted";  // update post auction status

        for(uint i = 0; i<_cvIds.length; i++){
            Utility(utilityAdd).changeCvStatusForOneAuction(newAuctionId, _cvIds[i], "Reviewing");
        }
    }

    function retrieveAllAuctions () public constant returns(uint[]) {  
    /*    uint[] notCancelledAuctions;
        uint[] allAuctionId = recruiterToAuctions[msg.sender];
        for(uint i = 0; i< allAuctionId.length; i++){
            if(keccak256(Utility(utilityAdd).getAuctionStatus(allAuctionId[i])) != keccak256("Cancelled")){
                notCancelledAuctions.push(allAuctionId[i]);
            }
        }   */
        return recruiterToAuctions[msg.sender];
    }

    function deleteCvForAuction (uint _cvId, uint _auctionId) {      
        Utility(utilityAdd).deleteCvForAuction(_cvId,_auctionId);
        if(Utility(utilityAdd).retrieveNoOfCvsForAuction(_auctionId) == 0 ){
            cancelAuction(_auctionId);
        }
    }

    function addCvForAuction (uint _cvId, uint _auctionId) {
        Utility(utilityAdd).addCvToAuction(_cvId,_auctionId);
    }

    function cancelAuction (uint _auctionId) {
        uint auctedPostId = Utility(utilityAdd).getPostIdForAuction(_auctionId);
        Utility(utilityAdd).changeAuctionStatus(_auctionId,"Cancelled");
        delete addToRecruiter[msg.sender].postIdToStatus[auctedPostId]; //make sure to udpate postIdToStatus so recruiter can make new auction;
        
        for(uint i = 0; i<recruiterToAuctions[msg.sender].length; i++){
            if(recruiterToAuctions[msg.sender][i] == _auctionId){
                delete recruiterToAuctions[msg.sender][i];

                for (uint m = i; m<recruiterToAuctions[msg.sender].length-1; m++){
                    recruiterToAuctions[msg.sender][m] = recruiterToAuctions[msg.sender][m+1];
                }
                delete recruiterToAuctions[msg.sender][recruiterToAuctions[msg.sender].length-1];
                recruiterToAuctions[msg.sender].length--;
            


                break;
            }
        }
    }

    function checkCvStatusInAuction (uint _auctionId, uint _cvId)  public constant returns(string) {  //check the cv status in one Auction
        return Utility(utilityAdd).getCvStatusForAuction(_auctionId,_cvId);  //reviewing, scheduled for Interview, Offered, Rejected
    }
    

    function processOfferFromEmployer (string _status, uint _cvId, uint _auctionId)  {
        Utility(utilityAdd).processAuctionOffer(_status,_cvId,_auctionId);
    }
    

    //===============recruiter CRUD operation on auctions ends================




    //===============recruiter CRUD operation on cvs start================
    function addCv (string _hashAdd) {
        uint newCvId = Utility(utilityAdd).countNewCvId();
        //update jobSeekerToCvs
        recruiterToCvs[msg.sender].push(newCvId);
        //update cvs in cv contract
        Utility(utilityAdd).addCv(newCvId,_hashAdd,msg.sender);
    }

    function retrieveAllCvs () public constant returns(uint[]) {   //retrieve all cvIds belongs to this recruiter
        return recruiterToCvs[msg.sender];
    }

    function getCv (uint _cvId) public constant returns(string){
        return Utility(utilityAdd).getCvHashAdd(_cvId);
    }
    
    //remove cv id from recruiter's cv id list
	function deleteCv (uint _cvId){  
        for(uint i = 0; i<recruiterToCvs[msg.sender].length; i++){
            if(recruiterToCvs[msg.sender][i]==_cvId){
               delete recruiterToCvs[msg.sender][i];

               for (uint m = i; m<recruiterToCvs[msg.sender].length-1; m++){
                    recruiterToCvs[msg.sender][m] = recruiterToCvs[msg.sender][m+1];
                }
                delete recruiterToCvs[msg.sender][recruiterToCvs[msg.sender].length-1];
                recruiterToCvs[msg.sender].length--;

               break;
            }
        }
	}
    //===============recruiter CRUD operation on cvs ends================
    
}