package com.spring.controller;

import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.util.*;

import javax.servlet.http.*;

import org.json.JSONArray;
import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.*;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.ModelAndView;

import com.spring.common.FileManager;
import com.spring.model.*;
import com.spring.service.InterMovieService;

//=== #30. 컨트롤러 선언 ===
@Component
@Controller
public class MovieController {
	
	@Autowired // Type에 따라 알아서 Bean을 주입해준다.
	private InterMovieService service;
	
	// ===== #150. 파일업로드 및 다운로드를 해주는  FileManager 클래스 의존객체 주입하기(DI:Dependency Injection)  =====
	@Autowired // Type에 따라 알아서 Bean을 주입해준다.
	private FileManager fileManager; 
	
	// 메인페이지
	@RequestMapping(value="/index.mv")
	public ModelAndView index(ModelAndView mav) {
		
		mav.setViewName("main/index.tiles1");
		
		return mav;
	}
	
	// 검색창 페이지
	@RequestMapping(value="/searchIndex.mv")
	public ModelAndView searchIndex(ModelAndView mav) {
		
		mav.setViewName("main/search.tiles1");
		
		return mav;
	}
	
	// 검색 결과 불러오기 (Open API)
	@ResponseBody
	@RequestMapping(value="/search.mv", produces="text/plain;charset=UTF-8")
	public String searchMovie(HttpServletRequest request) {
		String clientId = "J3tOLQfpQGX89nqXcTYU"; //애플리케이션 클라이언트 아이디값"
        String clientSecret = "Jd2IAv0r8R"; //애플리케이션 클라이언트 시크릿값"
        String keyword = request.getParameter("keyword");
        
        String text = null;
        try {
            text = URLEncoder.encode(keyword, "UTF-8");
        } catch (UnsupportedEncodingException e) {
            throw new RuntimeException("검색어 인코딩 실패",e);
        }

        String apiURL = "https://openapi.naver.com/v1/search/movie?query=" + text;
        
        Map<String, String> requestHeaders = new HashMap<>();
        requestHeaders.put("X-Naver-Client-Id", clientId);
        requestHeaders.put("X-Naver-Client-Secret", clientSecret);
        String responseBody = ApiExamSearch.get(apiURL,requestHeaders);
        
        JSONArray jsonArr = new JSONArray();
        jsonArr.put(responseBody);
        
//		return jsonArr.toString();
        return responseBody;
	}
	
	// 로그인 페이지
	@RequestMapping(value="/login/login.mv")
	public ModelAndView login(ModelAndView mav) {
		
		mav.setViewName("login/loginform.tiles1");
		// 		/WEB-INF/views/tiles1/login/loginform.jsp 파일을 생성한다.
		return mav;
	}
	
	// 로그인 페이지
	@RequestMapping(value="/login/joinmember.mv")
	public ModelAndView joinmember(ModelAndView mav) {
		
		mav.setViewName("login/joinmember.tiles1");
		
		return mav;
	}
	
	// 로그인 페이지
	@ResponseBody
	@RequestMapping(value="/login/idDuplicateCheck.mv", produces="text/plain; charset=UTF-8")
	public String idDuplicateCheck(HttpServletRequest request) {
		
		String userid = request.getParameter("userid");
		String n = service.idDuplicateCheck(userid);
		
		JSONObject jsonObj = new JSONObject();
		jsonObj.put("n", n);
		
		return jsonObj.toString();
	}
	
	// 회원가입하기
	@RequestMapping(value="/login/loginEnd.mv", method= {RequestMethod.POST})
	public String loginEnd(HttpServletRequest request, MemberVO mvo) {
		String msg = "";
		String loc = "";
		
		int n = service.registerMember(mvo);

		if(n==1) {
			msg = "회원가입  성공";
			loc = "login/login.mv";	// 자바스크립트를 이용한 이전페이지로 이동하는 것이다.
			
			request.setAttribute("msg", msg);
			request.setAttribute("loc", loc);
			
			return "msg"; //msg.jsp 페이지로 이동
		}
		else {
			msg = "회원가입  실패";
			loc = "javascript:history.back()";	// 자바스크립트를 이용한 이전페이지로 이동하는 것이다.
			
			request.setAttribute("msg", msg);
			request.setAttribute("loc", loc);
			
			return "msg"; //msg.jsp 페이지로 이동
		}
		
	}
	
	// 로그인 하기
	@RequestMapping(value="/loginEnd.mv" , method= {RequestMethod.POST})
	public ModelAndView loginEnd(HttpServletRequest request, ModelAndView mav) {
		
		String userid = request.getParameter("userid");
		String pwd = request.getParameter("pwd");
		
		HashMap<String, String> paraMap = new HashMap<>();
		paraMap.put("userid", userid);
		paraMap.put("pwd", pwd);
		
		MemberVO loginuser = service.getLoginMember(paraMap);
		
		HttpSession session = request.getSession();
		
		if(loginuser == null) {
			String msg = "아이디 또는 암호가 틀립니다.";
			String loc = "javascript:history.back()";
			
			mav.addObject("msg", msg);
			mav.addObject("loc", loc);
			
			mav.setViewName("msg");
			//   /WEB-INF/views/msg.jsp 파일을 생성한다.
		}
		
		else {
			if(loginuser.isIdleStatus()) { 
				// 로그인을 한지 1년이 지나서 휴면상태에 빠진 경우
				String msg = "로그인을 하지 1년이 지나서 휴면상태에 빠졌습니다. 관리자에게 문의 바랍니다.";
				String loc = "javascript:history.back()";
				
				mav.addObject("msg", msg);
				mav.addObject("loc", loc);
				
				mav.setViewName("msg");
			}
			else {
				if(loginuser.isRequirePwdChange()) { 
					// 암호를 최근 3개월 동안 변경하지 않은 경우
					session.setAttribute("loginuser", loginuser);
					
					String msg = "암호를 최근 3개월동안 변경하지 않으셨습니다. 암호를 변경을 위해 나의정보 페이지로 이동합니다.";
					String loc = request.getContextPath()+"/myinfo.mv";
								// 		/board/myinfo.action
					
					mav.addObject("msg", msg);
					mav.addObject("loc", loc);
					
					mav.setViewName("msg");
				}
				
				else {
					// 아무런 이상없이 로그인 하는 경우
					session.setAttribute("loginuser", loginuser);
					
					if(session.getAttribute("gobackURL") != null) {
						// 세션에 저장된 돌아갈 페이지 주소(gobackURL)가 있다라면
						String gobackURL = (String) session.getAttribute("gobackURL");
						mav.addObject("gobackURL", gobackURL); // request 영역에 저장시키는 것이다.
						
						session.removeAttribute("gobackURL"); // 중요!!!
					}
					
					mav.setViewName("login/loginEnd.tiles1");
					// 				/WEB-INF/views/tiles1/login/loginEnd.jsp 파일을 생성한다.
				}
			}
		}
		return mav;
	}
	
	// 로그아웃하기
	@RequestMapping(value="/login/logout.mv")
	public ModelAndView logout(HttpServletRequest request, ModelAndView mav) {
		HttpSession session = request.getSession();
		session.invalidate();
		
		String msg = "로그아웃 되었습니다.";
		String loc = request.getContextPath()+"/index.mv";
		
		mav.addObject("msg", msg);
		mav.addObject("loc", loc);
		
		mav.setViewName("msg");
		
		return mav;
	}
	
	// 스포일러 감상문 페이지
	@RequestMapping(value="/spoilerList.mv")
	public ModelAndView list(ModelAndView mav) {
		
		mav.setViewName("spoiler/list.tiles1");
		
		return mav;
	}

	// 마이 페이지
	@RequestMapping(value="/mypageMain.mv")
	public ModelAndView mypageMain(ModelAndView mav) {
		
		mav.setViewName("mypage/view.tiles2");
		
		return mav;
	}
	
	// 자유게시판 페이지
	@RequestMapping(value="/freeBoardList.mv")
	public ModelAndView freeBoardList(ModelAndView mav, HttpServletRequest request) {
		
		List<postVO> freeboardList = null;
		
		freeboardList = service.getFreeboardList();
		
		mav.addObject("freeboardList",freeboardList);
		mav.setViewName("board/freeBList.tiles1");
		
		return mav;
	}
	
	// 자유게시판 글쓰기
	@RequestMapping(value="/freeBoardAdd.mv")
	public ModelAndView requiredLogin_freeBoardAdd(HttpServletRequest request, HttpServletResponse response,ModelAndView mav) {
		
		mav.setViewName("board/freeBAdd.tiles1");
		
		return mav;
	}
	
	// 자유게시판 글쓰기 요청
	@RequestMapping(value="/addfreeboardEnd.mv", method= {RequestMethod.POST})
	public ModelAndView addfreeboard(ModelAndView mav, postVO postvo, HttpServletRequest request) {
	
		String msg = "";
		String loc = "";
		int n = service.addfreeboard(postvo); // 자유게시판 글쓰기
		
		if(n==1){
			msg = "글이 등록되었습니다:)";
			loc = request.getContextPath()+"/freeBoardList.mv";	

		}else {
			msg = "글 등록 실패...:(";
			loc = "javascript:history.back()";	// 자바스크립트를 이용한 이전페이지로 이동하는 것이다.
			
		}
		request.setAttribute("msg", msg);
		request.setAttribute("loc", loc);
		mav.setViewName("msg");
		
		return mav;
	}
				
	// 자유게시판 게시판 글 상세보기
	@RequestMapping(value="/freeboardView.mv")
	public ModelAndView freeboardview(HttpServletRequest request, ModelAndView mav) {
		
		String post_seq = request.getParameter("post_seq");
		
		postVO freeboardView = null;
		freeboardView = service.getFreeboardView(post_seq); // 자유게시판 상세보기
				
		mav.addObject("freeboardView", freeboardView);
		mav.setViewName("board/freeboardView.tiles1");
		
		return mav;
	}
	
	// 공지사항 페이지
	@RequestMapping(value="/noticeList.mv")
	public ModelAndView noticeList(ModelAndView mav) {
		
		mav.setViewName("board/noticeList.tiles1");
		
		return mav;
	}
	
	// Q&A 페이지
	@RequestMapping(value="/QnAList.mv")
	public ModelAndView QnAList(ModelAndView mav) {
		
		mav.setViewName("board/QnAList.tiles1");
		
		return mav;
	}
}
