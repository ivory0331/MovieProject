package com.spring.model;

public class cmtVO {
	private String cmt_seq;		  // 댓글_번호
	private String post_seq;	  // 게시글_번호
	private String userid;		  // 아이디
	private String nickname;	  // 닉네임
	private String content;		  // 내용
	private String write_date;    // 작성_일시
	private String delt_status;   // 삭제_상태 1: 존재 0: 삭제
	private String update_date;   // 수정_일시
	private String update_userid; // 수정_회원_아이디
	
	public cmtVO() {}

	public cmtVO(String cmt_seq, String post_seq, String userid, String nickname, String content, String write_date,
			String delt_status, String update_date, String update_userid) {
		super();
		this.cmt_seq = cmt_seq;
		this.post_seq = post_seq;
		this.userid = userid;
		this.nickname = nickname;
		this.content = content;
		this.write_date = write_date;
		this.delt_status = delt_status;
		this.update_date = update_date;
		this.update_userid = update_userid;
	}

	public String getCmt_seq() {
		return cmt_seq;
	}

	public void setCmt_seq(String cmt_seq) {
		this.cmt_seq = cmt_seq;
	}

	public String getPost_seq() {
		return post_seq;
	}

	public void setPost_seq(String post_seq) {
		this.post_seq = post_seq;
	}

	public String getUserid() {
		return userid;
	}

	public void setUserid(String userid) {
		this.userid = userid;
	}

	public String getNickname() {
		return nickname;
	}

	public void setNickname(String nickname) {
		this.nickname = nickname;
	}

	public String getContent() {
		return content;
	}

	public void setContent(String content) {
		this.content = content;
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
	
	
	
}
