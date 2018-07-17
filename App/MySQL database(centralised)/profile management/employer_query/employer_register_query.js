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
  
  //register a new employer 
  var sql0 = "INSERT INTO employer VALUES ('E6', 'test_fn','test_ln','6 Description','6 Position','6 Company_Name','6 Company_Profile','6 Company_Location')";
  con.query(sql0,function(error0, results){
	if (error0) throw error0;
	console.log('-------register a new employer-------');
	console.log(results);
  });
  
  //retrieve all records from employer
  con.query('select * from employer',function(error1, results){
	if (error1) throw error1;
	console.log('-------retrieve all records from employer table-------');
	console.log(results);
  });
  
  //retrieve all Employer_ID from employer
  con.query('select Employer_ID from employer',function(error2, results){
	if (error2) throw error2;
	console.log('-------retrieve all Employer_ID from employer table-------');
	console.log(results);
  });
  
  //update employer profile
  var sql1 = "UPDATE employer SET FirstName = 'new_firstname',LastName = 'new_lastname', Description = 'new 6 Description',Position = 'new 6 Position',Company_Name = 'new 6 Company_Name',Company_Profile= 'new 6 Company_Profile',Company_Location = 'new 6 Company_Location' WHERE Employer_ID = 'E6'";
  con.query(sql1, function (error3, results) {
    if (error3) throw error3;
	console.log('-------update employer profile-------');
    console.log(results.affectedRows + " record(s) updated");
  });
  
  
});


