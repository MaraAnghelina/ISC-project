<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page language="java" import="java.lang.*,java.math.*,db.*,java.sql.*, java.io.*, java.util.*"%>
<%@ page import="java.util.Date" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Check Balance</title>
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
            width: 550px;
            text-align: center;
            display: flex; /* Add this */
            flex-direction: column; /* Add this */
            align-items: center; /* Add this */
        }
        input[type="text"], input[type="submit"] {
            width: 90%;
            padding: 10px;
            margin: 8px 10px;
            display: inline-block;
            border: 1px solid #444; 
            border-radius: 4px;
            box-sizing: border-box;
            color: #eee; 
            background-color: #444; 
        }
        input[type="submit"] {
            background-color: #483D8B;
            color: white;
            margin: 8px 10px;
            border: none;
            cursor: pointer;
        }
        input[type="submit"]:hover {
            background-color: #4682B4;
        }
        label {
            color: #eee; 
        }
        .homepage-button {
            background-color: #007bff;
            color: white;
            border: none;
            border-radius: 4px;
            padding: 10px 15px;
            margin-top: 20px; /* Add this */
            cursor: pointer;
        }
        .homepage-button:hover {
            background-color: #0056b3;
        }
    </style>
</head>
<jsp:useBean id="jb" scope="session" class="db.JavaBean" />
<jsp:setProperty name="jb" property="*" />
<body>

<%


String amount = request.getParameter("amount");

double bani =0;
if (amount != null && !amount.isEmpty()) {
    try {
        bani = Double.parseDouble(amount);
    } catch (NumberFormatException e) {
        // Handle parsing error if needed
    }
}









jb.connect();
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
sum = sum -  bani;
stmt.executeUpdate("update conturi set Suma = '" +sum + "' where iduser='" + id + "';");


String currency = "";
queryString = ("select Valuta from conturi where iduser='" + id + "';");
stmt = con.createStatement(/*ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY*/);
rs = stmt.executeQuery(queryString);
if(rs.next())
	currency = rs.getString("Valuta");

 
String date = new Date().toString().substring(0, 10);
stmt = con.createStatement();
stmt.executeUpdate("insert into tranzactii(TipTranzactie, Suma, Data, Valuta, iduser) values('" + "transfer" + "' , '" + amount + "', '" + date + "', '" + currency + "', '" + id +"' );");
stmt = con.createStatement();
	
    if (amount != null && !amount.isEmpty()) {
        try {
            int balance = Integer.parseInt(amount); 
            out.print("<div class='container'><h2 style='color: #eee;'>Suma de " + balance + " RON a fost transferata cu succes! </h2><button class='homepage-button' onclick='window.location.href=\"homepage.jsp\"'>Home</button></div>");
        } catch (NumberFormatException e) {
            out.print("<div class='container'><h2 style='color: #eee;'>Invalid amount</h2><button class='homepage-button' onclick='window.location.href=\"homepage.jsp\"'>Home</button></div>");
        }
    } else {
%>

    <div class="container">
        <h2 style="color: #eee;">Check Balance</h2>
        <form action="checkBalance.jsp" method="post">
            <label for="amount">Amount</label><br>
            <input type="text" id="amount" name="amount" placeholder="Enter amount" required><br>
            <input type="submit" value="Check Balance">
        </form>
        
        <button class="homepage-button" onclick="window.location.href='homepage.jsp'">Home</button>
    </div>

<%
    }
%>

</body>
</html>
