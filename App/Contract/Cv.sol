pragma solidity ^0.4.21;

contract Cv{

	struct Cv{
		uint  cvId;
		string hashAdd;// the hash value generate from ipfs
		address ownerAdd;
	}


	Cv[] cvs; // global cv list
}