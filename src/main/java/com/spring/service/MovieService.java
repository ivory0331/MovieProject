package com.spring.service;

import java.util.HashMap;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.spring.model.InterMovieDAO;
import com.spring.model.MemberVO;

//=== #31. Service 선언 ===
@Service
public class MovieService implements InterMovieService {

	// === #34. 의존객체 주입하기(DI: Dependency Injection) ===
	@Autowired
	private InterMovieDAO dao;

	// 아이디 중복검사
	@Override
	public String idDuplicateCheck(String userid) {
		String n = dao.idDuplicateCheck(userid);
		return n;
	}
	// 회원가입
	@Override
	public int registerMember(MemberVO mvo) {
		int n = dao.registerMember(mvo);
		return n;
	}
	// 로그인하기
	@Override
	public MemberVO getLoginMember(HashMap<String, String> paraMap) {
		MemberVO loginuser = dao.getLoginMember(paraMap);
		
		// === #48. aes 의존객체를 사용하여 로그인 되어진 사용자(loginuser)의 이메일 값을 복호화 하도록 한다. ===
		if(loginuser != null) {
			
			if(loginuser.getLastlogindategap() >= 12) {
			// 마지막으로 로그인 한 날짜시간이 현재시각으로 부터 1년이 지났으면 해당 로그인 계정을 비활성화(휴면)시킨다.
				loginuser.setIdleStatus(true);
			}
			else {
				if(loginuser.getPwdchangegap() > 3) {
					// 마지막으로 암호를 변경한 날짜가 현재시각으로 부터 3개월이 지났으면
					loginuser.setRequirePwdChange(true);
				}
				
			//	dao.setLastLoginDate(paraMap); // 마지막으로 로그인 한 날짜시간 변경(기록)하기
				
			/*try { 
				loginuser.setEmail(aes.decrypt(loginuser.getEmail()));
				// loginuser의 email을 복호화 하도록 한다.
			} catch (UnsupportedEncodingException | GeneralSecurityException e) {
				e.printStackTrace();
			} */
			}
		}
		
		return loginuser;
	}
	
	
	
	
	
}
