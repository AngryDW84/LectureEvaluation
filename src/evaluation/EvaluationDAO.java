package evaluation;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

import util.DatabaseUtil;

public class EvaluationDAO {

	public int write(EvaluationDTO evaluationDTO) {
		
		String SQL = "INSERT INTO EVALUATION VALUES (NULL,?,?,?,?,?,?,?,?,?,?,?,?,0)" ; 
		Connection conn = null ; 
		PreparedStatement pstmt = null ; 
		ResultSet rs = null  ;
		
		try {
			System.out.println("로그+++++++++++1");
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
			System.out.println("로그+++++++++++2");
			return pstmt.executeUpdate() ;  // 정상  1 
			
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			try {  if(conn != null) conn.close(); } catch (Exception e) { e.getMessage() ; }
			try {  if(pstmt != null) pstmt.close(); } catch (Exception e) { e.getMessage() ; }
			try {  if(rs != null) rs.close(); } catch (Exception e) { e.getMessage() ; }
		}
		System.out.println("로그+++++++++++3");
		return  -1 ;  // 테이터 오류
	}
	
	public ArrayList<EvaluationDTO> getList( String lectureDivide, String searchType, String search, int pageNumber){
		if(lectureDivide.equals("전체")) {
			lectureDivide ="" ; 
			}
		ArrayList<EvaluationDTO> evaluationList = null ;
		String SQL = "" ; 
		Connection conn = null ; 
		PreparedStatement pstmt = null ; 
		ResultSet rs = null  ;
		
		try {
			if(searchType.equals("최신순")) {
				SQL = "SELECT * FROM EVALUATION WHERE lectureDivide LIKE ? AND CONCAT(lectureName, professorName, evaluationTitle, evaluationContent) LIKE 	? "
								+ "ORDER BY evaluationID DESC LIMIT " + pageNumber* 5+ ", " + pageNumber * 5 + 6 ;
			} else if(searchType.equals("추천순")) {
				SQL = "SELECT * FROM EVALUATION WHERE lectureDivide LIKE ? AND CONCAT(lectureName, professorName, evaluationTitle, evaluationContent) LIKE 	? "
						+ "ORDER BY likeCount DESC LIMIT " + pageNumber* 5+ ", " + pageNumber * 5 + 6 ;
			}
			conn = DatabaseUtil.getConnection() ; 
			pstmt = conn.prepareStatement(SQL) ; 
			pstmt.setString(1, "%" + lectureDivide + "%");
			pstmt.setString(2, "%" + search + "%");
//			pstmt.setString(2, userPassword);
			rs = pstmt.executeQuery() ;
			evaluationList = new ArrayList<EvaluationDTO>() ;

			
			while(rs.next()) {
				EvaluationDTO evaluation = new EvaluationDTO(
						rs.getInt(1),
						rs.getString(2),
						rs.getString(3),
						rs.getString(4),
						rs.getInt(5),
						rs.getString(6),
						rs.getString(7),
						rs.getString(8),
						rs.getString(9),
						rs.getString(10),
						rs.getString(11),
						rs.getString(12),
						rs.getString(13),
						rs.getInt(14)
						) ;  
					evaluationList.add(evaluation) ;
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			try {  if(conn != null) conn.close(); } catch (Exception e) { e.getMessage() ; }
			try {  if(pstmt != null) pstmt.close(); } catch (Exception e) { e.getMessage() ; }
			try {  if(rs != null) rs.close(); } catch (Exception e) { e.getMessage() ; }
		}
		return  evaluationList ; 
	}
}


