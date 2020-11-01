package com.spring.model;

public class attachVO {
	private String attach_seq;
	private String post_seq;
	private String file_name;
	private String org_file_name;
	
	
	public attachVO() {}


	public attachVO(String attach_seq, String post_seq, String file_name, String org_file_name) {
		super();
		this.attach_seq = attach_seq;
		this.post_seq = post_seq;
		this.file_name = file_name;
		this.org_file_name = org_file_name;
	}


	public String getAttach_seq() {
		return attach_seq;
	}


	public void setAttach_seq(String attach_seq) {
		this.attach_seq = attach_seq;
	}


	public String getPost_seq() {
		return post_seq;
	}


	public void setPost_seq(String post_seq) {
		this.post_seq = post_seq;
	}


	public String getFile_name() {
		return file_name;
	}


	public void setFile_name(String file_name) {
		this.file_name = file_name;
	}


	public String getOrg_file_name() {
		return org_file_name;
	}


	public void setOrg_file_name(String org_file_name) {
		this.org_file_name = org_file_name;
	}
	
	
}
