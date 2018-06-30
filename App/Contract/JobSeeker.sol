ragma solidity ^0.4.21;

import "./personalInfo.sol";
import "./Aution.sol";
import "./post.sol";
import "./cv.sol";
import "./ownable.sol";



contract JobSeekers{

    mapping (address => JobSeeker) addToJobSeeker;   
    mapping (address => uint[]) jobSeekerToAuctions; //job seekers address map to auctionId
    mapping (address => uint[]) jobSeekerToApplications; //job seekers address map to applicationId
    mapping (address => uint[]) jobSeekerToCvs; //jobSeeker address map to cvId   
    
    struct JobSeeker{
        address ownerAdd;
        mapping (uint => string) postIdToAuctionStatus; //aucted, canceled, no status???????what's the difference again
        mapping (uint => string) postIdToApplicationStatus; //check if they have apply for it before
    }


    //=================ACCT management start=============================
    function _createJobSeeker () internal {   
        require(addToJobSeeker[msg.sender].length==0);
        //initialize attributes
        uint[] emptyCvIds;
        uint[] emptyAuctionIds;
        uint[] emptyApplicationIds;
        mapping (uint => string) postIdToAuctionStatus;     
        mapping (uint => string) postIdToApplicationStatus;
        //update global variables
        addToJobSeeker[msg.sender]= JobSeeker (msg.sender, postIdToAuctionStatus,postIdToApplicationStatus);
        jobSeekerToAuctions[msg.sender] = emptyAuctionIds;
        jobSeekerToApplications[msg.sender] = emptyAuctionIds;
        jobSeekerToCvs[msg.sender]= emptyCvIds;
    }
    //===================ACCT management end============================


    //===============job seeker CRUD operation on auctions starts================
    //make sure job seeker can only make one auction for one post, or the preview auction is cancelled
    function makeAuction (string _postid, uint[] _cvIds) {
        require (keccak256(addToJobSeeker[msg.sender].postIdToAuctionStatus[_postid]) != keccak256("Aucted"));

        mapping (uint => string) cvIdToStatus;  //put all CV in this auction into the cvStatus mapping and make it "reviewing"
        for(uint i = 0; i<_cvIds.length; i++){
            cvIdToStatus[_cvIds[i]] = "Reviewing";
        }
        jobSeekerToAuctions[msg.sender].push(auctions.length+1); //add auctionId to jobSeeker's own auction id list
        auctions.push(Aution(auctions.length+1, _postid, msg.sender,  now, _cvIds, cvIdToStatus, "Open")); //add auction to the global auctions list
        posts[_postid].auctionIds.push(auctions.length+1); //add auction to this specific post
        addToJobSeeker[msg.sender].postIdToAuctionStatus[_postid]="Auction Made"; //update post auction status
    }

    function  retrieveAllAuctions () returns(Auction[]) {  //?? Can't return Array???
        Auction[] notCancelledAuction;
        uint[] allAuctionId = jobSeekerToAuctions[msg.sender];
        for(uint i = 0; i< allAuctionId.length; i++){
            if(keccak256(auctions[allAuctionId[i]].status) != keccak256("Cancelled")){
                notCancelledAuction.push(auctions[allAuction[i]]);
            }
        }
        return notCancelledAuction;
    }

    function deleteCvForAuction (uint _cvId, uint _auctionId) onlyOwner {//only owner can update
        uint index;
        for(uint i = 0; i<auctions[_auctionId-1].cvIds.length; i++){
            if(auctions[_auctionId-1].cvIds[i]==_cvId){
                index= i;
            }
        }
        delete auctions[_auctionId-1].cvIds[index];
    }

    function cancelAunction (uint _auctionId) onlyOwner {
        uint memory auctedPostId = auctions[_auctionId].postId;
        auctions[_auctionId-1].status = "Cancelled";
        //make sure to udpate postIdTo auctionStatus so jobseeker can make new auction;
        delete addToJobSeeker[msg.sender].postIdToAuctionStatus[auctedPostId];
    }  
    
    function checkCvStatusInAuction (uint _auctionId, uint _cvId)  returns(string) internal onlyOwner {//check the cv status in one Auction
        return auctions[_auctionId].cvIdToStatus[_cvId];//reviewing, scheduled for Interview, Offered, Rejected
    }
    //===============job seeker CRUD operation on auctions ends================



    //===============job seeker CRUD on application starts================
    //make sure job seeker can only make one application for one post, or the preview auction is cancelled
    function makeApplication (string _postid, uint _cvId) {
        require (keccak256(addToJobSeeker[msg.sender].postIdToApplicationStatus[_postid]) != keccak256("Applied"));

        string cvStatus = "Reviewing";
        jobSeekerToApplications[msg.sender].push(applications.length+1); //add applicationId to jobSeeker's own application id list
        applications.push(Application(applications.length+1, _postid, msg.sender,  now, _cvId, cvStatus, "Open")); //add auction to the global auctions list
        posts[_postid].applicationIds.push(applications.length+1); //add application to this specific post
        addToJobSeeker[msg.sender].postIdToApplicationStatus[_postid]="Applied"; //update post application status
    }

    function  retrieveAllApplications () returns(Application[]) {  //?? Can't return Array???
        Application[] notCancelledAuction;
        uint[] allApplicationId = jobSeekerToApplications[msg.sender];
        for(uint i = 0; i< allApplicationId.length; i++){
            if(keccak256(applications[allApplicationId[i]].status) != keccak256("Cancelled")){
                notCancelledApplication.push(applications[allApplicationId[i]]);
            }
        }
        return notCancelledApplication;
    }

    function cancelApplication (uint _applicationId) onlyOwner {
        uint memory appiedPostId = applications[_applicationId].postId;
        applications[_applicationId-1].status = "Cancelled";
        //make sure to udpate postIdTo applicationStatus so jobseeker can make new application;
        delete addToJobSeeker[msg.sender].postIdToApplicationStatus[appiedPostId];
    }

    function checkCvStatusInApplication (uint _applicationId)  returns(string) internal onlyOwner {//check the cv status in one Auction
        return applications[_applicationId].cvStatus;//reviewing, scheduled for Interview, Offered, Rejected
    }
    //===============job seeker CRUD operation on applications ends================


    //===============job seeker CRUD operation on cvs start================
    function _addCv (string _hashAdd)  {
        //update jobSeekerToCvs
        jobSeekerToCvs[msg.sender].push(cvs.length+1);
        //update cvs in cv contract
        cvs.push(Cv(cvs.length+1, _hashAdd,msg.sender));
    }

    function retrieveAllCvs () returns(uint[]) onlyOwner {
        return jobSeekerToCvs[msg.sender];
    }

    function deleteCv (uint _cvId)  internal onlyOwner{
        uint index;
        for(uint i = 0; i<cvs.length; i++){
            if(cvs[i].cvId==_cvId){
                index= i;
            }
        }
        delete jobSeekerToCvs[msg.sender][index];
    }
    //===============job seeker CRUD operation on cvs ends================