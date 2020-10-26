package com.spring.model;

public class MemberVO {

	private String userid;			// 아이디
	private String name;			// 성명
	private String nickname;		// 닉네임
	private String pwd;				// 비밀번호 (SHA-256 암호화 대상)
	private String identity;		// 회원구분 (학생1, 교수2, 관리자3)
	private String email;			// 이메일 (AES-256 암호화/복호화 대상)
	private String mobile;			// 핸드폰 (AES-256 암호화/복호화 대상)
	private String bank_name;		// 계좌번호(은행이름)
	private String bank_num;		// 계좌번호(계좌번호)
	private String point;			// 포인트
	private String writer_level;	// 작가레벨
	private String register_date;	// 가입일자
	private String delt_status;		// 회원상태 1: 사용가능(가입중) / 0: 사용불가능(탈퇴)
	private String last_login_date;	// 마지막 로그인 날짜
	private String pwd_change_date;	// 마지막 비밀번호 변경 날짜
	private String file_name;		// 파일이름 (WAS 저장용)
	private String orig_file_name;	// 파일이름 (진짜 이름)
	private String update_date;		// 수정_일시
	private String update_userid;	// 수정_회원_아이디
	
	private boolean requirePwdChange = false;
	// 마지막 로그인 한 날짜가 현재시각으로부터 3개월 지났으면 true 아니면 false
	private boolean idleStatus = false;		// 휴면유무 (휴면 true, 아니면 false)
	
	private int pwdchangegap; 	  // 로그인시 현재날짜와 최근 마지막으로 암호를 변경한 날짜와의 개월수 차이 (3개월 동안 암호를 변경 안 했을시 암호를 변경하라는 메시지를 보여주기 위함)
	private int lastlogindategap; // 로그인시 현재날짜와 최근 마지막으로 로그인한 날짜와의 개월수 차이 (12개월 동안 로그인을 안 했을 경우 해당 로그인계정을 비활성화 시키려고 함) 

	public MemberVO() {}

	public MemberVO(String userid, String name, String nickname, String pwd, String identity, String email,
			String mobile, String bank_name, String bank_num, String point, String writer_level, String register_date,
			String delt_status, String last_login_date, String pwd_change_date, String file_name, String orig_file_name,
			String update_date, String update_userid) {
		super();
		this.userid = userid;
		this.name = name;
		this.nickname = nickname;
		this.pwd = pwd;
		this.identity = identity;
		this.email = email;
		this.mobile = mobile;
		this.bank_name = bank_name;
		this.bank_num = bank_num;
		this.point = point;
		this.writer_level = writer_level;
		this.register_date = register_date;
		this.delt_status = delt_status;
		this.last_login_date = last_login_date;
		this.pwd_change_date = pwd_change_date;
		this.file_name = file_name;
		this.orig_file_name = orig_file_name;
		this.update_date = update_date;
		this.update_userid = update_userid;
	}

	
	public String getUserid() {
		return userid;
	}

	public void setUserid(String userid) {
		this.userid = userid;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getNickname() {
		return nickname;
	}

	public void setNickname(String nickname) {
		this.nickname = nickname;
	}

	public String getPwd() {
		return pwd;
	}

	public void setPwd(String pwd) {
		this.pwd = pwd;
	}

	public String getIdentity() {
		return identity;
	}

	public void setIdentity(String identity) {
		this.identity = identity;
	}

	public String getEmail() {
		return email;
	}

	public void setEmail(String email) {
		this.email = email;
	}

	public String getMobile() {
		return mobile;
	}

	public void setMobile(String mobile) {
		this.mobile = mobile;
	}

	public String getBank_name() {
		return bank_name;
	}

	public void setBank_name(String bank_name) {
		this.bank_name = bank_name;
	}

	public String getBank_num() {
		return bank_num;
	}

	public void setBank_num(String bank_num) {
		this.bank_num = bank_num;
	}

	public String getPoint() {
		return point;
	}

	public void setPoint(String point) {
		this.point = point;
	}

	public String getWriter_level() {
		return writer_level;
	}

	public void setWriter_level(String writer_level) {
		this.writer_level = writer_level;
	}

	public String getRegister_date() {
		return register_date;
	}

	public void setRegister_date(String register_date) {
		this.register_date = register_date;
	}

	public String getDelt_status() {
		return delt_status;
	}

	public void setDelt_status(String delt_status) {
		this.delt_status = delt_status;
	}

	public String getLast_login_date() {
		return last_login_date;
	}

	public void setLast_login_date(String last_login_date) {
		this.last_login_date = last_login_date;
	}

	public String getPwd_change_date() {
		return pwd_change_date;
	}

	public void setPwd_change_date(String pwd_change_date) {
		this.pwd_change_date = pwd_change_date;
	}

	public String getFile_name() {
		return file_name;
	}

	public void setFile_name(String file_name) {
		this.file_name = file_name;
	}

	public String getOrig_file_name() {
		return orig_file_name;
	}

	public void setOrig_file_name(String orig_file_name) {
		this.orig_file_name = orig_file_name;
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

	public boolean isRequirePwdChange() {
		return requirePwdChange;
	}

	public void setRequirePwdChange(boolean requirePwdChange) {
		this.requirePwdChange = requirePwdChange;
	}

	public boolean isIdleStatus() {
		return idleStatus;
	}

	public void setIdleStatus(boolean idleStatus) {
		this.idleStatus = idleStatus;
	};
	
	public int getPwdchangegap() {
		return pwdchangegap;
	}

	public void setPwdchangegap(int pwdchangegap) {
		this.pwdchangegap = pwdchangegap;
	}

	public int getLastlogindategap() {
		return lastlogindategap;
	}

	public void setLastlogindategap(int lastlogindategap) {
		this.lastlogindategap = lastlogindategap;
	}

	
	
	
}
