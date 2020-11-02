show user;
--USER이(가) "ILIKEMOVIE"입니다.
    select * from tab;
      
    show recyclebin;
    purge recyclebin;
      
    drop table tbl_attach;
    drop table tbl_cmt;
    drop table tbl_post;
    drop table tbl_board_info;
    drop table tbl_writer_follow;
    drop table tbl_mypage;
    drop table tbl_platf_mv_relation;
    drop table tbl_mv_cmt;
    drop table tbl_platf;
    drop table tbl_mv_info;
    drop table tbl_mv_member;
    
    drop sequence attach_seq;
    drop sequence cmt_seq;
    drop sequence post_seq;
    drop sequence mypage_seq;
    drop sequence mv_cmt_seq;

    commit;
    
    -- 회원_정보 테이블
    create table tbl_mv_member
    ( userid                      varchar2(50)   not null     -- 아이디
    , name                      varchar2(30)   not null     -- 성명
    , nickname                 varchar2(50)   not null     -- 닉네임
    , pwd                         varchar2(200)   not null   -- 비밀번호 (SHA-256 암호화 대상/복호화 대상))
    , identity                  number(1) default 1          -- 회원_신원 (회원 1, 관리자 0)
    , email                        varchar2(300)   not null   -- 이메일
    , mobile                     varchar2(200)   not null   -- 핸드폰_번호
    , bank_name              varchar2(30)                      -- 은행_이름 (작가일 경우)
    , bank_num                varchar2(200)                    -- 계좌_번호 (작가일 경우)
    , point                       number default 0   not null          -- 포인트 (감상문 작성시 포인트)
    , writer_level               number default 0    not null         -- 작가_레벨
    , register_date            date default sysdate  not null      -- 가입_일자
    , delt_status                number(1) default 1    not null      -- 삭제_상태   1:사용가능(가입중) / 0:사용불능(탈퇴)
    , last_login_date         date default sysdate   not null     -- 마지막_로그인_날짜
    , pwd_change_date   date default sysdate    not null    -- 비밀번호_변경_날짜
    , file_name                  varchar2(255)                                 -- 파일이름(프로필 사진)
    , orig_file_name          varchar2(255)                                 -- 파일이름 (진짜이름)
    , update_date             date default sysdate                     -- 수정_일시                         
    , update_userid           varchar2(50)                                   -- 수정_회원_아이디
    , constraint PK_mv_member_userid primary key (userid)
    , constraint CK_mv_member_status check(delt_status in(0,1))
    );
    select *
    from tbl_mv_member;
   
    -- 영화_정보 테이블
    create table tbl_mv_info
    ( mv_info_num    number                         not null  -- 영화_번호(api의 Link의 번호)
    , title                   varchar2(200)                not null  -- 영화_제목
    , mv_url               varchar2(50)                 not null  -- 영화_URL
    , register_date    date default sysdate    not null  -- 등록_일시
    , delt_status        number(1) default 1     not null  -- 삭제_상태   1:사용가능 / 0:사용불능
    , userid                varchar2(50)                 not null  -- 아이디 (등록한 사람의 아이디)
    , update_date     date default sysdate                   -- 수정_일시                         
    , update_userid   varchar2(50)                                -- 수정_회원_아이디
    , constraint PK_mv_info_num PRIMARY KEY (mv_info_num)
    , constraint FK_mv_info_userid foreign key (userid) references tbl_mv_member(userid)
    , constraint CK_mv_info_delt check( delt_status in(0,1) )
    );


    -- 영화_한줄_감상평 테이블
    create table tbl_mv_cmt
    ( mv_cmt_seq      number            not null -- 한줄 감상평 시퀀스
    , mv_info_num     number            not null -- 영화 정보 시퀀스
    , userid                varchar2(50)     not null -- 작성자
    , nickname           varchar2(50)    not null -- 닉네임
    , content            varchar2(500)   not null -- 내용
    , delt_status        number(1) default 1  not null  -- 삭제_상태   1:사용가능 / 0:사용불능
    , write_date         date default sysdate  not null  -- 작성일
    , update_date     date default sysdate                   -- 수정_일시                         
    , update_userid   varchar2(50)                                 -- 수정_회원_아이디
    , constraint PK_mv_cmt_seq PRIMARY KEY (mv_cmt_seq)
    , constraint FK_mv_cmt_info_num foreign key (mv_info_num) references tbl_mv_info (mv_info_num) 
    , constraint FK_mv_cmt_userid foreign key (userid) references tbl_mv_member (userid)
    , constraint CK_mv_cmt_delt check( delt_status in(0,1) )
    );

    -- 영화 한줄 감상평 시퀀스
    create sequence mv_cmt_seq
    start with 1
    increment by 1
    nomaxvalue
    nominvalue
    nocycle
    nocache;


    -- 플랫폼 테이블 (왓챠 넷플 네이버 등)
    create table tbl_platf
    ( platf_num        number                        not null  -- 플랫폼_번호
    , name              varchar2(30)                 not null -- 플랫폼_이름
    , web_site          varchar2(100)                not null -- 사이트_URL
    , delt_status       number(1) default 1     not null  -- 삭제_상태   1:사용가능 / 0:사용불능
    , register_date   date default sysdate    not null  -- 등록_일시
    , userid               varchar2(50)                 not null  -- 아이디 (등록한 사람의 아이디)
    , update_date    date default sysdate                   -- 수정_일시                         
    , update_userid  varchar2(50)                                -- 수정_회원_아이디
    , constraint PK_platf_num PRIMARY KEY (platf_num)
    , constraint FK_platf_userid foreign key (userid) references tbl_mv_member (userid)
    , constraint CK_platf_delt check( delt_status in(0,1) )
    );
    
    
    -- 플랫폼_영화_관계 테이블
    create table tbl_platf_mv_relation
    ( mv_info_num           number  -- 영화_번호
    , platf_num                 number  -- 플랫폼_번호
    , constraint FK_relation_mv_info_num foreign key(mv_info_num) references tbl_mv_info(mv_info_num)
    , constraint FK_relation_platf_num foreign key(platf_num) references tbl_platf(platf_num)
    );
    
    
    -- 마이페이지 (1.찜영화 2.본영화)
    create table tbl_mypage
    ( mypage_seq    number                      not null -- 마이페이지_번호
    , userid               varchar2(50)              not null  -- 아이디
    , mv_info_num    number                      not null -- 영화_번호
    , mypage_info    number                      not null -- 마이페이지_정보
    , register_date    date default sysdate not null  -- 등록_일시
    , delt_status        number(1) default 1  not null  -- 삭제_상태   1:사용가능 / 0:사용불능
    , update_date    date default sysdate                 -- 수정_일시                         
    , update_userid  varchar2(50)                               -- 수정_회원_아이디
    , constraint PK_mypage_seq PRIMARY KEY(mypage_seq)
    , constraint FK_mypage_userid foreign key(userid) references tbl_mv_member(userid)
    , constraint FK_mypage_mv_num foreign key(mv_info_num) references tbl_mv_info(mv_info_num)
    , constraint CK_mypage_delt check( delt_status in(0,1) )
    );
    
    -- 마이페이지 시퀀스
    create sequence mypage_seq
    start with 1
    increment by 1
    nomaxvalue
    nominvalue
    nocycle
    nocache;
    
    
    -- 작가_팔로우 테이블
    create table tbl_writer_follow
    ( mypage_seq    number          not null -- 마이페이지_번호
    , userid               varchar2(50)   not null -- 작가_아이디
    , register_date    date default sysdate not null  -- 등록_일시
    , constraint FK_follow_mypage_seq foreign key(mypage_seq) references tbl_mypage(mypage_seq)
    , constraint FK_follow_userid foreign key(userid) references tbl_mv_member(userid)
    );


    -- 게시판 (1.감상문 2.자유 3.QnA 4.공지사항)
    create table tbl_board_info
    ( board_num     number         not null -- 게시판_번호
    , board_name   varchar2(30)  not null -- 게시판_이름
    , constraint PK_board_num PRIMARY KEY(board_num)
    ); 
    
    insert into tbl_board_info(board_num, board_name)
    values(1, '스포주의 감상문');
     insert into tbl_board_info(board_num, board_name)
    values(2, '자유게시판');
     insert into tbl_board_info(board_num, board_name)
    values(3, '문의사항');
     insert into tbl_board_info(board_num, board_name)
    values(4, '공지사항');
    commit;
    
    select *
    from tbl_post;
    
    -- 게시판 테이블
    create table tbl_post
    ( post_seq           number                      not null -- 게시글_번호
    , board_num       number                      not null -- 게시판_번호
    , userid                varchar2(50)              not null -- 아이디
    , mv_info_num    number                                     -- 영화_번호
    , nickname          varchar2(50)               not null -- 닉네임
    , title                   nvarchar2(200)            not null -- 제목
    , content            nvarchar2(200)                         -- 내용
    , view_cnt            number default 0                     -- 조회_수
    , write_date        date default sysdate  not null  -- 작성_일시 
    , delt_status        number(1) default 1   not null  -- 삭제_상태  1:사용가능한글,  0:삭제된글
    , secret              number(1) default 0                  -- 비밀_글 0: 공개글 1: 비밀글
    , recommend     number                                       -- 추천_수
    , update_date    date default sysdate                  -- 수정_일시                         
    , update_userid  varchar2(50)                                -- 수정_회원_아이디
    , constraint  PK_post_seq primary key(post_seq)
    , constraint  FK_post_board_num foreign key(board_num) references tbl_board_info(board_num)
    , constraint  FK_post_userid foreign key(userid) references tbl_mv_member(userid)
    , constraint  FK_post_info_num foreign key(mv_info_num) references tbl_mv_info(mv_info_num)
    , constraint  CK_post_status check( delt_status in(0,1) )
    , constraint  CK_post_secret check( secret in(0,1) )
    ); 
    
    insert into tbl_post(post_seq, board_num, userid, nickname, title, content, write_date, delt_status, secret)
    values(post_seq.nextval, 2, 'ivory0331', '아이보리문', '제목입니당', '내용물 암어 미스핏 맞는 핏 자체가 없지 숨이 턱턱 막히는 느낌 핫쵸핫쵸 컬러 뜨겁고 감각 느끼는대로', default, default, default);
    
    commit;
    select *
    from tbl_post;
    
    select post_seq, substr(userid, 1, 3) || lpad('*', length(userid)-3,'*') AS userid, 
                nickname, title, view_cnt, to_char(write_date,'yyyy-mm-dd') as write_date 
    from tbl_post
    where board_num = 2 and delt_status = 1
    order by post_seq desc;
    
    select rno,post_seq, userid, nickname, title, view_cnt, write_date
		from
		    (
		    select rownum as rno, post_seq, userid, nickname, title, view_cnt, write_date
		    from
		        (
		        select post_seq, substr(userid, 1, 3) || lpad('*', length(userid)-3,'*') AS userid, nickname, title, view_cnt, to_char(write_date,'yyyy-mm-dd') as write_date
		        from tbl_post
		        where delt_status = 1 and  board_num = 2
		        	<if test='searchWord != "" '>
			         and ${searchType} like '%'|| #{searchWord} ||'%'
			        </if>
		        order by post_seq desc
		        ) V
		    ) T
		where rno between #{startRno} and #{endRno}
        
    select previousseq, previoussubject, post_seq, userid, nickname, title, content, view_cnt, write_date
		      ,nextseq, nextsubject
		from
		(
		 select lag(post_seq, 1) over(order by post_seq desc) as previousseq  
				           , nvl(lag(title, 1) over(order by post_seq desc),'이전글이 없습니다')as previoussubject				           				           
				           , post_seq, substr(userid, 1, 3) || lpad('*', length(userid)-3,'*') AS userid, nickname, title, content, view_cnt
				           , to_char(write_date, 'yyyy-mm-dd hh24:mi:ss') as write_date				         
				           , lead(post_seq, 1) over(order by post_seq desc) as nextseq
				           , nvl(lead(title, 1) over(order by post_seq desc),'다음글이 없습니다.') as nextsubject
				      from tbl_post
				      where delt_status = 1 and board_num = 2 and delt_status = 1
		) V
		where post_seq = 1;
        
    -- 게시판 시퀀스
    create sequence post_seq
    start with 1
    increment by 1
    nomaxvalue
    nominvalue
    nocycle
    nocache;

    
    --  댓글 테이블
    create table tbl_cmt
    ( cmt_seq            number                        not null   -- 댓글_번호
    , post_seq           number                        not null   -- 게시글_번호
    , userid                varchar2(50)                not null   -- 아이디
    , nickname          varchar2(50)                                 -- 닉네임
    , content           Nvarchar2(500)            not null   -- 내용
    , write_date        date default sysdate   not null   -- 작성_일시
    , delt_status        number(1) default 1    not null   -- 삭제_상태 1: 존재 0: 삭제
    , update_date    date default sysdate                    -- 수정_일시                         
    , update_userid  varchar2(50)                                  -- 수정_회원_아이디
    ,constraint PK_cmt_seq primary key(cmt_seq)
    ,constraint FK_cmt_userid foreign key(userid) references tbl_mv_member(userid)
    ,constraint FK_cmt_post_seq foreign key(post_seq) references tbl_post(post_seq) on delete cascade
    ,constraint CK_cmt_status check( delt_status in(1,0) )
    );
    select *
    from tbl_cmt
    
    update tbl_cmt set delt_status = 1
    where cmt_seq = 4
    commit;
    
    --  댓글 시퀀스
    create sequence cmt_seq
    start with 1
    increment by 1
    nomaxvalue
    nominvalue
    nocycle
    nocache;
        
        
    -- 첨부_파일 테이블
    create table tbl_attach_file
    ( attach_seq       number           not null  -- 첨부_번호
    , post_seq          number           not null  -- 게시글_번호
    , file_name         varchar2(255)  not null  -- 파일_이름
    , org_file_name  varchar2(255)  not null  -- 원본_파일_이름
    ,constraint PK_attach_seq primary key(attach_seq)
    ,constraint FK_attach_post_seq foreign key(post_seq) references tbl_post(post_seq)
    );
    
    -- 첨부파일 시퀀스
    create sequence attach_seq
    start with 1
    increment by 1
    nomaxvalue
    nominvalue
    nocycle
    nocache;
    
    insert into tbl_attach_file(attach_seq, post_seq, file_name, org_file_name)
    values()



    select previousseq, previoussubject, free_seq, fk_userid, name, title, content, viewcount, writedate
		      ,nextseq, nextsubject, orgFilename, fileName
		from
		(
		 select lag(free_seq, 1) over(order by free_seq desc) as previousseq  
				           , nvl(lag(title, 1) over(order by free_seq desc),'이전글이 없습니다')as previoussubject				           				           
				           , free_seq, fk_userid, name, title, content, viewcount
				           , to_char(writedate, 'yyyy-mm-dd hh24:mi:ss') as writedate				         
				           , lead(free_seq, 1) over(order by free_seq desc) as nextseq
				           , nvl(lead(title, 1) over(order by free_seq desc),'다음글이 없습니다.') as nextsubject
		                   , orgFilename, fileName
				      from free_board
				      where status = 1
		) V
		where free_seq = #{free_seq}
        
        select previousseq, previoussubject, free_seq, fk_userid, name, title, content, viewcount, writedate
		      ,nextseq, nextsubject, orgFilename, fileName
		from
		(
		 select lag(free_seq, 1) over(order by free_seq desc) as previousseq  
				           , nvl(lag(title, 1) over(order by free_seq desc),'이전글이 없습니다')as previoussubject				           				           
				           , free_seq, fk_userid, name, title, content, viewcount
				           , to_char(writedate, 'yyyy-mm-dd hh24:mi:ss') as writedate				         
				           , lead(free_seq, 1) over(order by free_seq desc) as nextseq
				           , nvl(lead(title, 1) over(order by free_seq desc),'다음글이 없습니다.') as nextsubject
		                   , orgFilename, fileName
				      from free_board
				      where status = 1
		) V
		where free_seq = #{free_seq}