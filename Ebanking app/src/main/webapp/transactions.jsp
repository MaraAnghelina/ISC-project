<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page language="java" import="java.lang.*,java.math.*,db.*,java.sql.*, java.io.*, java.util.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Transactions</title>
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
        
        table {
            width: 60%;
            border-collapse: collapse;
            margin-top: 10px;
            margin-left: 250px;
            text-align: center;
            border: round;
            color: #eee;
        }

        table, th, td {
            border: 3px solid #555;
            text-align: center;
            color: #eee;
        }

        th, td {
            padding: 10px;
            text-align: left;
            color: #eee;
        }

        th {
            background-color: #555;
            color: #fff;
        }

        tr:hover {
            background-color: #483D8B;
        }
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
	    	
	    	String currency = "";
	    	queryString = ("select Valuta from conturi where iduser='" + id + "';");
	    	stmt = con.createStatement(/*ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY*/);
	    	rs = stmt.executeQuery(queryString);
	    	if(rs.next())
	    		currency = rs.getString("Valuta");
    	%>
    	<h3 style="color: #eee;">Your transactions : </h3>
        <table>   
                    <tr>
                        <th>Type</th>
                        <th>Amount</th>
                        <th>Date</th>
                    </tr>
                
                <% 
	                queryString = ("select * from tranzactii where iduser='" + id + "' ORDER BY idtranzactie DESC;");
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
   
    <div class="help-button" onclick="redirectToHomepage()">
        <i class="fas fa-home"></i>
    </div>
    
    <script>
        function redirectToHomepage() {
            window.location.href = "homepage.jsp";
        }
    </script>
  
</body>
</html>