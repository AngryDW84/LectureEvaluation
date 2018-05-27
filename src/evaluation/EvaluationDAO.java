package evaluation;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import util.DatabaseUtil;

public class EvaluationDAO {

	public int write(EvaluationDTO evaluationDTO) {
		
		String SQL = "INSERT INTO EVALUATION VALUES (NULL, ?,?,?,?,?,?,?,?,?,?,?,?,0 " ; 
		Connection conn = null ; 
		PreparedStatement pstmt = null ; 
		ResultSet rs = null  ;
		
		try {
			conn = DatabaseUtil.getConnection() ; 
			pstmt = conn.prepareStatement(SQL) ; 
			pstmt.setString(1, evaluationDTO.getUserID());
			pstmt.setString(2, evaluationDTO.getLectureName());
			pstmt.setString(3, evaluationDTO.getProfessorName());
			pstmt.setInt(4, evaluationDTO.getLectureYear());
			pstmt.setString(5, evaluationDTO.getSemesterDivide());
			pstmt.setString(6, evaluationDTO.getLectureDivide());
			pstmt.setString(7, evaluationDTO.getEvaluationTitle());
			pstmt.setString(8, evaluationDTO.getEvaluationContent());
			pstmt.setString(9, evaluationDTO.getCreditScore());
			pstmt.setString(10, evaluationDTO.getComfortableScore());
			pstmt.setString(11, evaluationDTO.getLectureScore());
			pstmt.setString(12, evaluationDTO.getTotalScore());
			return pstmt.executeUpdate() ;  // 정상  1 
                
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			try {  if(conn != null) conn.close(); } catch (Exception e) { e.getMessage() ; }
			try {  if(pstmt != null) pstmt.close(); } catch (Exception e) { e.getMessage() ; }
			try {  if(rs != null) rs.close(); } catch (Exception e) { e.getMessage() ; }
		}
		return  -1 ;  // 테이터 오류
	}
	
}


