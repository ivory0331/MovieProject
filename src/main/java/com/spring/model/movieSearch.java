package com.spring.model;

public class movieSearch {
	
	private String title;
	private String link;
	private String image;
	private String subtitle;
	private String pubDate;
	private String director;
	private String actor;
	private int userRating;
	
	public String getTitle() {
		return title;
	}
	public void setTitle(String title) {
		this.title = title;
	}
	public String getLink() {
		return link;
	}
	public void setLink(String link) {
		this.link = link;
	}
	public String getImage() {
		return image;
	}
	public void setImage(String image) {
		this.image = image;
	}
	public String getSubtitle() {
		return subtitle;
	}
	public void setSubtitle(String subtitle) {
		this.subtitle = subtitle;
	}
	public String getPubDate() {
		return pubDate;
	}
	public void setPubDate(String pubDate) {
		this.pubDate = pubDate;
	}
	public String getDirector() {
		return director;
	}
	public void setDirector(String director) {
		this.director = director;
	}
	public String getActor() {
		return actor;
	}
	public void setActor(String actor) {
		this.actor = actor;
	}
	public int getUserRating() {
		return userRating;
	}
	public void setUserRating(int userRating) {
		this.userRating = userRating;
	}
	
	@Override
	public String toString() {
		return "";
	}
}
