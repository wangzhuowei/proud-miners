pragma solidity ^0.4.0;

import "./Utility.sol";

contract JobSeeker {

    mapping (address => JobSeeker) public addToJobSeeker;
    mapping (address => uint[]) public jobSeekerToAuctions; //job seekers address map to auctionId
    mapping (address => uint[]) public jobSeekerToApplications; //job seekers address map to applicationId
    mapping (address => uint[]) public jobSeekerToCvs; //jobSeeker address map to cvId
    
    address utilityAdd;

    struct JobSeeker{
        address ownerAdd;
        uint checker;
        mapping (uint => string)  postIdToAuctionStatus; //String staus: Aucted, Cancelled, ""(by default)
        mapping (uint => string)  postIdToApplicationStatus; //String status: Appied, Cancelled, ""(by default)
    }


    //=================ACCT management start=============================
    function createJobSeeker (address _utilityAdd) {   
        require(addToJobSeeker[msg.sender].checker!=8);
        //initialize attributes
        uint[]  emptyCvIds;
        uint[]  emptyAuctionIds;
        uint[]  emptyApplicationIds;
        
        addToJobSeeker[msg.sender] = JobSeeker(msg.sender,8);
        jobSeekerToAuctions[msg.sender] = emptyAuctionIds;
        jobSeekerToApplications[msg.sender] = emptyAuctionIds;
        jobSeekerToCvs[msg.sender]= emptyCvIds;

        utilityAdd=_utilityAdd;
    }
    //===================ACCT management end============================

    //===============job seeker CRUD operation on auctions starts================
    function makeAuction (uint _postid, uint[] _cvIds) {
        require (keccak256(addToJobSeeker[msg.sender].postIdToAuctionStatus[_postid]) != keccak256("Aucted"));
        require (keccak256(Utility(utilityAdd).getPostStatus(_postid))==keccak256("Open"));

        uint newAuctionId = Utility(utilityAdd).countNewAuctionId();
        Utility(utilityAdd).addAuction(newAuctionId, _postid, msg.sender, now, _cvIds, "Open");
        
        for(uint i = 0; i<_cvIds.length; i++){
            Utility(utilityAdd).changeCvStatusForOneAuction(newAuctionId, _cvIds[i], "Reviewing");
            //Utility.getAuctions()[Utility.getAuctions().length-1].cvToStatus[_cvIds[i]] = "Reviewing";
        }
        
        Utility(utilityAdd).addAuctionIdToOnePost(_postid, newAuctionId );
        //Utility.getPosts()[_postid-1].auctionIds.push(Utility.getAuctions().length+1);
        jobSeekerToAuctions[msg.sender].push(newAuctionId);
        addToJobSeeker[msg.sender].postIdToAuctionStatus[_postid]="Aucted";
    }

    function retrieveAllAuctions () public constant returns(uint[]) {
     /*   uint[] notCancelledAuctions;
        uint[] memory allAuctionId = jobSeekerToAuctions[msg.sender];
        for(uint j = 0; j< allAuctionId.length; j++){
            if(keccak256(Utility(utilityAdd).getAuctionStatus(allAuctionId[j])) != keccak256("Cancelled")){
                notCancelledAuctions.push(allAuctionId[j]);
            }
        }   */
        return jobSeekerToAuctions[msg.sender];
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
        delete addToJobSeeker[msg.sender].postIdToAuctionStatus[auctedPostId];
        for(uint i = 0; i<jobSeekerToAuctions[msg.sender].length; i++){
            if(jobSeekerToAuctions[msg.sender][i] == _auctionId){
                delete jobSeekerToAuctions[msg.sender][i];

                for (uint m = i; m<jobSeekerToAuctions[msg.sender].length-1; m++){
                    jobSeekerToAuctions[msg.sender][m] = jobSeekerToAuctions[msg.sender][m+1];
                }
                delete jobSeekerToAuctions[msg.sender][jobSeekerToAuctions[msg.sender].length-1];
                jobSeekerToAuctions[msg.sender].length--;
            

                break;
            }
        }
    }

    function checkCvStatusInAuction (uint _auctionId, uint _cvId) public constant returns(string) {
        //return: Reviewing, Shortlisted, Rejected by eployer, Offered by employer, Accepted by candidate, Rejected by candiate
        return Utility(utilityAdd).getCvStatusForAuction(_auctionId,_cvId);
    }

    function processAuctionOfferFromJobSeeker (string _status, uint _cvId, uint _auctionId) {
        Utility(utilityAdd).processAuctionOffer(_status,_cvId,_auctionId);
    }

    function getAuctedPost (uint _auctionId) public constant returns(string) {
        return Utility(utilityAdd).getPostContent(Utility(utilityAdd).getPostIdForAuction(_auctionId));
    }

    //===============job seeker CRUD operation on auctions ends===========

    function getPostStatus (uint _postId) public constant returns(string) {
        return Utility(utilityAdd).getPostStatus(_postId);
    }

    //===============job seeker CRUD on application starts================
   
    function getAppliedPost (uint _applicationId) public constant returns(string) {
        return Utility(utilityAdd).getPostContent(Utility(utilityAdd).getPostIdForApplication(_applicationId));
    }

    function makeApplication (uint _postid, uint _cvId) {
        require (keccak256(addToJobSeeker[msg.sender].postIdToApplicationStatus[_postid]) != keccak256("Applied"));
        require (keccak256(Utility(utilityAdd).getPostStatus(_postid))==keccak256("Open"));

        uint newApplicationId = Utility(utilityAdd).countNewApplicationId();

        Utility(utilityAdd).addApplication(newApplicationId, _postid, msg.sender,  now, _cvId, "Reviewing","Open");
        jobSeekerToApplications[msg.sender].push(newApplicationId);
        //posts[_postid-2].applicationIds.push(applications.length+1);
        Utility(utilityAdd).addApplicationIdToOnePost(_postid, newApplicationId );
        addToJobSeeker[msg.sender].postIdToApplicationStatus[_postid]="Applied";
    }

/*
    function getPost (uint _postId) public constant returns(string) {
        return Utility(utilityAdd).getPostContent(_postId);
    }   */

    function retrieveAllApplications () public constant returns(uint[]) {
        //not Cancelled Application ids
      /*  uint[] allApplicationId = jobSeekerToApplications[msg.sender];
       for(uint i = 0; i< allApplicationId.length; i++){
            if(keccak256(Utility(utilityAdd).getApplicationStatus(allApplicationId[i])) == keccak256("Cancelled")){
                delete jobSeekerToApplications[msg.sender][i];

                for (uint m = i; m<jobSeekerToApplications[msg.sender].length-1; m++){
                    jobSeekerToApplications[msg.sender][m] = jobSeekerToApplications[msg.sender][m+1];
                }
                delete jobSeekerToApplications[msg.sender][jobSeekerToApplications[msg.sender].length-1];
                jobSeekerToApplications[msg.sender].length--;
            }
        }  */
        return jobSeekerToApplications[msg.sender];
    }

    function cancelApplication (uint _applicationId) {
        uint appiedPostId = Utility(utilityAdd).getPostIdForApplication(_applicationId);
        Utility(utilityAdd).changeApplicationStatus(_applicationId,"Cancelled");
        delete addToJobSeeker[msg.sender].postIdToApplicationStatus[appiedPostId];
        for(uint i = 0; i<jobSeekerToApplications[msg.sender].length; i++){
            if(jobSeekerToApplications[msg.sender][i] == _applicationId){
                delete jobSeekerToApplications[msg.sender][i];

                for (uint m = i; m<jobSeekerToApplications[msg.sender].length-1; m++){
                    jobSeekerToApplications[msg.sender][m] = jobSeekerToApplications[msg.sender][m+1];
                }
                delete jobSeekerToApplications[msg.sender][jobSeekerToApplications[msg.sender].length-1];
                jobSeekerToApplications[msg.sender].length--;
                break;
            }
        }        
    }

    function getOneApplicationStatus (uint _applicationId) public constant returns(string){
        return Utility(utilityAdd).getApplicationStatus(_applicationId);
    }
    

    function checkCvStatusInApplication (uint _applicationId)  public constant returns(string) {
        // return: Reviewing, Shortlisted, Rejected by eployer, Offered by employer, Accepted by candidate, Rejected by candiate
        return Utility(utilityAdd).getApplicationCvStatus(_applicationId);
    }

    function processApplicationOfferFromJobSeeker (string _status,uint _applicationId) {
        Utility(utilityAdd).processApplicationOfferByJobSeeker(_status,_applicationId);
    }
    //===============job seeker CRUD operation on applications ends========

    //===============job seeker CRUD operation on cvs start================
    
    function addCv (string _hashAdd) {
        uint newCvId = Utility(utilityAdd).countNewCvId();
        //update jobSeekerToCvs
        jobSeekerToCvs[msg.sender].push(newCvId);
        //update cvs in cv contract
        Utility(utilityAdd).addCv(newCvId,_hashAdd,msg.sender);
    }
    
    function getCv (uint _cvId) public constant returns(string){
        uint[] allCvIds = jobSeekerToCvs[msg.sender];
        uint deleted = 1;
        for(uint i = 0; i<allCvIds.length; i++){
            if(allCvIds[i]==_cvId){
                deleted--;
            }
        }
        if(deleted==0){
            return Utility(utilityAdd).getCvHashAdd(_cvId);
        }else{
            return "The CV you are looking for is deleted";
        }
        
    }

    function retrieveAllCvs () public constant returns(uint[]) {
        return jobSeekerToCvs[msg.sender];
    }

    function deleteCv (uint _cvId){  
        for(uint i = 0; i<jobSeekerToCvs[msg.sender].length; i++){
            if(jobSeekerToCvs[msg.sender][i]==_cvId){
               delete jobSeekerToCvs[msg.sender][i];

               for (uint m = i; m<jobSeekerToCvs[msg.sender].length-1; m++){
                    jobSeekerToCvs[msg.sender][m] = jobSeekerToCvs[msg.sender][m+1];
                }
                delete jobSeekerToCvs[msg.sender][jobSeekerToCvs[msg.sender].length-1];
                jobSeekerToCvs[msg.sender].length--;

               break;
            }
        }
    }
    //===============job seeker CRUD operation on cvs ends================
}