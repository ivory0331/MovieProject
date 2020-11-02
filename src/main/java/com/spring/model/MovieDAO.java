package com.spring.model;

import java.util.HashMap;
import java.util.List;

import javax.annotation.Resource;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.stereotype.Repository;

//=== #32. DAO 선언 ===
@Repository
public class MovieDAO implements InterMovieDAO {

	@Resource
	private SqlSessionTemplate sqlsession;

	// 아이디 중복검사
	@Override
	public String idDuplicateCheck(String userid) {
		String n = sqlsession.selectOne("movie.idDuplicateCheck", userid);
		return n;
	}
	// 회원가입
	@Override
	public int registerMember(MemberVO mvo) {
		int n = sqlsession.insert("movie.registerMember", mvo);
		return n;
	}
	// 로그인하기
	@Override
	public MemberVO getLoginMember(HashMap<String, String> paraMap) {
		MemberVO loginuser = sqlsession.selectOne("movie.getLoginMember", paraMap);
		return loginuser;
	}
	// 자유게시판 목록 가져오기
	@Override
	public List<postVO> getFreeboardList(HashMap<String, String> paraMap) {
		List<postVO> freeboardList = sqlsession.selectList("movie.getFreeboardList", paraMap);
		return freeboardList;
	}
	// 자유게시판 글쓰기
	@Override
	public int addfreeboard(postVO postvo) {
		int n = sqlsession.insert("movie.addfreeboard", postvo);
		return n;
	}
	// 자유게시판 상세보기
	@Override
	public postVO getFreeboardView(HashMap<String, String> paraMap) {
		postVO freeboardView = sqlsession.selectOne("movie.getFreeboardView", paraMap);
		return freeboardView;
	}
	// 자유게시판 총 게시물 개수
	@Override
	public int getFreeTotalCount(HashMap<String, String> paraMap) {
		int freeTotalCount = sqlsession.selectOne("movie.getFreeTotalCount", paraMap);
		return freeTotalCount;
	}
	// 조회수 1 증가시키기
	@Override
	public void addViewCount(HashMap<String, String> paraMap) {
		sqlsession.update("movie.addViewCnt", paraMap);
	}
	// 글 수정하기(update)
	@Override
	public int editfreeboard(postVO postvo) {
		int n = sqlsession.update("movie.editfreeboard", postvo);
		return n;
	}
	// 글 삭제하기(update)
	@Override
	public int delfreeboard(String post_seq) {
		int n = sqlsession.update("movie.delfreeboard", post_seq);
		return n;
	}
	// 댓글작성하기
	@Override
	public int addComment(cmtVO cmtvo) {
		int n = sqlsession.insert("movie.addComment", cmtvo);
		return n;
	}
	// 댓글 불러오기
	@Override
	public List<cmtVO> commentList(HashMap<String, String> paraMap) {
		List<cmtVO> commentList = sqlsession.selectList("movie.getCommentList", paraMap);
		return commentList;
	}
	// 댓글 총 개수
	@Override
	public int getCommentTotalCount(String post_seq) {
		int n = sqlsession.selectOne("movie.getCommentTotalCount", post_seq);
		return n;
	}
	// 댓글 삭제하기
	@Override
	public int delComment(String cmt_seq) {
		int n = sqlsession.update("movie.delComment", cmt_seq);
		return n;
	}
	
	
}
