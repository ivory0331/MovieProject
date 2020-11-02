package com.spring.model;

import org.springframework.web.multipart.MultipartFile;

public class postVO {

	private String post_seq;		// 게시글_번호
	private String board_num;		// 게시판_번호
	private String userid; 			// 아이디
	private String mv_info_num;		// 영화_번호
	private String nickname;		// 닉네임
	private String title;			// 제목
	private String content;			// 내용
	private String view_cnt;		// 조회수
	private String write_date;		// 작성_일시
	private String delt_status;		// 글삭제여부  1:사용가능한글,  0:삭제된글
	private String secret;			// 비밀글 여부 0: 공개글 1: 비밀글
	private String recommend;		// 추천수
	private String update_date;		// 수정_일시 
	private String update_userid;	// 수정_회원_아이디
	private String originuser;      // 원래 아이디
	
	private String previousseq;      // 이전글번호
	private String previoussubject;  // 이전글제목
	private String nextseq;          // 다음글번호
	private String nextsubject;      // 다음글제목
	
	private MultipartFile attach; // form 태그에서 type="file"인 파일을 받아서 저장되는 필드이다. 진짜파일 => WAS(톰캣) 디스크에 저장됨.
	// !!!!!! MultipartFile attach 는 오라클 데이터베이스 tblBoard 테이블의 컬럼이 아니다.!!!!!!  
	// /Board/src/main/webapp/WEB-INF/views/tiles1/board/add.jsp 파일에서 input type="file" 인 name 의 이름(attach)과 
	// 동일해야만 파일첨부가 가능해진다.!!!!
	
	public postVO() {}


	public postVO(String post_seq, String board_num, String userid, String mv_info_num, String nickname, String title,
			String content, String view_cnt, String write_date, String delt_status, String secret, String recommend,
			String update_date, String update_userid, String originuser) {
		super();
		this.post_seq = post_seq;
		this.board_num = board_num;
		this.userid = userid;
		this.mv_info_num = mv_info_num;
		this.nickname = nickname;
		this.title = title;
		this.content = content;
		this.view_cnt = view_cnt;
		this.write_date = write_date;
		this.delt_status = delt_status;
		this.secret = secret;
		this.recommend = recommend;
		this.update_date = update_date;
		this.update_userid = update_userid;
		this.originuser = originuser;
	}


	public String getPost_seq() {
		return post_seq;
	}


	public void setPost_seq(String post_seq) {
		this.post_seq = post_seq;
	}


	public String getBoard_num() {
		return board_num;
	}


	public void setBoard_num(String board_num) {
		this.board_num = board_num;
	}


	public String getUserid() {
		return userid;
	}


	public void setUserid(String userid) {
		this.userid = userid;
	}


	public String getMv_info_num() {
		return mv_info_num;
	}


	public void setMv_info_num(String mv_info_num) {
		this.mv_info_num = mv_info_num;
	}


	public String getNickname() {
		return nickname;
	}


	public void setNickname(String nickname) {
		this.nickname = nickname;
	}


	public String getTitle() {
		return title;
	}


	public void setTitle(String title) {
		this.title = title;
	}


	public String getContent() {
		return content;
	}


	public void setContent(String content) {
		this.content = content;
	}


	public String getView_cnt() {
		return view_cnt;
	}


	public void setView_cnt(String view_cnt) {
		this.view_cnt = view_cnt;
	}


	public String getWrite_date() {
		return write_date;
	}


	public void setWrite_date(String write_date) {
		this.write_date = write_date;
	}


	public String getDelt_status() {
		return delt_status;
	}


	public void setDelt_status(String delt_status) {
		this.delt_status = delt_status;
	}


	public String getSecret() {
		return secret;
	}


	public void setSecret(String secret) {
		this.secret = secret;
	}


	public String getRecommend() {
		return recommend;
	}


	public void setRecommend(String recommend) {
		this.recommend = recommend;
	}


	public String getUpdate_date() {
		return update_date;
	}


	public void setUpdate_date(String update_date) {
		this.update_date = update_date;
	}


	public String getUpdate_userid() {
		return update_userid;
	}


	public void setUpdate_userid(String update_userid) {
		this.update_userid = update_userid;
	}


	public String getPreviousseq() {
		return previousseq;
	}


	public void setPreviousseq(String previousseq) {
		this.previousseq = previousseq;
	}


	public String getPrevioussubject() {
		return previoussubject;
	}


	public void setPrevioussubject(String previoussubject) {
		this.previoussubject = previoussubject;
	}


	public String getNextseq() {
		return nextseq;
	}


	public void setNextseq(String nextseq) {
		this.nextseq = nextseq;
	}


	public String getNextsubject() {
		return nextsubject;
	}


	public void setNextsubject(String nextsubject) {
		this.nextsubject = nextsubject;
	}


	public MultipartFile getAttach() {
		return attach;
	}
	
	public void setAttach(MultipartFile attach) {
		this.attach = attach;
	}


	public String getOriginuser() {
		return originuser;
	}


	public void setOriginuser(String originuser) {
		this.originuser = originuser;
	}
	
	
	
}
