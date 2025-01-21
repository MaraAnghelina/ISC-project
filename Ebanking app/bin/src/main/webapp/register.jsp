<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page language="java" import="java.lang.*,java.math.*,db.*,java.sql.*, java.io.*, java.util.*"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Register</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #2b2b2b; /* Dark background color */
            margin: 0;
            padding: 0;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
        }  
        .container {
            background-color: #353535; /* Darker container background color */
            padding: 20px;
            border-radius: 5px;
            box-shadow: 0 0 10px rgba(255, 255, 255, 0.1); /* Lighter box shadow */
            width: 550px;
        }
        input[type="text"], input[type="password"], input[type="submit"] {
            width: 90%;
            padding: 10px;
            margin: 8px 10px;
            display: inline-block;
            border: 1px solid #444; /* Darker border color */
            border-radius: 4px;
            box-sizing: border-box;
            color: #eee; /* Light font color */
            background-color: #444; /* Darker background color for inputs */
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
            color: #eee; /* Light font color for labels */
        }
        label {
            color: #eee; /* Light font color for labels */
        }
        .error-icon {
            position: absolute;
            top: 74.5%;
            right: 590px;
            transform: translateY(-50%);
            color: #ff3333; /* Red color for the error icon */
            cursor: pointer;
            display: none; /* Initially hide the error icon */
            font-size: 24px;
        }
    </style>
</head>

<jsp:useBean id="jb" scope="session" class="db.JavaBean" />
<jsp:setProperty name="jb" property="*" />

<body>

	<%
		String error;
		Connection con;
	 	
		Class.forName("com.mysql.cj.jdbc.Driver");
		con = DriverManager.getConnection("jdbc:mysql://localhost:3306/ebanking?useSSL=false&allowPublicKeyRetrieval=true", "root", "Trompisor*2002*");
		
		String name = request.getParameter("name");
		String surname = request.getParameter("surname");
		String username = request.getParameter("username");
		String currency = request.getParameter("currency");
		String cont = request.getParameter("cont");
		String pass = request.getParameter("password");
		String confirmPass = request.getParameter("confirm-password");
		
		
		
		/*if(confirmPass != pass){
			out.println("<script type=\"text/javascript\">");
	 	    out.println("alert('The passwords do not match');");
	 	    out.println("location='register.jsp';"); // Redirect to another JSP
	 	    out.println("</script>");
		}else{*/
		
			if(name != null && surname != null && username != null && cont != null && pass != null && confirmPass != null ){
				jb.connect();
				jb.addUser(username, pass);
				ResultSet rs = jb.findUser(username, pass); 
				rs.next();
				int iduser = rs.getInt("iduser");
				jb.addCont(name, surname, cont, currency, iduser);
				rs.close();
				jb.disconnect();
				
				out.println("<script type=\"text/javascript\">");
		 	    out.println("alert('Succesfully created an account');");
		 	    out.println("location='index.html';"); // Redirect to another JSP
		 	    out.println("</script>");
			} else {
	%>

    <div class="container">
        <h2 style="color: #eee;">Register</h2> <!-- Light font color for heading -->
        <form action="register.jsp" method="post">
            <label for="name">Name</label> <br>
            <input type="text" id="name" name="name" placeholder="Your name" required><br>

            <label for="surname">Surname</label><br>
            <input type="text" id="surname" name="surname" placeholder="Your surname" required><br>
            
            <label for="username">Userame</label><br>
            <input type="text" id="username" name="username" placeholder="Choose a username" required><br>
            
            <label for="cont">Cont No.</label><br>
            <input type="text" id="cont" name="cont" placeholder="Your IBAN" required><br>
            
            <label for="currency">Currency</label><br>
            <input type="text" id="currency" name="currency" placeholder="Choose your currency" required><br>
            
            <label for="password">Password</label><br>
            <input type="password" id="password" name="password" placeholder="Choose a password" required><br>

            <label for="confirm-password">Confirm Password</label><br>
            <input type="password" id="confirm-password" name="confirm-password" placeholder="Confirm your password" required onkeyup="checkPasswordMatch()">
            <span class="error-icon" id="password-match-error">&#10006;</span> <!-- Error icon -->

            <input type="submit" value="Register">
        </form>
    </div>
    
    <%
			}
		//}
    %>
    
    <script>
        function checkPasswordMatch() {
            var password = document.getElementById("password").value;
            var confirmPassword = document.getElementById("confirm-password").value;
            var errorIcon = document.getElementById("password-match-error");

            if (password !== confirmPassword) {
                errorIcon.style.display = "inline-block"; // Display the error icon
            } else {
                errorIcon.style.display = "none"; // Hide the error icon if passwords match
            }
        }
    </script>
    
</body>
</html>
