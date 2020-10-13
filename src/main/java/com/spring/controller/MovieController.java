package com.spring.controller;

import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONArray;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.spring.service.InterMovieService;

//=== #30. 컨트롤러 선언 ===
@Component
@Controller
public class MovieController {
	
	@Autowired // Type에 따라 알아서 Bean을 주입해준다.
	private InterMovieService service;
	
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
	@RequestMapping(value="/login.mv")
	public ModelAndView login(ModelAndView mav) {
		
		mav.setViewName("login/loginform.tiles1");
		// 		/WEB-INF/views/tiles1/login/loginform.jsp 파일을 생성한다.
		return mav;
	}
	
	// 스포일러 감상문 페이지
	@RequestMapping(value="/spoilerList.mv")
	public ModelAndView list(ModelAndView mav) {
		
		mav.setViewName("spiler/list.tiles1");
		
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
	public ModelAndView freeBoardList(ModelAndView mav) {
		
		mav.setViewName("board/freeBList.tiles1");
		
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
