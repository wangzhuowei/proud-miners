pragma solidity ^0.4.21;

contract Application{
	
	struct Application {
		uint applicationId;
		uint postId;
		address ownerAdd; // to record job seeker
		uint postTime;//maybe not neccessary, need to track the time of which application, using which cv
		uint cvId; //job seeker's cv 
		string cvStatus;  //Reviewing, Shortlisted, Offered by employer, Rejected by employer, Accepted by candidate, Rejected by candidate
		string status;////Open, close, offered, Cancelled
	}

	Application[] applications; //all the applications from job seekers in this app
	
}


