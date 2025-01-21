<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page language="java" import="java.lang.*,java.math.*,db.*,java.sql.*, java.io.*, java.util.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
 <head>
  
 <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
 
 <style>
        /* Overlay */
        .overlay {
            display: none;
            position: fixed;
            top: 0;
            left: 0; 
            width: 100%;
            height: 100%;
            background-color: rgba(0, 0, 0, 0.5);
            z-index: 1000;
        } 

        /* Alert Box */
        .alert-box {
            position: fixed;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            background-color: #fff;
            padding: 20px;
            border-radius: 5px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.3);
            z-index: 1001;
        }

        .alert-box h2 {
            margin-top: 0;
        }

        .alert-box p {
            margin: 10px 0;
        }

        .alert-box button {
            padding: 10px 20px;
            background-color: #007bff;
            border: none;
            border-radius: 3px;
            color: #fff;
            cursor: pointer;
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
	con = DriverManager.getConnection("jdbc:mysql://localhost:3306/ebanking?useSSL=false", "root", "Berberita@10");			
 
	
 	String user = request.getParameter("username");
 	String pass = request.getParameter("password");
 	 
 	session.setAttribute("username", user);
    session.setAttribute("password", pass);
 	
 	String queryString = ("select iduser from `ebanking`.`user` where Email='" + user + "' and Parola='" + pass + "';");
	Statement stmt = con.createStatement(/*ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY*/);
	ResultSet rs = stmt.executeQuery(queryString);
	
	session.setAttribute("email", user);
	
	if(rs.next()){
		String username = request.getParameter("username");
		int x = rs.getInt("iduser");
		out.println("<script type=\"text/javascript\">");
 	    //out.println("alert('Succesfully loged in');");
 	    out.println("location='homepage.jsp?username=" + username + "';"); // Redirect to another JSP
 	    out.println("</script>");
	}
	else{
		out.println("<script type=\"text/javascript\">");
 	    //out.println("alert('Invalid username or password');");
 	    /* out.println("var loginErrorMsg = document.getElementById(\"login-error-msg\");");
 	    out.println("loginErrorMsg.style.opacity = 1;");*/
 	    out.println("location='index2.html';"); // Redirect to another JSP
 	    out.println("</script>");
	}
	
 	rs.close();
	jb.disconnect();
%>
 
 </body>
</html>