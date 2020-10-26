package com.spring.aop;

import java.io.IOException;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.aspectj.lang.JoinPoint;
import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.annotation.Before;
import org.aspectj.lang.annotation.Pointcut;
import org.springframework.stereotype.Component;

import com.spring.common.MyUtil;

@Component
@Aspect
public class BoardAOP {

	@Pointcut("execution(public * com.spring..*Controller.requiredLogin_*(..))")
	
	public void requiredLogin() {}
	
	@Before("requiredLogin()")
	public void loginCheck(JoinPoint joinPoint) {
		
		HttpServletRequest request = (HttpServletRequest) joinPoint.getArgs()[0]; // 주업무 메소드의 첫번째 파라미터를 얻어오는 것이다.
	    HttpServletResponse response = (HttpServletResponse) joinPoint.getArgs()[1]; // 주업무 메소드의 두번째 파라미터를 얻어오는 것이다.
	    
	    HttpSession session = request.getSession();
	    
	    if(session.getAttribute("loginuser") == null) {
	         String msg = "먼저 로그인 하세요";
	         String loc = request.getContextPath() + "/login/login.up";
	         
	         request.setAttribute("msg", msg);
	         request.setAttribute("loc", loc);
	         
	         // >>> 로그인 성공 후 로그인 하기전 페이지로 돌아가는 작업 만들기 <<< //
	         // === 현재 페이지의 주소(URL) 알아오기 ===
	         String url = MyUtil.getCurrentURL(request);
	         // System.out.println("~~~ 확인용 현재 페이지 URL : " + url);
	         // ~~~ 확인용 현재 페이지 URL : add.action?null
	         
	         // "문자열".endsWith("찾고자하는문자열") ===   
	         // "문자열"에서 "찾고자하는문자열"이 맨 마지막에 나오면 true를 반환.
	         // "문자열"에서 "찾고자하는문자열"이 맨 마지막에 나오면 않으면 false를 반환.
	         if(url.endsWith("?null")) {
	            url = url.substring(0, url.indexOf("?")); // ? 앞까지 잘라오겠다.
	         }
	         // System.out.println("~~~ 확인용 현재 페이지 URL : " + url);
	         // ~~~ 확인용 현재 페이지 URL : add.action
	         
	         session.setAttribute("gobackURL", url);// 세션에 url 정보를 저장시켜둔다.
	                      
	         // Controller 가 아니지만 view 페이지로 넘겨주어야 한다.
	         RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/views/msg.jsp");
	         try {
	            dispatcher.forward(request, response);
	         } catch (ServletException | IOException e) {
	            e.printStackTrace();
	         }
	      }
	} // end of public void loginCheck(JoinPoint joinPoint) --------------------------
	
	
}
