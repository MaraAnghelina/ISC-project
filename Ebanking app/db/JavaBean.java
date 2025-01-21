package db;

import java.sql.*;
 
//import com.mysql.cj.x.protobuf.MysqlxDatatypes.Scalar.String;

public class JavaBean  {

	String error;
	Connection con;
 
	public JavaBean() {
	}

	public void connect() throws ClassNotFoundException, SQLException, Exception {
		try {  
			Class.forName("com.mysql.cj.jdbc.Driver");
			// con = DriverManager.getConnection("jdbc:mysql://localhost:3306/spital?user=root&password=ValentinPupezescu2021;");
			con = DriverManager.getConnection("jdbc:mysql://localhost:3306/ebanking?useSSL=false", "root", "Berberita@10");			

			// daca sunt probleme la conectare se poate incerca conexiunea in forma urmatoare:
            // con = DriverManager.getConnection("jdbc:mysql://localhost:3306/test3?useSSL=false?useUnicode=true&useJDBCCompliantTimezoneShift=true&useLegacyDatetimeCode=false&serverTimezone=UTC", "root", "ValentinPupezescu2021;");
		} catch (ClassNotFoundException cnfe) {
			error = "ClassNotFoundException: Nu s-a gasit driverul bazei de date.";
			throw new ClassNotFoundException(error);
		} catch (SQLException cnfe) {
			error = "SQLException: Nu se poate conecta la baza de date.";
			throw new SQLException(error);
		} catch (Exception e) {
			error = "Exception: A aparut o exceptie neprevazuta in timp ce se stabilea legatura la baza de date.";
			throw new Exception(error);
		}
	} // connect()

	public void connect(String bd) throws ClassNotFoundException, SQLException, Exception {
		try {
			Class.forName("com.mysql.cj.jdbc.Driver");
			con = DriverManager.getConnection("jdbc:mysql://localhost:3306/" + bd, "root", "Berberita@10");
		} catch (ClassNotFoundException cnfe) {
			error = "ClassNotFoundException: Nu s-a gasit driverul bazei de date.";
			throw new ClassNotFoundException(error);
		} catch (SQLException cnfe) {
			error = "SQLException: Nu se poate conecta la baza de date.";
			throw new SQLException(error);
		} catch (Exception e) {
			error = "Exception: A aparut o exceptie neprevazuta in timp ce se stabilea legatura la baza de date.";
			throw new Exception(error);
		}
	} // connect(String bd)

	public void connect(String bd, String ip) throws ClassNotFoundException, SQLException, Exception {
		try {
			Class.forName("com.mysql.cj.jdbc.Driver");
			con = DriverManager.getConnection("jdbc:mysql://" + ip + ":3306/" + bd, "root", "Berberita@10");
		} catch (ClassNotFoundException cnfe) {
			error = "ClassNotFoundException: Nu s-a gasit driverul bazei de date.";
			throw new ClassNotFoundException(error);
		} catch (SQLException cnfe) {
			error = "SQLException: Nu se poate conecta la baza de date.";
			throw new SQLException(error);
		} catch (Exception e) {
			error = "Exception: A aparut o exceptie neprevazuta in timp ce se stabilea legatura la baza de date.";
			throw new Exception(error);
		}
	} // connect(String bd, String ip)

	public void disconnect() throws SQLException {
		try {
			if (con != null) {
				con.close();
			}
		} catch (SQLException sqle) {
			error = ("SQLException: Nu se poate inchide conexiunea la baza de date.");
			throw new SQLException(error);
		}
	} // disconnect()
	
	public ResultSet findUser(String user, String pass) throws SQLException, Exception{
		ResultSet rs = null;
		try {
			String queryString = ("select iduser from `ebanking`.`user` where Email='" + user + "' and Parola='" + pass + "';");
			Statement stmt = con.createStatement(/*ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY*/);
			rs = stmt.executeQuery(queryString);
		}catch (SQLException sqle) {
			error = "SQLException: Interogarea nu a fost posibila.";
			throw new SQLException(error);
		} catch (Exception e) {
			error = "A aparut o exceptie in timp ce se extrageau datele.";
			throw new Exception(error);
		}
		return rs;
	}
	
	/*public ResultSet vedeAdvocates() throws SQLException, Exception {
		ResultSet rs = null;
		try {
			String queryString = ("select * from `proiect`.`advocates`;");
			Statement stmt = con.createStatement(/*ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
			rs = stmt.executeQuery(queryString);
		} catch (SQLException sqle) {
			error = "SQLException: Interogarea nu a fost posibila.";
			throw new SQLException(error);
		} catch (Exception e) {
			error = "A aparut o exceptie in timp ce se extrageau datele.";
			throw new Exception(error);
		}
		return rs;
	}
	public ResultSet vedeClient() throws SQLException, Exception {
		ResultSet rs = null;
		try {
			String queryString = ("select * from `proiect`.`clients`;");
			Statement stmt = con.createStatement(/*ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
			rs = stmt.executeQuery(queryString);
		} catch (SQLException sqle) {
			error = "SQLException: Interogarea nu a fost posibila.";
			throw new SQLException(error);
		} catch (Exception e) {
			error = "A aparut o exceptie in timp ce se extrageau datele.";
			throw new Exception(error);
		}
		return rs;
	}
	public ResultSet vedeFolder() throws SQLException, Exception {
		ResultSet rs = null;
		try {
			String queryString = ("select * from `proiect`.`folder`;");
			//String queryString = ("select a.Nume NumePacient, a.Prenume PrenumePacient, a.Adresa, b.Nume NumeMedic, b.Prenume PrenumeMedic, b.Sectie, c.idconsultatie, c.idmedic idmedic_consult, c.idpacient idpacient_consult, c.DataConsultatie, c.Diagnostic, c.Medicament from pacienti a, medici b, consultatie c where a.idpacient = c.idpacient and b.idmedic = c.idmedic;");
			Statement stmt = con.createStatement(/*ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
			rs = stmt.executeQuery(queryString);
		} catch (SQLException sqle) {
			error = "SQLException: Interogarea nu a fost posibila.";
			throw new SQLException(error);
		} catch (Exception e) {
			error = "A aparut o exceptie in timp ce se extrageau datele.";
			throw new Exception(error);
		}
		return rs;
	}
	public ResultSet vedeFolderComplex() throws SQLException, Exception {
		ResultSet rs = null;
		try {
			//String queryString = ("select * from `proiect`.`folder`;");
			String queryString = ("select a.Name ClientName, a.Surname ClientSurname, a.Criminal_record, b.Name AdvocateName, b.Surname AdvocateSurname, b.Type, c.idfolder, c.idadvocate idadvocate_folder, c.idclient idclient_folder, c.Name, c.Period, c.State from clients a, advocates b, folder c where a.idclient = c.idclient and b.idadvocate = c.idadvocate;");
			Statement stmt = con.createStatement(/*ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
			rs = stmt.executeQuery(queryString);
		} catch (SQLException sqle) {
			error = "SQLException: Interogarea nu a fost posibila.";
			throw new SQLException(error);
		} catch (Exception e) {
			error = "A aparut o exceptie in timp ce se extrageau datele.";
			throw new Exception(error);
		}
		return rs;
	}*/
	
	public void addUser(String user, String pass)
			throws SQLException, Exception {
		if (con != null) {
			try {
				// create a prepared SQL statement
				Statement stmt;
				stmt = con.createStatement();
				stmt.executeUpdate("insert into user(Email, Parola) values('" + user + "'  , '" + pass + "');");

			} catch (SQLException sqle) {
				error = "ExceptieSQL: Reactualizare nereusita; este posibil sa existe duplicate.";
				throw new SQLException(error);
			}
		} else {
			error = "Exceptie: Conexiunea cu baza de date a fost pierduta.";
			throw new Exception(error);
		}
	}
	public void addCont(String name, String surname, String cont, String currency, int iduser)
			throws SQLException, Exception {
		if (con != null) {
			try {
				// create a prepared SQL statement
				Statement stmt;
				stmt = con.createStatement();
				stmt.executeUpdate("insert into conturi(Nume, Prenume, NrCont, Valuta, iduser) values('" + name + "'  , '" + surname + "', '" + cont + "', '" + currency + "', '" + iduser + "');");

			} catch (SQLException sqle) {
				error = "ExceptieSQL: Reactualizare nereusita; este posibil sa existe duplicate.";
				throw new SQLException(error);
			}
		} else {
			error = "Exceptie: Conexiunea cu baza de date a fost pierduta.";
			throw new Exception(error);
		}
	}
	public void addTransactions(String type, double sum, String date, String currency)
			throws SQLException, Exception {
		if (con != null) {
			try {
				// create a prepared SQL statement
				Statement stmt;
				stmt = con.createStatement();
				stmt.executeUpdate("insert into tranzactii(TipTranzactie, Suma, Data, Valuta) values('" + type + "' , '" + sum + "', '" + date + "', '" + currency + "');");

			} catch (SQLException sqle) {
				error = "ExceptieSQL: Reactualizare nereusita; este posibil sa existe duplicate.";
				throw new SQLException(error);
			}
		} else {
			error = "Exceptie: Conexiunea cu baza de date a fost pierduta.";
			throw new Exception(error);
		}
	}
		
	/*public void stergeDateTabela(String[] primaryKeys, String tabela, String dupaID) throws SQLException, Exception {
			if (con != null) {
				try {
					// create a prepared SQL statement
					long aux;
					PreparedStatement delete;
					delete = con.prepareStatement("DELETE FROM " + tabela + " WHERE " + dupaID + "=?;");
					for (int i = 0; i < primaryKeys.length; i++) {
						aux = java.lang.Long.parseLong(primaryKeys[i]);
						delete.setLong(1, aux);
						delete.execute();
					}
				} catch (SQLException sqle) {
					error = "ExceptieSQL: Reactualizare nereusita; este posibil sa existe duplicate.";
					throw new SQLException(error);
				} catch (Exception e) {
					error = "A aparut o exceptie in timp ce erau sterse inregistrarile.";
					throw new Exception(error);
				}
			} else {
				error = "Exceptie: Conexiunea cu baza de date a fost pierduta.";
				throw new Exception(error);
			}			
	}*/
	
	/*public void modificaTabela(String tabela, String IDTabela, int ID, String[] campuri, String[] valori) throws SQLException, Exception {
		String update = "update " + tabela + " set ";
		String temp = "";
		if (con != null) {
			try {
				for (int i = 0; i < campuri.length; i++) {
					if (i != (campuri.length - 1)) {
						temp = temp + campuri[i] + "='" + valori[i] + "', ";
					} else {
						temp = temp + campuri[i] + "='" + valori[i] + "' where " + IDTabela + " = '" + ID + "';";
					}
				}
				update = update + temp;
				// create a prepared SQL statement
				Statement stmt;
				stmt = con.createStatement();
				stmt.executeUpdate(update);
			} catch (SQLException sqle) {
				error = "ExceptieSQL: Reactualizare nereusita; este posibil sa existe duplicate.";
				throw new SQLException(error);
			}
		} else {
			error = "Exceptie: Conexiunea cu baza de date a fost pierduta.";
			throw new Exception(error);
		}
	}
	public ResultSet intoarceLinieDupaId(String tabela, String denumireId, int ID) throws SQLException, Exception {
		ResultSet rs = null;
		try {
			// Execute query
			String queryString = ("SELECT * FROM " + tabela + " where " + denumireId + "=" + ID + ";");
			Statement stmt = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
			rs = stmt.executeQuery(queryString); //sql exception
		} catch (SQLException sqle) {
			error = "SQLException: Interogarea nu a fost posibila.";
			throw new SQLException(error);
		} catch (Exception e) {
			error = "A aparut o exceptie in timp ce se extrageau datele.";
			throw new Exception(error);
		}
		return rs;
	}*/
	
	public String findUserNameById(int userId) throws SQLException, Exception {
	    String userName = null;
	    ResultSet rs = null;
	    try {
	        String queryString = "SELECT nume FROM `ebanking`.`user` WHERE iduser=userId";
	        PreparedStatement pstmt = con.prepareStatement(queryString);
	        pstmt.setInt(1, userId);
	        rs = pstmt.executeQuery();
	        if (rs.next()) {
	            userName = rs.getString("nume");
	        }
	    } catch (SQLException sqle) {
	        error = "SQLException: Interogarea nu a fost posibila.";
	        throw new SQLException(error);
	    } catch (Exception e) {
	        error = "A aparut o exceptie in timp ce se extrageau datele.";
	        throw new Exception(error);
	    } finally {
	        if (rs != null) {
	            rs.close();
	        }
	    }
	    return userName;
	}

}
