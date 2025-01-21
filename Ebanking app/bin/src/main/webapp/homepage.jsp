<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page language="java" import="java.lang.*,java.math.*,db.*,java.sql.*, java.io.*, java.util.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head> 
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>E-Banking Homepage</title>
    <style> 
        body {
            font-family: Arial, sans-serif; 
            background-color: #2b2b2b;
            margin: 0;
            padding: 0;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
        }
        
        .container {
            background-color: #353535; 
            padding: 20px; 
            border-radius: 5px;
            box-shadow: 0 0 10px rgba(255, 255, 255, 0.1);
            width: 70%; 
            text-align: center;
            position: relative;
        }

        .balance {
            font-size: 24px;
            color: #eee; 
            margin-bottom: 20px;
        }

        .button-container {
            display: flex; 
            justify-content: space-between; 
            overflow-x: auto; 
            margin-bottom: 10px; 
        }

        .button-container input[type="submit"] {
            padding: 10px 15px;
            border: none;
            border-radius: 4px;
            box-sizing: border-box;
            color: white;
            background-color: #483D8B; 
            cursor: pointer;
            transition: background-color 0.3s;
            min-width: 120px;
        }
 
        .button-container input[type="submit"]:hover {
            background-color: #4682B4; 
        }

        .help-button {
            position: fixed;
            bottom: 20px;
            right: 20px;
            width: 50px;
            height: 50px;
            border-radius: 50%;
            background-color: #483D8B;
            color: white;
            font-size: 24px;
            display: flex;
            justify-content: center;
            align-items: center;
            cursor: pointer;
            transition: background-color 0.3s;
            border: none; 
            z-index: 999;
        }

        .help-button:hover {
            background-color: #4682B4;
        }

        .settings-button {
            position: fixed;
            bottom: 20px;
            right: calc(20px + 50px + 10px); 
            width: 50px;
            height: 50px;
            border-radius: 50%;
            background-color: #483D8B;
            color: white;
            font-size: 24px;
            display: flex;
            justify-content: center;
            align-items: center;
            cursor: pointer;
            transition: background-color 0.3s;
            border: none; 
            z-index: 998;
        }

        .settings-button:hover {
            background-color: #4682B4;
        }
        
        .logout-button {
            position: fixed;
            bottom: 20px;
            right: calc(20px + 50px + 68px); 
            width: 50px;
            height: 50px;
            border-radius: 50%;
            background-color: #483D8B;
            color: white;
            font-size: 24px;
            display: flex;
            justify-content: center;
            align-items: center;
            cursor: pointer;
            transition: background-color 0.3s;
            border: none; 
            z-index: 998;
        }

        .logout-button:hover {
            background-color: #4682B4;
        }
        
       .transactions {
            background-color: #444;
            padding: 10px;
            border-radius: 5px;
            margin-top: 20px;
            color: #eee;
        }

        .transactions h3 {
            margin-top: 0;
        }

        .transactions table {
            width: 60%;
            border-collapse: collapse;
            margin-top: 10px;
            margin-left: 250px;
            text-align: center;
            border: round;
        }

        .transactions table, th, td {
            border: 3px solid #555;
            text-align: center;
        }

        .transactions th, .transactions td {
            padding: 10px;
            text-align: left;
        }

        .transactions th {
            background-color: #555;
            color: #fff;
        }
        tr:hover {background-color: #483D8B;}
    </style>
</head>
<jsp:useBean id="jb" scope="session" class="db.JavaBean" />
<jsp:setProperty name="jb" property="*" />

<body>
    
    
    <div class="container">
    	<%
    		String email =(String) session.getAttribute("email");
    		int id = 0;
	    	
	    	String error;
	    	
	    	Connection con;
	     	
	    	Class.forName("com.mysql.cj.jdbc.Driver");
	    	con = DriverManager.getConnection("jdbc:mysql://localhost:3306/ebanking?useSSL=false", "root", "Berberita@10");
	    	
	    	String queryString = ("select iduser from user where Email='" + email + "';");
	    	Statement stmt = con.createStatement(/*ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY*/);
	    	ResultSet rs = stmt.executeQuery(queryString);
	    	if(rs.next()) 
	    		id = rs.getInt("iduser");
	    	  
	    	double sum = 0;
	    	queryString = ("select Suma from conturi where iduser='" + id + "';");
	    	stmt = con.createStatement(/*ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY*/);
	    	rs = stmt.executeQuery(queryString);
	    	if(rs.next())
	    		sum = rs.getDouble("Suma");
	    	
	    	String currency = "";
	    	queryString = ("select Valuta from conturi where iduser='" + id + "';");
	    	stmt = con.createStatement(/*ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY*/);
	    	rs = stmt.executeQuery(queryString);
	    	if(rs.next())
	    		currency = rs.getString("Valuta");
	    	
	    	
    	%>
        <h2 style="color: #eee;">Welcome to M&A <%= email %>!</h2>
        
        <div class="balance">
            Your Account Balance: <%= sum %>  <%= currency %>
        </div>

        <div class="button-container">
            <input type="submit" value="View Transactions" onclick="redirectToTransactionsPage()">
            <input type="submit" value="Withdraw Funds" onclick="redirectToWithdrawPage()">
            <input type="submit" value="Deposit Funds" onclick="redirectToDepositPage()">
            <input type="submit" value="Transfer Money" onclick="redirectToTransferPage()">
             <input type="submit" value="Loans" onclick="redirectToLoansPage()">
        </div>

	<br>

	 <div class="transactions">
            <h3>Last 3 Transactions:</h3>
             <table>   
                    <tr>
                        <th>Type</th>
                        <th>Amount</th>
                        <th>Date</th>
                    </tr>
                
                <% 
	                queryString = ("select * from tranzactii where iduser='" + id + "' ORDER BY idtranzactie DESC LIMIT 3;");
			    	stmt = con.createStatement(/*ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY*/);
			    	rs = stmt.executeQuery(queryString);
	                while (rs.next()) { 
	                    String type = rs.getString("TipTranzactie");
	                    double amount = rs.getDouble("Suma");
	                    String date = rs.getString("Data");
	                    
                %>
                    <tr>
                        <td><%= type %></td>
                        <td><%= amount %> <%= currency %></td>
                        <td><%= date %></td>
                    </tr>
                <% 
                    } 
                    rs.close();
                    stmt.close();
                    con.close();
                %>
                
            </table>
        </div>
        
      </div>
   
	<div class="logout-button" onclick="LogOut()">
        <i class="fa fa-sign-out"></i>
    </div>   
   
    <div class="help-button" onclick="redirectToHelpPage()">
        <i class="fas fa-question"></i>
    </div>
   	
    <div class="settings-button" onclick="redirectToSettingsPage()">
        <i class="fas fa-cog"></i>
    </div>

   
    <script>
        function redirectToHelpPage() {
            window.location.href = "help.jsp";
        }

        function redirectToSettingsPage() {
            window.location.href = "settings.jsp";
        }
        
        function redirectToWithdrawPage(){
        	window.location.href = "map.html";
        }
        
        function redirectToDepositPage(){
        	window.location.href = "deposit.html";
        }
        
        function redirectToLoansPage() {
            window.location.href = "loans.jsp";
        }
        
        function redirectToTransactionsPage() {
            window.location.href = "transactions.jsp";
        }
        
        function redirectToTransferPage() {
            window.location.href = "transfer.jsp";
        }
        
        function LogOut() {
            window.location.href = "index.html";
        }
    </script>
    
</body>
</html>