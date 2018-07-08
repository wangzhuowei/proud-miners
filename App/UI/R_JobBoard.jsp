﻿<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <!-- The above 3 meta tags *must* come first in the head; any other head content must come *after* these tags -->
    <title>Candid Intel</title>

    <!-- Bootstrap -->
    <link href="css/bootstrap.min.css" rel="stylesheet">
	<link rel="stylesheet" href="css/font-awesome.min.css">
	<link rel="stylesheet" href="css/animate.css">
	<link href="css/animate.min.css" rel="stylesheet"> 
	<link href="css/style.css" rel="stylesheet" />	
    <!-- HTML5 shim and Respond.js for IE8 support of HTML5 elements and media queries -->
    <!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
    <!--[if lt IE 9]>
    <script src="https://oss.maxcdn.com/html5shiv/3.7.2/html5shiv.min.js"></script>
    <script src="https://oss.maxcdn.com/respond/1.4.2/respond.min.js"></script>
    <![endif]-->
  </head>
  <body>
      <header id="header">
          <nav class="navbar navbar-default navbar-static-top" role="banner">
              <div class="h_container">
                  <div class="navbar-header">
                      <button type="button" class="navbar-toggle" data-toggle="collapse" data-target=".navbar-collapse">
                          <span class="sr-only">Toggle navigation</span>
                          <span class="icon-bar"></span>
                          <span class="icon-bar"></span>
                          <span class="icon-bar"></span>
                      </button>
                      <a href="index.html"><img src="img/ci_logo.png" alt="Home" id="logo_pic"></a>
					
                  </div>
                  <div class="menu_div">
                      <div class="menu">
                          <ul class="nav nav-tabs" role="tablist">
                              <li role="presentation"><a href="R_AccOverview.jsp">Account Overview</a></li>
                              <li role="presentation"><a href="R_JobBoard.jsp" class="active">Job Board</a></li>
                              <li role="presentation"><a href="">Wallet</a></li>
                              <li role="presentation"><a href="">Sign Out</a></li>
                              <li role="presentation"><a href="H_contact.jsp">Contact Us</a></li>
                          </ul>
                      </div>
                  </div>
              </div><!--/.container-->
          </nav><!--/nav-->
      </header><!--/header-->

      <div class="m_about">
          <div>
              <div class="text-center">
                  <h2>Match your skills, find mroe opportunities!</h2>
                  <div class="search_f">
                      <form action="/action_page.php">
                          <input type="text" class="search_box" placeholder="Search Job by Title or Keyword" name="search">
                          <select class="search_dropdown">
                              <option value="aet" selected>All Employement Types</option>
                              <option value="ft">Full Time</option>
                              <option value="pt">Part Time</option>
                              <option value="t">Temporary</option>
                              <option value="c">Contract</option>
                          </select>

                          <button type="submit" class="search_btn"><i>Search</i></button>
                      </form>
                  </div>

              </div>
          </div>
      </div>
      
      <div class="jb_wrap">
          <div class="jb_filter">
              <div class="jb_lvl">
                  <h3>Job Level</h3>
                  <p>Senior Management: <input type="checkbox" id="myCheck"></p>
                  <p>          Manager: <input type="checkbox" id="myCheck"></p>
                  <p>     Professional: <input type="checkbox" id="myCheck"></p>
                  <p> Senior Executive: <input type="checkbox" id="myCheck"></p>
                  <p>        Executive: <input type="checkbox" id="myCheck"></p>
                  <p>Fresh/entry level: <input type="checkbox" id="myCheck"></p>

              </div>


              <div class="jb_lvl">
                  <h3>Sort By</h3>
                  <p> Date: <input type="checkbox" id="myCheck"></p>
                  <p>Relevence: <input type="checkbox" id="myCheck"></p>
                  <p>Reward: <input type="checkbox" id="myCheck"></p>
              </div>

              <div class="clear_filter">
                  <button type="button">Clear Filter</button>
              </div>
                 
              </div>
              <div class="jb_panel">

                  <div class="rl_box">
                      <div class="jb_tb_div">
                          <table class="jb_info_tb">
                              <tr>
                                  <td class="company_pic_box">
                                      <img src=".gif">
                                  </td>

                                  <td>
                                      <table>
                                          <tr><td>Company Name</td></tr>
                                          <tr><td>Job Name</td></tr>
                                          <tr><td>Details XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX</td></tr>
                                      </table>

                                  </td>

                                  <td><h3>$$ </h3></td>

                              </tr>


                          </table>

                      </div>
                     

                  </div>
                 






                  </div>

              </div>
         
      
     

      <div class="sub-footer">
          <div class="h_container">
              <div class="social-icon">
                  <div class="col-md-4">
                      <ul class="social-network">
                          <li><a href="#" class="fb tool-tip" title="Facebook"><i class="fa fa-facebook"></i></a></li>
                          <li><a href="#" class="twitter tool-tip" title="Twitter"><i class="fa fa-twitter"></i></a></li>
                          <li><a href="#" class="gplus tool-tip" title="Google Plus"><i class="fa fa-google-plus"></i></a></li>
                          <li><a href="#" class="linkedin tool-tip" title="Linkedin"><i class="fa fa-linkedin"></i></a></li>
                          <li><a href="#" class="ytube tool-tip" title="You Tube"><i class="fa fa-youtube-play"></i></a></li>
                      </ul>
                  </div>
              </div>

              <div class="col-md-4 col-md-offset-4">
                  <div class="copyright">
                      &copy; Proud Miner 2018 by <a target="_blank" href="http://bootstraptaste.com/" title="Free Twitter Bootstrap WordPress Themes and HTML templates">Haonan</a>.All Rights Reserved.
                  </div>
                  <!--
                    All links in the footer should remain intact.
                    Licenseing information is available at: http://bootstraptaste.com/license/
                    You can buy this theme without footer links online at: http://bootstraptaste.com/buy/?theme=Day
                -->
              </div>
          </div>
      </div>

      <!-- jQuery (necessary for Bootstrap's JavaScript plugins) -->
      <script src="js/jquery.js"></script>
      <!-- Include all compiled plugins (below), or include individual files as needed -->
      <script src="js/bootstrap.min.js"></script>
      <script src="js/wow.min.js"></script>
      <script>
          wow = new WOW(
              {

              })
              .init();
      </script>
  </body>
</html>