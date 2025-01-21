<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.lang.*,java.math.*,db.*,java.sql.*,java.io.*,java.util.*"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Money Transfer - E-Banking App</title>
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
            width: 400px;
        }
        .container h1 {
            text-align: center;
            margin-bottom: 20px;
            color: #eee;
        }
        .form-group {
            margin-bottom: 15px;
        }
        .form-group label {
            display: block;
            margin-bottom: 5px;
        }
        .form-group input {
            width: calc(100% - 20px);
            padding: 8px 10px;
            border: 1px solid #ced4da;
            border-radius: 4px;
        }
        .form-group button {
            width: 100%;
            padding: 10px 15px;
            border: none;
            border-radius: 4px;
            background-color: #007bff;
            color: white;
            font-size: 16px;
            cursor: pointer;
        }
        .form-group button:hover {
            background-color: #0056b3;
        }
        input[type="text"], input[type="password"], input[type="submit"] {
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
        .balance-tooltip {
            display: none;
            position: absolute;
            top: -30px;
            right: 0;
            background-color: #f8f9fa;
            border: 1px solid #ced4da;
            border-radius: 4px;
            padding: 5px;
            font-size: 14px;
            box-shadow: 0 0 5px rgba(0, 0, 0, 0.1);
            z-index: 1;
        }
        alert.custom-alert {
            --backdrop-opacity: 0.7;
        }

        .custom-alert .alert-button-group {
            padding: 8px;
        }

        button.alert-button.alert-button-confirm {
            background-color: var(--ion-color-success);
            color: var(--ion-color-success-contrast);
        }

        .md button.alert-button.alert-button-confirm {
            border-radius: 4px;
        }

        .custom-alert button.alert-button {
            border: 0.55px solid rgba(var(--ion-text-color-rgb, 0, 0, 0), 0.2);
        }

        button.alert-button.alert-button-cancel {
            border-right: 0;
            border-bottom-left-radius: 13px;
            border-top-left-radius: 13px;
        }

        button.alert-button.alert-button-confirm {
            border-bottom-right-radius: 13px;
            border-top-right-radius: 13px;
        }

        .transactions {
            background-color: #444;
            padding: 10px;
            border-radius: 5px;
            margin-top: 20px;
            color: #eee;
        }
        .balance {
            font-size: 20px;
            color: #eee;
            margin-bottom: 20px;
            text-align: center;
        }
    </style>
</head>

<jsp:useBean id="jb" scope="session" class="db.JavaBean" />
<jsp:setProperty name="jb" property="*" />

<body>
    <div class="container">
        <h1>Money Transfer</h1>
        <form id="transferForm" method="post" action="updateBalance.jsp">
            <div class="form-group">
                <label for="recipientName">Recipient Name</label>
                <input type="text" id="recipientName" name="recipientName" required>
            </div>
            <div class="form-group">
                <label for="accountNumber">Account Number</label>
                <input type="text" id="accountNumber" name="accountNumber" required>
            </div>
            <div class="form-group">
                <label for="amount">Amount</label>
                <input type="text" id="amount" name="amount" oninput="updateBalanceDisplay()" required>
            </div>
            <div class="form-group">
                <button type="submit">Transfer</button>
                <alert trigger="present-alert" class="custom-alert" header="Are you sure?" [buttons]="alertButtons"></alert>
            </div>
        </form>

        <div class="transactions">
            <h4>Your account balance: </h4>
            <%
                String email = (String) session.getAttribute("email");
                int id = 0;

                Connection con;

                Class.forName("com.mysql.cj.jdbc.Driver");
                con = DriverManager.getConnection("jdbc:mysql://localhost:3306/ebanking?useSSL=false", "root", "Berberita@10");

                String queryString = "select iduser from user where Email='" + email + "';";
                Statement stmt = con.createStatement();
                ResultSet rs = stmt.executeQuery(queryString);
                if (rs.next()) {
                    id = rs.getInt("iduser");
                }

                double sum = 0;
                queryString = "select Suma from conturi where iduser='" + id + "';";
                stmt = con.createStatement();
                rs = stmt.executeQuery(queryString);
                if (rs.next()) {
                    sum = rs.getDouble("Suma");
                }

                String currency = "";
                queryString = "select Valuta from conturi where iduser='" + id + "';";
                stmt = con.createStatement();
                rs = stmt.executeQuery(queryString);
                if (rs.next()) {
                    currency = rs.getString("Valuta");
                }

                rs.close();
                stmt.close();
                con.close();
            %>
            <div class="balance" id="currentBalance"><%= sum %> <%= currency %></div>
        </div>
    </div>

    <script>
        const currentBalance = parseFloat("<%= sum %>");
        const currency = "<%= currency %>";

        function updateBalanceDisplay() {
            const amountElement = document.getElementById('amount');
            const amount = parseFloat(amountElement.value) || 0;
            const updatedBalance = currentBalance - amount;
            const balanceDisplay = document.getElementById('currentBalance');
            balanceDisplay.textContent = updatedBalance.toFixed(2) + ' ' + currency;
        }

        // Initialize balance display with the current balance
        document.getElementById('currentBalance').textContent = currentBalance.toFixed(2) + ' ' + currency;
    </script>
</body>
</html>
