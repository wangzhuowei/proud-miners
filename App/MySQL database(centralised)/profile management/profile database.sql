CREATE DATABASE profiledb;

# ----------------- SQL creation script ----------------- #
CREATE TABLE employer
(Employer_ID		varchar(50) 		not null,
 FirstName	    	varchar(50) 	 	not null,
 LastName      		varchar(50)   	 	not null,
 Description    	varchar(50)   	 	not null,
 Position    		varchar(50)   	 	not null,
 Company_Name      	varchar(50)   	 	not null,
 Company_Profile    varchar(50)   	 	not null,
 Company_Location   varchar(50)   	 	not null,
CONSTRAINT employer_pk PRIMARY KEY (Employer_ID)	
);

CREATE TABLE jobseeker
(Jobseeker_ID		varchar(50) 		not null,
 FirstName	    	varchar(50) 	 	not null,
 LastName      		varchar(50)   	 	not null,
 Description    	varchar(50)   	 	not null,
 Nationality    	varchar(50)   	 	not null,
 Industry    		varchar(50)   	 	not null,
 Address   			varchar(50)   	 	not null,
CONSTRAINT jobseeker_pk PRIMARY KEY (Jobseeker_ID)	
);

CREATE TABLE recruiter
(Recruiter_ID		varchar(50) 		not null,
 FirstName	    	varchar(50) 	 	not null,
 LastName      		varchar(50)   	 	not null,
 Description    	varchar(50)   	 	not null,
 Qualification    	varchar(50)   	 	not null,
 Industry    		varchar(50)   	 	not null,
 Address   			varchar(50)   	 	not null,
CONSTRAINT recruiter_pk PRIMARY KEY (Recruiter_ID)	
);

# --------------- Load data script --------------- #
INSERT INTO employer VALUES 
('E1', 'Mingqi','Yang','1 Description','1 Position','1 Company_Name','1 Company_Profile','1 Company_Location'), 
('E2', 'Zhuowei','Wang','2 Description','2 Position','2 Company_Name','2 Company_Profile','2 Company_Location'),  
('E3', 'Yigang','Li','3 Description','3 Position','3 Company_Name','3 Company_Profile','3 Company_Location'),  
('E4', 'Haonan','Luo','4 Description','4 Position','4 Company_Name','4 Company_Profile','4 Company_Location'),  
('E5', 'Yuqi','Gui','5 Description','5 Position','5 Company_Name','5 Company_Profile','5 Company_Location');

INSERT INTO jobseeker VALUES 
('J1', 'Mingqi','Yang','1 Description','1 Nationality','1 Industry','1 Address'), 
('J2', 'Zhuowei','Wang','2 Description','2 Nationality','2 Industry','2 Address'),  
('J3', 'Yigang','Li','3 Description','3 Nationality','3 Industry','3 Address'),  
('J4', 'Haonan','Luo','4 Description','4 Nationality','4 Industry','4 Address'),  
('J5', 'Yuqi','Gui','5 Description','5 Nationality','5 Industry','5 Address');

INSERT INTO recruiter VALUES 
('R1', 'Mingqi','Yang','1 Description','1 Qualification','1 Industry','1 Address'),
('R2', 'Zhuowei','Wang','2 Description','2 Qualification','2 Industry','2 Address'),
('R3', 'Yigang','Li','3 Description','3 Qualification','3 Industry','3 Address'), 
('R4', 'Haonan','Luo','4 Description','4 Qualification','4 Industry','4 Address'),  
('R5', 'Yuqi','Gui','5 Description','5 Qualification','5 Industry','5 Address');

