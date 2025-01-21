package com.ebanking.scheduler.jobs;
import org.quartz.Job;

import org.quartz.JobExecutionContext;
import org.quartz.JobExecutionException;
import java.sql.*;
import java.util.Date;

public class LoanPaymentJob implements Job {
    @Override
    public void execute(JobExecutionContext context) throws JobExecutionException {
    	
    	  System.out.println("Loan payment job executed at: " + new Date());
    	
        Connection conn = null;
        Statement stmt = null;
        ResultSet rs = null;

        try {
            // Load JDBC driver
            Class.forName("com.mysql.cj.jdbc.Driver");
            // Establish connection
            conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/ebanking?useSSL=false", "root", "Berberita@10");

            // Query to find all active loans
            String sql = "SELECT * FROM imprumuturi WHERE Perioada > 0";
            stmt = conn.createStatement();
            rs = stmt.executeQuery(sql);

            while (rs.next()) {
                int loanId = rs.getInt("idimprumuturi");
                double monthlyPayment = rs.getDouble("PlataLunara");
                int userId = rs.getInt("iduser");
                String currency = rs.getString("Valuta");

                // Deduct monthly payment from user's account balance
                String updateBalanceSql = "UPDATE conturi SET Suma = Suma - ? WHERE iduser = ?";
                try (PreparedStatement pstmt = conn.prepareStatement(updateBalanceSql)) {
                    pstmt.setDouble(1, monthlyPayment);
                    pstmt.setInt(2, userId);
                    pstmt.executeUpdate();
                }
                
                
                double suma=0;
                String queryStringg = ("select Suma from conturi where iduser='" + userId + "';");
    	    	rs = stmt.executeQuery(queryStringg);
    	    	if(rs.next())
    	    	 suma = rs.getDouble("Suma");
                
                String date = new Date().toString().substring(0, 10);
                stmt = conn.createStatement();
                stmt.executeUpdate("insert into tranzactii(TipTranzactie, Suma, Data, Valuta, iduser) values('" + "loan payment" + "' , '" + suma + "', '" + date + "', '" + currency + "', '" + userId + "' );");
                stmt = conn.createStatement();

                // Decrement loan period
                String updateLoanSql = "UPDATE imprumuturi SET Perioada = Perioada - 1 WHERE idimprumuturi = ?";
                try (PreparedStatement pstmt = conn.prepareStatement(updateLoanSql)) {
                    pstmt.setInt(1, loanId);
                    pstmt.executeUpdate();
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (rs != null) try { rs.close(); } catch (SQLException e) {}
            if (stmt != null) try { stmt.close(); } catch (SQLException e) {}
            if (conn != null) try { conn.close(); } catch (SQLException e) {}
        }
    }
}