package com.spring.service;

import java.util.HashMap;
import java.util.List;

import com.spring.model.MemberVO;
import com.spring.model.attachVO;
import com.spring.model.postVO;

public interface InterMovieService {

	String idDuplicateCheck(String userid); // 아이디 중복검사

	int registerMember(MemberVO mvo); // 회원가입

	MemberVO getLoginMember(HashMap<String, String> paraMap); // 로그인하기

	List<postVO> getFreeboardList(HashMap<String, String> paraMap); // 자유게시판 가져오기

	int addfreeboard(postVO postvo); // 자유게시판 글쓰기

	postVO getFreeboardView(HashMap<String, String> paraMap); // 자유게시판 상세보기

	int getFreeTotalCount(HashMap<String, String> paraMap); // 자유게시판 총 게시물 개수

	postVO getFreeboardView_cnt(HashMap<String, String> paraMap); // 자유게시판 상세보기+조회수

}
