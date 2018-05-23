package user;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import util.DatabaseUtil;

public class UserDAO {

	public int login(String userID, String userPassword) {
		
		String SQL = "SELECT userPassword FROM USER WHERE userID = ? " ; 
		Connection conn = null ; 
		PreparedStatement pstmt = null ; 
		ResultSet rs = null  ;
		
		try {
			conn = DatabaseUtil.getConnection() ; 
			pstmt = conn.prepareStatement(SQL) ; 
			pstmt = setString(1,userID) ; 
			rs = pstmt.executeQuery() ;
			if(rs.next()) {
//				if(rs.getString(1.equal))
//					5:53 초 
//					https://www.youtube.com/watch?v=M15CzVxTMgA&index=8&list=PLRx0vPvlEmdAdWCQeUPnyMZ4PsW3dGuFB
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
}
