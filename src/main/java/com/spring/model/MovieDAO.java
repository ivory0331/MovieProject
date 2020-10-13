package com.spring.model;

import javax.annotation.Resource;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

//=== #32. DAO 선언 ===
@Repository
public class MovieDAO implements InterMovieDAO {

	@Autowired
	@Resource
	private SqlSessionTemplate sqlsession;
	
}
