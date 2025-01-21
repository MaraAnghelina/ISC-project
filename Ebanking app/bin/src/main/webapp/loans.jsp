<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page language="java" import="java.lang.*,java.math.*,db.*,java.sql.*, java.io.*, java.util.*"%>
<%@ page import="java.util.Date, java.text.SimpleDateFormat" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="com.ebanking.scheduler.LoanScheduler" %>
<%@ page import="java.io.IOException" %>
<!DOCTYPE html>
<html>
<head> 
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Loans</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #2b2b2b;
            margin: 0;
            padding: 0;
            display: flex;
            flex-direction: column;
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
            color: #eee;
        }
        h2 {
            margin-bottom: 20px;
        }
        .input-group {
            margin-bottom: 20px;
        }
        .input-group input {
            padding: 10px;
            width: 100%;
            border: none;
            border-radius: 4px;
            box-sizing: border-box;
        }
        .input-group label {
            display: block;
            margin-bottom: 5px;
        }
        .result {
            font-size: 20px;
            margin-bottom: 20px;
        }
        .button {
            padding: 10px 20px;
            border: none;
            border-radius: 4px;
            background-color: #4682B4;
            color: white;
            cursor: pointer;
            transition: background-color 0.3s;
            margin: 5px;
        }
        .button:hover {
            background-color: #356892;
        }
        #confirmationMessage {
            margin-top: 20px;
            color: #4caf50;
        }
    </style>
</head>
<jsp:useBean id="jb" scope="session" class="db.JavaBean" />
<jsp:setProperty name="jb" property="*" />
<body>
    <div class="container">
        <h2>Loan Calculator</h2>
        <form method="post" action="">
            <div class="input-group">
                <label for="loanAmount">Loan Amount</label>
                <input type="number" id="loanAmount" name="loanAmount" placeholder="Enter loan amount">
            </div>
            <div class="input-group">
                <label for="loanTerm">Loan Term (months)</label>
                <input type="number" id="loanTerm" name="loanTerm" placeholder="Enter loan term in months">
            </div>
            <button type="button" class="button" onclick="calculateLoan()">Calculate</button>
            <button type="submit" class="button">Save Loan</button>
            <div class="result" id="loanResult"></div>
            <input type="hidden" id="totalRepayment" name="totalRepayment">
            <input type="hidden" id="monthlyPayment" name="monthlyPayment">
        </form>
        <button class="button" onclick="window.location.href='homepage.jsp'">Home</button>
    </div>
    <div id="confirmationMessage"></div>

    <script>
        function calculateLoan() {
            var loanAmount = parseFloat(document.getElementById('loanAmount').value);
            var loanTerm = parseInt(document.getElementById('loanTerm').value);

            if (isNaN(loanAmount) || isNaN(loanTerm) || loanAmount <= 0 || loanTerm <= 0) {
                document.getElementById('loanResult').innerHTML = 'Please enter valid loan amount and term.';
            } else {
                var totalRepayment = loanAmount * (1 + 0.05 * loanTerm); // Example calculation with 5% interest
                var monthlyPayment = totalRepayment / loanTerm;
                document.getElementById('loanResult').innerHTML = 'Total repayment: $' + totalRepayment.toFixed(2) + '<br>Monthly payment: $' + monthlyPayment.toFixed(2);
                
                // Set hidden fields for form submission
                document.getElementById('totalRepayment').value = totalRepayment.toFixed(2);
                document.getElementById('monthlyPayment').value = monthlyPayment.toFixed(2);
            }
        }
    </script>

    <%
        if ("POST".equalsIgnoreCase(request.getMethod())) {
            String loanAmountStr = request.getParameter("loanAmount");
            String loanTermStr = request.getParameter("loanTerm");
            String totalRepaymentStr = request.getParameter("totalRepayment");
            String monthlyPaymentStr = request.getParameter("monthlyPayment");
            jb.connect();
            try {
                if (loanAmountStr != null && loanTermStr != null && totalRepaymentStr != null && monthlyPaymentStr != null) {
                    double loanAmount = Double.parseDouble(loanAmountStr);
                    int loanTerm = Integer.parseInt(loanTermStr);
                    double totalRepayment = Double.parseDouble(totalRepaymentStr);
                    double monthlyPayment = Double.parseDouble(monthlyPaymentStr);

                    // Database connection parameters
                    String username = (String) session.getAttribute("username"); // Replace with actual username
                    String password = (String) session.getAttribute("password"); // Replace with actual password

                    Connection conn = null;
                    Statement stmt = null;
                    ResultSet rs = null;

                    try {
                        // Load JDBC driver
                        Class.forName("com.mysql.cj.jdbc.Driver");
                        // Establish connection
                        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/ebanking?useSSL=false", "root", "Trompisor*2002*");

                        // Find user logic, replace with actual method to get user ID
                        rs = jb.findUser(username, password);
                        if (rs.next()) {
                            int iduser = rs.getInt("iduser");

                            // Construct SQL statement
                            String sql = "INSERT INTO imprumuturi (Suma, Perioada, SumaFinala, PlataLunara, iduser) VALUES (" +
                                         loanAmount + ", " +
                                         loanTerm + ", " +
                                         totalRepayment + ", " +
                                         monthlyPayment + ", " +
                                         iduser + ")";

                            stmt = conn.createStatement();
                            stmt.executeUpdate(sql);
							
                            if(loanAmountStr!= null){
                    			double sum = Double.parseDouble(loanAmountStr);
                    			String date = new Date().toString().substring(0, 10);

                    			String currency = "";
                    	    	String queryStringg = ("select Valuta from conturi where iduser='" + iduser + "';");
                    	    	rs = stmt.executeQuery(queryStringg);
                    	    	if(rs.next())
                    	    		currency = rs.getString("Valuta");
                    			
                    			stmt = conn.createStatement();
                    			stmt.executeUpdate("insert into tranzactii(TipTranzactie, Suma, Data, Valuta, iduser) values('" + "loan" + "' , '" + sum + "', '" + date + "', '" + currency + "', '" + iduser +"' );");
                    			stmt = conn.createStatement();
                    			
                    			
                    			double suma = 0;
                    	    	String queryString = ("select Suma from conturi where iduser='" + iduser + "';");
                    	    	stmt = conn.createStatement();
                    	    	rs = stmt.executeQuery(queryString);
                    	    	if(rs.next())
                    	    		suma = rs.getDouble("Suma");
                    	    	suma = suma + sum;
                    			
                    			stmt.executeUpdate("update conturi set Suma = '" + suma + "' where iduser='" + iduser + "';");
                    		}
                           
                           
                            out.println("<script>document.getElementById('confirmationMessage').innerHTML = 'Loan saved successfully!';</script>");
                        } else {
                            out.println("<script>document.getElementById('confirmationMessage').innerHTML = 'User not found.';</script>");
                        }
                    } catch (Exception e) {
                        e.printStackTrace();
                        out.println("<script>document.getElementById('confirmationMessage').innerHTML = 'Error saving loan: " + e.getMessage() + "';</script>");
                    } finally {
                        if (rs != null) try { rs.close(); } catch (SQLException e) {}
                        if (stmt != null) try { stmt.close(); } catch (SQLException e) {}
                        if (conn != null) try { conn.close(); } catch (SQLException e) {}
                    }
                }
            } catch (NumberFormatException e) {
                out.println("<script>document.getElementById('confirmationMessage').innerHTML = 'Error: Invalid input format.';</script>");
            }
            
           
            Calendar calendar = Calendar.getInstance();
         	Date loanDate = calendar.getTime();
            try{
               
                LoanScheduler.scheduleLoanPayment(loanDate);
             	
                Calendar cal = Calendar.getInstance();
                cal.setTime(loanDate);
                cal.add(Calendar.MONTH, 1);

                SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
                out.println("<script>document.getElementById('confirmationMessage').innerHTML += ' Loan payment scheduled successfully for: " + dateFormat.format(cal.getTime()) + "';</script>");
            } catch (Exception e) {
                out.println("<script>document.getElementById('confirmationMessage').innerHTML += ' Error scheduling loan payment: " + e.getMessage() + "';</script>");
                e.printStackTrace();
            }
            
            jb.disconnect();
        }
    %>
</body>
</html>
