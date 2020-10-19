package com.spring.service;


import java.util.HashMap;

import com.spring.model.MemberVO;

public interface InterMovieService {

	String idDuplicateCheck(String userid); // 아이디 중복검사

	int registerMember(MemberVO mvo); // 회원가입

	MemberVO getLoginMember(HashMap<String, String> paraMap); // 로그인하기

	

}
