var mysql = require('mysql');

var con = mysql.createConnection({
  host: "localhost",
  user: "root",
  password: "",
  database:'profiledb'
});

con.connect(function(err1) {
  if (err1) throw err1;
  console.log("Connected to profiledb!");
  
  //register a new recruiter 
  var sql0 = "INSERT INTO recruiter VALUES ('R6', 'test_fn','test_ln','6 Description','6 Qualification','6 Industry','6 Address')";
  con.query(sql0,function(error0, results){
	if (error0) throw error0;
	console.log('-------register a new recruiter-------');
	console.log(results);
  });
  
  //retrieve all records from recruiter
  con.query('select * from recruiter',function(error1, results){
	if (error1) throw error1;
	console.log('-------retrieve all records from recruiter table-------');
	console.log(results);
  });
  
  //retrieve all Recruiter_ID from recruiter
  con.query('select Recruiter_ID from recruiter',function(error2, results){
	if (error2) throw error2;
	console.log('-------retrieve all Recruiter_ID from recruiter table-------');
	console.log(results);
  });
  
  //update recruiter profile
  var sql1 = "UPDATE recruiter SET FirstName = 'new_firstname',LastName = 'new_lastname', Description = 'new 6 Description',Qualification = 'new 6 Qualification',Industry = 'new 6 Industry',Address= 'new 6 Address' WHERE Recruiter_ID = 'R6'";
  con.query(sql1, function (error3, results) {
    if (error3) throw error3;
	console.log('-------update recruiter profile-------');
    console.log(results.affectedRows + " record(s) updated");
  });
  
  
});


