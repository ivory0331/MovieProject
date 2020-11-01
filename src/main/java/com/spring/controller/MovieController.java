package com.spring.controller;

import java.io.File;
import java.io.InputStream;
import java.io.PrintWriter;
import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.util.*;

import javax.servlet.http.*;

import org.json.JSONArray;
import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.*;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.servlet.ModelAndView;

import com.spring.common.FileManager;
import com.spring.common.MyUtil;
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
		String searchType = request.getParameter("searchType");
	    String searchWord = request.getParameter("searchWord");
	    String str_currentShowPageNo = request.getParameter("currentShowPageNo");
	    
		if(searchWord == null || searchWord.trim().isEmpty()) {
	         searchWord = "";
	    }
	    if(searchType == null) {
	         searchType = "";
	    }
		// 먼저 총 게시물 건수(totalCount)를 구해와야 한다.
	    // 총 게시물 건수(totalCount)는 검색조건이 있을 때와 없을때로 나뉘어진다.
	    int totalCount = 0;       // 총게시물 건수
	    int sizePerPage = 5;      // 한 페이지당 보여줄 게시물 건수
	    int currentShowPageNo = 0;  // 현재 보여주는 페이지 번호로서, 초기치로는 1페이지로 설정함. 
	    int totalPage =0;          // 총 페이지 수 (웹브라우저상에 보여줄 총 페이지 개수, 페이지바)
      
	    int startRno = 0;         // 시작 행번호
	    int endRno = 0;            // 끝 행번호
		
	    HashMap<String, String> paraMap = new HashMap<>();
	    paraMap.put("searchType", searchType);
	    paraMap.put("searchWord", searchWord);
	    
	    // 먼저 총 게시물 건수(totalCount)
	    totalCount = service.getFreeTotalCount(paraMap);
	    
	    totalPage = (int) Math.ceil ( (double)totalCount/sizePerPage );
	    
	    if(str_currentShowPageNo == null) {
	         currentShowPageNo = 1;
	      } else {
	         try {
	            currentShowPageNo = Integer.parseInt(str_currentShowPageNo);
	            if(currentShowPageNo <= 0 || currentShowPageNo > totalPage) {
	               currentShowPageNo = 1;
	            }
	         } catch(NumberFormatException e) {
	            currentShowPageNo = 1;
	         }
	      }
	    
	    startRno = ((currentShowPageNo - 1 ) * sizePerPage) + 1;
	    endRno = startRno + sizePerPage - 1; 

	    paraMap.put("startRno", String.valueOf(startRno));
	    paraMap.put("endRno", String.valueOf(endRno));
		
		freeboardList = service.getFreeboardList(paraMap);
		
		if(!"".equals(searchWord)) {
	         mav.addObject("paraMap", paraMap);
	      }

	    // 페이지바 생성
	    String pageBar = "<ul style='list-style:none;'>";
	      
	    int blockSize = 10;
	    int loop = 1;
	    int pageNo = ((currentShowPageNo - 1)/blockSize) * blockSize + 1;
	    
	    String url = "freeBoardList.mv";
	    
	    // === [이전] 만들기 ===
	    if(pageNo != 1) {
	    	pageBar += "<li style='display:inline-block; width:50px; font-size:12pt;'><a href='"+url+"?searchType="+searchType+"&searchWord="+searchWord+"&currentShowPageNo="+(pageNo-1)+"'>[이전]</a></li>";
      	}
      
      	while( !(loop > blockSize || pageNo > totalPage) ) {
         
         if(pageNo == currentShowPageNo) {
            pageBar += "<li style='display:inline-block; width:30px; font-size:10pt; font-weight: bold;  color:navy; padding:2px 4px;'>"+pageNo+"</li>";
         }
         else {
            pageBar += "<li style='display:inline-block; width:30px; font-size:10pt; color:#b8b5ab;'><a href='"+url+"?searchType="+searchType+"&searchWord="+searchWord+"&currentShowPageNo="+pageNo+"'>"+pageNo+"</a></li>";
         }
         
         loop++;
         pageNo++;
         
      	} // end of while -----------------------------------------------
      
      	// === [다음] 만들기 ===
      	if(!(pageNo > totalPage)) {
    	  pageBar += "<li style='display:inline-block; width:50px; font-size:12pt;'><a href='"+url+"?searchType="+searchType+"&searchWord="+searchWord+"&currentShowPageNo="+pageNo+"'>[다음]</a></li>";
      	}
	      
	    pageBar += "</ul>";
	      
	    mav.addObject("pageBar", pageBar);		        
	    
	    ////////////////////////////////
	    String gobackURL = MyUtil.getCurrentURL(request);
	    
	    mav.addObject("gobackURL", gobackURL);
	    
	    HttpSession session = request.getSession();
	    session.setAttribute("readCountPermission", "yes");
	    session.setAttribute("gobackURL", gobackURL);
	    
	    //////////////////////////////////////////
	    
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
	public ModelAndView addfreeboard(ModelAndView mav, postVO postvo, attachVO attachvo, HttpServletRequest request, MultipartHttpServletRequest mrequest) {
		
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
		
		String gobackURL = request.getParameter("gobackURL");
		mav.addObject("gobackURL",gobackURL);
		
		HttpSession session = request.getSession();
		MemberVO loginuser = (MemberVO)session.getAttribute("loginuser");
		String userid = null;
		
		if(loginuser != null)
			userid = loginuser.getUserid();
		
		postVO freeboardView = null;
		
		HashMap<String, String> paraMap = new HashMap<>();
		paraMap.put("post_seq", post_seq);
		paraMap.put("userid", userid);
		
		if("yes".equals(session.getAttribute("readCountPermission"))) {
			// 조회수 증가와 함께 글 조회
			freeboardView = service.getFreeboardView_cnt(paraMap); // 자유게시판 상세보기+조회수
			
			session.removeAttribute("readCountPermission");
		}
		else {
			freeboardView = service.getFreeboardView(paraMap); // 자유게시판 상세보기
		}
		
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
	
	// 스마트에디터 드래그앤드롭을 사용한 다중사진 파일업로드
	@RequestMapping(value="/image/multiplePhotoUpload.mv", method= {RequestMethod.POST}) 
	public void multiplePhotoUpload(HttpServletRequest request, HttpServletResponse response) {
		/*
		  1. 사용자가 보낸파일을 WAS(톰캣)의 특정 폴더에 저장해주어야 한다.
		  >>> 파일이 업로드 되어질 특정 경로(폴더) 지정해주기
		   	    우리는 WAS의 webapp/resources/photo_upload 라는 폴더로 지정해준다.  
		 */
		
		// WAS의 webapp의 절대경로를 알아와야 한다.
		HttpSession session = request.getSession();
		String root = session.getServletContext().getRealPath("/");
		String path = root + "resources" + File.separator + "photo_upload";
		 /*
	        File.separator는 운영체제에서 사용하는 폴더와 파일의 구분자이다.
	                  운영체제가 Windows 이라면 "\"이고 
	                  운영체제가 UNIX, Linux 이라면 "/" 이다. 
		 */
     
			System.out.println(root);
	     // path 가 첨부파일을 저장할 WAS(톱캣)의 폴더가 된다.
	        System.out.println("~~~ 확인용 Eclass path => " + path);
	     // ~~~ 확인용 path => C:\springworkspace\.metadata\.plugins\org.eclipse.wst.server.core\tmp0\wtpwebapps\Board\resources\photo_upload
		
	     File dir = new File(path);
	     if(!dir.exists()) { // 폴더가 없는 경우
	    	 dir.mkdirs(); // 폴더가 없으면 만들어라 / mkdirs - 하위폴더까지 만들어라
	     }
		
	     String strURL = "";
			
	 	try {
	 		if(!"OPTIONS".equals(request.getMethod().toUpperCase())) {
	 		    String filename = request.getHeader("file-name"); //파일명을 받는다 - 일반 원본파일명
	 	    		
	 	        System.out.println(">>>> 확인용 filename ==> " + filename); 
	 	        // >>>> 확인용 filename ==> berkelekle%ED%8A%B8%EB%9E%9C%EB%94%9405.jpg
	 	    		
	 	    	   InputStream is = request.getInputStream();
	 	    	/*
			 	          요청 헤더의 content-type이 application/json 이거나 multipart/form-data 형식일 때,
			 	          혹은 이름 없이 값만 전달될 때 이 값은 요청 헤더가 아닌 바디를 통해 전달된다. 
			 	          이러한 형태의 값을 'payload body'라고 하는데 요청 바디에 직접 쓰여진다 하여 'request body post data'라고도 한다.

	                                      서블릿에서 payload body는 Request.getParameter()가 아니라 
	                 Request.getInputStream() 혹은 Request.getReader()를 통해 body를 직접 읽는 방식으로 가져온다. 	
	 	    	*/
	 	       String newFilename = fileManager.doFileUpload(is, filename, path);
	 	    	
	 		   int width = fileManager.getImageWidth(path+File.separator+newFilename);
	 			
	 		   if(width > 600)
	 		      width = 600;
	 				
	 		// System.out.println(">>>> 확인용 width ==> " + width);
	 		// >>>> 확인용 width ==> 600
	 		// >>>> 확인용 width ==> 121
	 	    	
	 		   String CP = request.getContextPath(); // board
	 			
	 		   System.out.println("cp"+CP);
	 		   
	 		   strURL += "&bNewLine=true&sFileName="; 
	             	   strURL += newFilename;
	             	   strURL += "&sWidth="+width;
	             	   strURL += "&sFileURL="+CP+"/resources/photo_upload/"+newFilename;
	 	    	}
	 		
	 	       /// 웹브라우저상에 사진 이미지를 쓰기 ///
	 		   PrintWriter out = response.getWriter();
	 		   out.print(strURL);
	 	} catch(Exception e){
	 			e.printStackTrace();
	 	}
	     
	}// end of multiplePhotoUpload() -----------------------------------------------------------------
			
}
