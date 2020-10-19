package com.spring.model;

public class MemberVO {

	private String userid;			// 아이디
	private String name;			// 성명
	private String nickname;		// 닉네임
	private String pwd;				// 비밀번호 (SHA-256 암호화 대상)
	private String identity;		// 회원구분 (학생1, 교수2, 관리자3)
	private String email;			// 이메일 (AES-256 암호화/복호화 대상)
	private String mobile;			// 핸드폰 (AES-256 암호화/복호화 대상)
	private String bank_account;	// 계좌번호(은행이름)
	private String bank_number;		// 계좌번호(계좌번호)
	private String point;			// 포인트
	private String WriterLevel;		// 작가레벨
	private String registerday;		// 가입일자
	private String status;			// 회원상태 1: 사용가능(가입중) / 0: 사용불가능(탈퇴)
	private String last_login_date;	// 마지막 로그인 날짜
	private String pwd_change_date;	// 마지막 비밀번호 변경 날짜
	private String filename;		// 파일이름 (WAS 저장용)
	private String orgfilename;		// 파일이름 (진짜 이름)

	private boolean requirePwdChange = false;
	// 마지막 로그인 한 날짜가 현재시각으로부터 3개월 지났으면 true 아니면 false
	private boolean idleStatus = false;		// 휴면유무 (휴면 true, 아니면 false)
	
	private int pwdchangegap; 	  // 로그인시 현재날짜와 최근 마지막으로 암호를 변경한 날짜와의 개월수 차이 (3개월 동안 암호를 변경 안 했을시 암호를 변경하라는 메시지를 보여주기 위함)
	private int lastlogindategap; // 로그인시 현재날짜와 최근 마지막으로 로그인한 날짜와의 개월수 차이 (12개월 동안 로그인을 안 했을 경우 해당 로그인계정을 비활성화 시키려고 함) 

	public MemberVO() {}

	public MemberVO(String userid, String name, String nickname, String pwd, String identity, String email,
			String mobile, String bank_account, String bank_number, String point, String writerLevel,
			String registerday, String status, String last_login_date, String pwd_change_date, String filename,
			String orgfilename, boolean requirePwdChange, boolean idleStatus) {
		super();
		this.userid = userid;
		this.name = name;
		this.nickname = nickname;
		this.pwd = pwd;
		this.identity = identity;
		this.email = email;
		this.mobile = mobile;
		this.bank_account = bank_account;
		this.bank_number = bank_number;
		this.point = point;
		this.WriterLevel = writerLevel;
		this.registerday = registerday;
		this.status = status;
		this.last_login_date = last_login_date;
		this.pwd_change_date = pwd_change_date;
		this.filename = filename;
		this.orgfilename = orgfilename;
		this.requirePwdChange = requirePwdChange;
		this.idleStatus = idleStatus;
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

	public String getBank_account() {
		return bank_account;
	}

	public void setBank_account(String bank_account) {
		this.bank_account = bank_account;
	}

	public String getBank_number() {
		return bank_number;
	}

	public void setBank_number(String bank_number) {
		this.bank_number = bank_number;
	}

	public String getPoint() {
		return point;
	}

	public void setPoint(String point) {
		this.point = point;
	}

	public String getWriterLevel() {
		return WriterLevel;
	}

	public void setWriterLevel(String writerLevel) {
		WriterLevel = writerLevel;
	}

	public String getRegisterday() {
		return registerday;
	}

	public void setRegisterday(String registerday) {
		this.registerday = registerday;
	}

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
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

	public String getFilename() {
		return filename;
	}

	public void setFilename(String filename) {
		this.filename = filename;
	}

	public String getOrgfilename() {
		return orgfilename;
	}

	public void setOrgfilename(String orgfilename) {
		this.orgfilename = orgfilename;
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
