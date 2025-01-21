<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page language="java" import="java.lang.*,java.math.*,db.*,java.sql.*, java.io.*, java.util.*"%>

<!DOCTYPE html>
<html>
<head>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Change Password</title>
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
            width: 50%;
            text-align: center;
        }

        .container h2 {
            color: #eee;
        }

        .container form {
            display: flex;
            flex-direction: column;
            gap: 10px;
        }

        .container input[type="password"], .container input[type="submit"] {
            padding: 10px;
            border: none;
            border-radius: 4px;
            box-sizing: border-box;
        }

        .container input[type="password"] {
            background-color: #fff;
            color: #000;
        }

        .container input[type="submit"] {
            color: white;
            background-color: #483D8B;
            cursor: pointer;
            transition: background-color 0.3s;
        }

        .container input[type="submit"]:hover {
            background-color: #4682B4;
        }
    </style>
</head>
<body>
    <div class="container">
        <h2>Change Password</h2>
        
        <%
        	String email =(String) session.getAttribute("email");
            String currentPassword = request.getParameter("currentPassword");
            String newPassword = request.getParameter("newPassword");
            String confirmNewPassword = request.getParameter("confirmNewPassword");
            String message = null;

            if (currentPassword != null && newPassword != null && confirmNewPassword != null) {
                if (newPassword.equals(confirmNewPassword)) {
                    try (Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/ebanking?useSSL=false", "root", "Trompisor*2002*")) {
                        PreparedStatement ps = con.prepareStatement("SELECT Parola FROM user WHERE Email = ?");
                        ps.setString(1, email);
                        ResultSet rs = ps.executeQuery();
                        if (rs.next()) {
                            String dbPassword = rs.getString("parola");
                            if (dbPassword.equals(currentPassword)) {
                                PreparedStatement psUpdate = con.prepareStatement("UPDATE user SET parola = ? WHERE email = ?");
                                psUpdate.setString(1, newPassword);
                                psUpdate.setString(2, email);
                                int rowsUpdated = psUpdate.executeUpdate();
                                if (rowsUpdated > 0) {
                                    message = "Password changed successfully!";
                                } else {
                                    message = "Error changing password.";
                                }
                            } else {
                                message = "Incorrect current password.";
                            }
                        }
                    } catch (Exception e) {
                        e.printStackTrace();
                        message = "An error occurred: " + e.getMessage();
                    }
                } else {
                    message = "Passwords do not match.";
                }
            }
        %>
        
        <form method="post">
            <input type="hidden" name="email" value="<%= email %>">
            <input type="password" name="currentPassword" placeholder="Current Password" required>
            <input type="password" name="newPassword" placeholder="New Password" required>
            <input type="password" name="confirmNewPassword" placeholder="Confirm New Password" required>
            <input type="submit" value="Change Password">
        </form>
        
        <% if (message != null) { %>
            <p style="color: #eee;"><%= message %></p>
        <% } %>
    </div>
</body>
</html>
