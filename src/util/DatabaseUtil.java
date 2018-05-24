package util;

import java.sql.Connection;
import java.sql.DriverManager;

public class DatabaseUtil {

	public static Connection getConnection()  {
		try {
			String dbURL = "jdbc:mysql://localhost:3306/lectureevaluation" ;
			String dbID = "root" ;
			String dbPassword = "root" ;
			Class.forName("com.mysql.jdbc.Driver") ;
			return DriverManager.getConnection(dbURL, dbID, dbPassword) ;
		} catch (Exception e) {
			// TODO: handle exception
			System.out.println("LOG+++++++eeeee");
			e.printStackTrace(); 
		}
		return null ; 
	}
}
