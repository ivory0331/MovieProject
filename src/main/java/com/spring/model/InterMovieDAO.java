package com.spring.model;

import java.util.HashMap;
import java.util.List;

public interface InterMovieDAO {

	String idDuplicateCheck(String userid); // 아이디 중복검사

	int registerMember(MemberVO mvo); // 회원가입

	MemberVO getLoginMember(HashMap<String, String> paraMap); // 로그인하기

	List<postVO> getFreeboardList(HashMap<String, String> paraMap); // 자유게시판 목록 가져오기

	int addfreeboard(postVO postvo); // 자유게시판 글쓰기

	postVO getFreeboardView(HashMap<String, String> paraMap); // 자유게시판 상세보기

	int getFreeTotalCount(HashMap<String, String> paraMap); // 자유게시판 총 게시물 개수

	void addViewCount(HashMap<String, String> paraMap); // 조회수 1 증가시키기

	int editfreeboard(postVO postvo); // 글 수정하기(update)

	int delfreeboard(String post_seq); // 글 삭제하기(update)

	int addComment(cmtVO cmtvo); // 댓글작성하기

	List<cmtVO> commentList(HashMap<String, String> paraMap); // 댓글 불러오기

	int getCommentTotalCount(String post_seq); // 댓글 총 개수

	int delComment(String cmt_seq); // 댓글 삭제하기

	
}
