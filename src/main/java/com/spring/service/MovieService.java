package com.spring.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.spring.model.InterMovieDAO;

//=== #31. Service 선언 ===
@Service
public class MovieService implements InterMovieService {

	// === #34. 의존객체 주입하기(DI: Dependency Injection) ===
	@Autowired
	private InterMovieDAO dao;
	
	
	
	
}
