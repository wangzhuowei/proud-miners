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
  
  //register a new jobseeker 
  var sql0 = "INSERT INTO jobseeker VALUES ('J6', 'test_fn','test_ln','6 Description','6 Nationality','6 Industry','6 Address')";
  con.query(sql0,function(error0, results){
	if (error0) throw error0;
	console.log('-------register a new jobseeker-------');
	console.log(results);
  });
  
  //retrieve all records from jobseeker
  con.query('select * from jobseeker',function(error1, results){
	if (error1) throw error1;
	console.log('-------retrieve all records from jobseeker table-------');
	console.log(results);
  });
  
  //retrieve all Jobseeker_ID from jobseeker
  con.query('select Jobseeker_ID from jobseeker',function(error2, results){
	if (error2) throw error2;
	console.log('-------retrieve all Jobseeker_ID from jobseeker table-------');
	console.log(results);
  });
  
  //update jobseeker profile
  var sql1 = "UPDATE jobseeker SET FirstName = 'new_firstname',LastName = 'new_lastname', Description = 'new 6 Description',Nationality = 'new 6 Nationality',Industry = 'new 6 Industry',Address= 'new 6 Address' WHERE Jobseeker_ID = 'J6'";
  con.query(sql1, function (error3, results) {
    if (error3) throw error3;
	console.log('-------update jobseeker profile-------');
    console.log(results.affectedRows + " record(s) updated");
  });
  
  
});


