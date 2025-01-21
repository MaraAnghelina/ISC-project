<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@ page language="java" import="java.lang.*, java.math.*,db.*,java.sql.*, java.io.*, java.util.*"%>
<%@ page import="java.util.Date" %>
<!DOCTYPE html>

<html>
<head>
   
</head> 

<jsp:useBean id="jb" scope="session" class="db.JavaBean" />
<jsp:setProperty name="jb" property="*" />

<body>
	  
	<%
		String email =(String) session.getAttribute("email");
		int id = 0;
		
	    String error;
		Connection con;
	 	
		Class.forName("com.mysql.cj.jdbc.Driver");
		con = DriverManager.getConnection("jdbc:mysql://localhost:3306/ebanking?useSSL=false&allowPublicKeyRetrieval=true", "root", "Berberita@10");
		jb.connect();
		
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
		
		if(request.getParameter("sum") != null){
				double sum = Double.parseDouble(request.getParameter("sum"));
				String date = new Date().toString().substring(0, 10);
				stmt = con.createStatement();
				stmt.executeUpdate("insert into tranzactii(TipTranzactie, Suma, Data, Valuta, iduser) values('" + "withdraw funds" + "' , '" + sum + "', '" + date + "', '" + currency + "', '" + id +"' );");
				stmt = con.createStatement();
				
				double suma = 0;
		    	queryString = ("select Suma from conturi where iduser='" + id + "';");
		    	stmt = con.createStatement(/*ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY*/);
		    	rs = stmt.executeQuery(queryString);
		    	if(rs.next())
		    		suma = rs.getDouble("Suma");
		    	suma = suma - sum;
				
				stmt.executeUpdate("update conturi set Suma = '" + suma + "' where iduser='" + id + "';");
				out.println("<script type=\"text/javascript\">");
		 	    //out.println("alert('Succesfully loged in');");
		 	    out.println("location='qrcode.html';"); // Redirect to another JSP
		 	    out.println("</script>");
				
		}
		if(request.getParameter("amount") != null){
			double sum = Double.parseDouble(request.getParameter("amount"));
			String date = new Date().toString().substring(0, 10);
			stmt = con.createStatement();
			stmt.executeUpdate("insert into tranzactii(TipTranzactie, Suma, Data, Valuta, iduser) values('" + "deposit funds" + "' , '" + sum + "', '" + date + "', '" + currency + "', '" + id +"' );");
			stmt = con.createStatement();
			
			double suma = 0;
	    	queryString = ("select Suma from conturi where iduser='" + id + "';");
	    	stmt = con.createStatement(/*ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY*/);
	    	rs = stmt.executeQuery(queryString);
	    	if(rs.next())
	    		suma = rs.getDouble("Suma");
	    	suma = suma + sum;
			
			stmt.executeUpdate("update conturi set Suma = '" + suma + "' where iduser='" + id + "';");
			out.println("<script type=\"text/javascript\">");
	 	    //out.println("alert('Succesfully loged in');");
	 	    out.println("location='qrcode.html';"); // Redirect to another JSP
	 	    out.println("</script>");
		}
		
		jb.disconnect();
		
    %>

</body>
</html>