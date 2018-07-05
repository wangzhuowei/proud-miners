pragma solidity ^0.4.21;

import "./Application.sol";
import "./Auction.sol";
import "./Post.sol";
import "./Cv.sol";



contract JobSeekers{

    mapping (address => JobSeeker) addToJobSeeker;   
    mapping (address => uint[]) jobSeekerToAuctions; //job seekers address map to auctionId
    mapping (address => uint[]) jobSeekerToApplications; //job seekers address map to applicationId
    mapping (address => uint[]) jobSeekerToCvs; //jobSeeker address map to cvId
    
    struct JobSeeker{
        address ownerAdd;
        mapping (uint => string) postIdToAuctionStatus; //String staus: Aucted, Cancelled, ""(by default)
        mapping (uint => string) postIdToApplicationStatus; //String status: Appied, Cancelled, ""(by default)
    }


    //=================ACCT management start=============================
    /*function: _createJobSeeker
     *verification:
     *  1. msg.sender not in mapping addToJobSeeker 
     *Details:
     * 1. update mapping addToJobSeeker
     * 2. update mapping jobSeekerToAuctions
     * 3. update mapping jobSeekerToApplications
     * 4. update mapping jobSeekerToCvs
     *Problem:
    */
    function _createJobSeeker () {   
        require(addToJobSeeker[msg.sender].length==0);
        //initialize attributes
        uint[] emptyCvIds;
        uint[] emptyAuctionIds;
        uint[] emptyApplicationIds;
        mapping (uint => string) postIdToAuctionStatus;     
        mapping (uint => string) postIdToApplicationStatus;
        
        addToJobSeeker[msg.sender] = JobSeeker(msg.sender, postIdToAuctionStatus,postIdToApplicationStatus);
        jobSeekerToAuctions[msg.sender] = emptyAuctionIds;
        jobSeekerToApplications[msg.sender] = emptyAuctionIds;
        jobSeekerToCvs[msg.sender]= emptyCvIds;
    }
    //===================ACCT management end============================


    //===============job seeker CRUD operation on auctions starts================
    /*function: makeAuction
     *verification:
     * 1. havent aucted the selected post yet
     * 2. post status is open
     *Details:
     * 1. create struc auction
     * 2. update list auctions with new auction
     * 3. update auctionIds of selected post
     * 4. update mapping jobSeekerToAuctions
     * 5. update mapping current JobSeeker.postIdToAuctionStatus
     *Problem:
    */
    function makeAuction (string _postid, uint[] _cvIds) {
        require (keccak256(addToJobSeeker[msg.sender].postIdToAuctionStatus[_postid]) != keccak256("Aucted"));
        require (keccak256(Post.posts[_postid-1].status)==keccak256("Open"));
        
        mapping (uint => string) cvIdToStatus;
        for(uint i = 0; i<_cvIds.length; i++){
            cvIdToStatus[_cvIds[i]] = "Reviewing";
        }
        
        Auction.auctions.push(Auction(Auction.auctions.length+1, _postid, msg.sender,  now, _cvIds, cvIdToStatus, "Open"));
        Post.posts[_postid-1].auctionIds.push(Auction.auctions.length+1);
        jobSeekerToAuctions[msg.sender].push(Auction.auctions.length+1);
        addToJobSeeker[msg.sender].postIdToAuctionStatus[_postid]="Aucted";
    }

    /*function: retrieveAllAuctions
     *verification:
     *Details:
     * 1. retrieve msg.sender.(not cancelled auction list)
     *Problem: Can't return Array???(yigang)
    */
    function  retrieveAllAuctions () returns(Auction[]) {
        Auction[] notCancelledAuction;
        uint[] allAuctionId = jobSeekerToAuctions[msg.sender];
        for(uint i = 0; i< allAuctionId.length; i++){
            if(keccak256(Auction.auctions[allAuctionId[i]-1].status) != keccak256("Cancelled")){
                notCancelledAuction.push(Auction.auctions[allAuctionId[i]-1]);
            }
        }
        return notCancelledAuction;
    }

    /*function: deleteCvForAuction
     *verification:
     *Details:
     * 1. delete the cvId From auction
     * 2. update mapping cvIdToStatus
     * 3. =============== if current auction.cvIds.length == 0, Call funciton cancelAuction?
     *Problem:
    */
    function deleteCvForAuction (uint _cvId, uint _auctionId) {
        for(uint i = 0; i<Auction.auctions[_auctionId-1].cvIds.length; i++){
            if(Auction.auctions[_auctionId-1].cvIds[i]==_cvId){
                delete Auction.auctions[_auctionId-1].cvIds[i];
                delete Auction.auctions[_auctionId-1].cvIdToStatus[_cvId];
                if(Auction.auctions[_auctionId-1].cvIds.length == 0 ){
                    JobSeeker.cancelAuction(_auctionId);
                } 
                
                break;
            }
        }
    }

    /*function: addCvForAuction
     *verification:
     *Details:
     * 1. update auctions.auction.cvIds
     * 2. update auctions.auction.cvIdToStatus
     *Problem:
    */
    function addCvForAuction (uint _cvId, uint _auctionId) {
        Auction.auctions[_auctionId-1].cvIds.push(_cvId);
        Auction.auctions[_auctionId-1].cvIdToStatus[_cvId]= "Reviewing";
    }

    /*function: cancelAunction
     *verification:
     *Details:
     * 1. update auction status to Cancelled
     * 2. update struc JobSeeker.postIdToAuctionStatus
     * 3. update jobSeekerToAuctions
     * 4. ===================== remove auctionId From post.auctionIds?
     *Problem:
    */
    function cancelAunction (uint _auctionId) {
        uint auctedPostId = Auction.auctions[_auctionId-1].postId;
        Auction.auctions[_auctionId-1].status = "Cancelled";
        delete addToJobSeeker[msg.sender].postIdToAuctionStatus[auctedPostId];
        for(uint i = 0; i<jobSeekerToAuctions[msg.sender].length; i++){
            if(jobSeekerToAuctions[msg.sender][i] == _auctionId){
                delete jobSeekerToAuctions[msg.sender][i];
                break;
            }
        }
    }

    /*function: checkCvStatusInAuction
     *verification:
     *Details:
     * 1. return auctions.auction.cvIdToStatus
     *Problem:
    */
    function checkCvStatusInAuction (uint _auctionId, uint _cvId) returns(string) {
        //return: Reviewing, Shortlisted, Rejected by eployer, Offered by employer, Accepted by candidate, Rejected by candiate
        return Auction.auctions[_auctionId-1].cvIdToStatus[_cvId]; 
    }

    /*function: processAuctionOfferFromJobSeeker
     *verification:
     *Details:
     * 1. update auctions.auction.cvIdToStatus
     * 2. update posts.post.noOfOfferAccepted if accept
     *Problem:
    */
    function processAuctionOfferFromJobSeeker (string _status, uint _cvId, uint _auctionId) {
        Auction.auctions[_auctionId-1].cvIdToStatus[_cvId] = _status;
        if(keccak256(_status) == keccak256("Accepted by candidate")){
            uint postId = Auction.auctions[_auctionId-1].postId;
            Post.posts[postId-1].noOfOffersAccepted ++;
        }
    }
    //===============job seeker CRUD operation on auctions ends===========


    //===============job seeker CRUD on application starts================
    /*function: makeApplication
     *verification:
     * 1. havent applied the selected post yet
     * 2. post status is open
     *Details:
     * 1. create struc application
     * 2. update list applications with new application
     * 3. update applicationIds of selected post
     * 4. update mapping jobSeekerToApplications
     * 5. update mapping current JobSeeker.postIdToApplicationStatus
     *Problem:
    */
    function makeApplication (string _postid, uint _cvId) {
        require (keccak256(addToJobSeeker[msg.sender].postIdToApplicationStatus[_postid]) != keccak256("Applied"));
        require (keccak256(Post.posts[_postid-1].status)==keccak256("Open"));

        string cvStatus = "Reviewing";
        Application.applications.push(Application(Application.applications.length+1, _postid, msg.sender,  now, _cvId, "Reviewing", "Open")); //add auction to the global auctions list
        jobSeekerToApplications[msg.sender].push(Application.applications.length+1);
        Post.posts[_postid-1].applicationIds.push(Application.applications.length+1);
        addToJobSeeker[msg.sender].postIdToApplicationStatus[_postid]="Applied";
    }

    /*function: retrieveAllApplications
     *verification:
     *Details:
     * 1. retrieve msg.sender.(not cancelled application list)
     *Problem: Can't return Array???(yigang)
    */
    function  retrieveAllApplications () returns(Application[]) {
        Application[] notCancelledApplication;
        uint[] allApplicationId = jobSeekerToApplications[msg.sender];
        for(uint i = 0; i< allApplicationId.length; i++){
            if(keccak256(Application.applications[allApplicationId[i]-1].status) != keccak256("Cancelled")){
                notCancelledApplication.push(Application.applications[allApplicationId[i]-1]);
            }
        }
        return notCancelledApplication;
    }

    /*function: cancelApplication
     *verification:
     *Details:
     * 1. update application status to Cancelled
     * 2. update struc JobSeeker.postIdToApplicationStatus
     * 3. update jobSeekerToApplications
     * 4. ===================== remove applicationId From post.applicationIds?
     *Problem:
    */
    function cancelApplication (uint _applicationId) {
        uint appiedPostId = Application.applications[_applicationId-1].postId;
        Application.applications[_applicationId-1].status = "Cancelled";
        delete addToJobSeeker[msg.sender].postIdToApplicationStatus[appiedPostId];
        for(uint i = 0; i<jobSeekerToApplications[msg.sender].length; i++){
            if(jobSeekerToApplications[msg.sender][i] == _applicationId){
                delete jobSeekerToApplications[msg.sender][i];
                break;
            }
        }        
    }

    /*function: checkCvStatusInApplication
     *verification:
     *Details:
     * 1. return applications.application.cvStatus
     *Problem:
    */
    function checkCvStatusInApplication (uint _applicationId)  returns(string) {
        // return: Reviewing, Shortlisted, Rejected by eployer, Offered by employer, Accepted by candidate, Rejected by candiate
        return Application.applications[_applicationId-1].cvStatus;
    }

    /*function: processApplicationOfferFromJobSeeker
     *verification:
     *Details:
     * 1. update applications.application.cvStatus
     * 2. update posts.post.noOfOfferAccepted if accept
     *Problem:
    */
    function processApplicationOfferFromJobSeeker (string _status,uint _applicationId) {
        Application.applications[_applicationId-1].cvStatus = _status;
        if(keccak256(_status) == keccak256("Accepted by candidate")){
            uint postId = Application.applications[_applicationId-1].postId;
            Post.posts[postId-1].noOfOffersAccepted ++;
        }
    }
    //===============job seeker CRUD operation on applications ends========


    //===============job seeker CRUD operation on cvs start================
    /*function: _addCv
     *verification:
     *Details:
     * 1. update jobSeekerToCvs
     * 2. update cvs
     *Problem:
    */
    function _addCv (string _hashAdd)  {
        //update jobSeekerToCvs
        jobSeekerToCvs[msg.sender].push(Cv.cvs.length+1);
        //update cvs in cv contract
        Cv.cvs.push(Cv(Cv.cvs.length+1, _hashAdd,msg.sender));
    }
    
    /*function: retrieveAllCvs
     *verification:
     *Details:
     * 1. return jobSeekerToCvs
     *Problem:
    */
    function retrieveAllCvs () returns(uint[]) {
        return jobSeekerToCvs[msg.sender];
    }

    /*function: deleteCv
     *verification:
     *Details:
     * 1. update jobSeekerToCvs
     *Problem:
    */
    function deleteCv (uint _cvId) {
        uint index;
        for(uint i = 0; i<Cv.cvs.length; i++){
            if(Cv.cvs[i].cvId==_cvId){
                index= i;
            }
        }
        delete jobSeekerToCvs[msg.sender][index];
    }
    //===============job seeker CRUD operation on cvs ends================
}
