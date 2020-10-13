show user;
--USER이(가) "ILIKEMOVIE"입니다.
    
    drop table free_board;
    drop table watch_tbl;
    drop table dibs_tbl;
    drop table spoiler_comment;
    drop table spoiler_tbl;
    drop table platform_tbl;
    drop table mvComment_tbl;
    drop table mvdetail_tbl;
    drop table login_table;
    drop table mv_member;
    
    drop sequence mvSeq;
    
    commit;
    
    -- 회원정보 테이블
    create table mv_member
    ( userid                      varchar2(50)   not null     -- 아이디
    , name                      varchar2(30)   not null     -- 성명
    , nickname                 varchar2(50)                     -- 닉네임
    , pwd                         varchar2(200)   not null   -- 비밀번호 (SHA-256 암호화 대상)
    , identity                  number(1) default 1          -- 회원 구분 (회원 1, 관리자 0)
    , email                       varchar2(300)   not null   -- 이메일 (AES-256 암호화/복호화 대상)
    , mobile                     varchar2(200)   not null   -- 핸드폰
    , bank_account          varchar2(200)                   -- 계좌번호(작가일 경우)
    , point                      number default 0             -- 포인트 (감상문 작성시 포인트)
    , WriterLevel             number default 0             --  작가 레벨
    , registerday              date default sysdate        -- 가입일자
    , status                       number(1) default 1         -- 회원상태   1:사용가능(가입중) / 0:사용불능(탈퇴)
    , last_login_date         date default sysdate       -- 마지막 로그인 날짜
    , pwd_change_date   date default sysdate       -- 암호 바꾼 날짜
    , filename                   varchar2(255)                   -- 파일이름(프로필 사진)
    , orgfilename             varchar2(255)                   -- 파일이름 (진짜이름)
    , constraint PK_mv_member_userid primary key (userid)
    , constraint CK_mv_member_status check(status in(0,1))
    );


    -- 로그인 테이블
    create table login_table
    ( fk_userid                 varchar2(50)   not null     -- 아이디
    , name                      varchar2(30)   not null     -- 성명
    , nickname                 varchar2(50)                     -- 닉네임
    , identity                  number(1) default 1         -- 회원 구분 (회원 1, 관리자 0)
    , constraint FK_login_table_fk_userid foreign key (fk_userid) references mv_member (userid)
    );
    
    
    -- 검색 결과 테이블 (api)
    
    
    -- 영화 정보 테이블
    create table mvdetail_tbl
    ( mvSeq   number         not null  -- 영화 정보 시퀀스
    , title         varchar2(200) not null -- 영화 제목
    , mvNum   number        not null   -- 영화 번호(api의 Link의 번호)
    , platform           number              -- 이용가능한 플렛폼 리스트
   -- , star_grade        varchar2(10) default '☆☆☆☆☆' -- 영화 별점 //사실 userRating을 활용할지 말지 고민중임
    ,constraint PK_detail_tbll_seq PRIMARY KEY (mvSeq)
    );
    
    -- 영화 정보 시퀀스
    create sequence mvSeq
    start with 1
    increment by 1
    nomaxvalue
    nominvalue
    nocycle
    nocache;
    
    
    -- 영화 한줄 감상평 테이블
    create table mvComment_tbl
    ( mvComSeq      number            not null -- 한줄 감상평 시퀀스
    , fk_mvSeq          number            not null -- 영화 정보 시퀀스
    , fk_userid            varchar2(50)    not null -- 작성자
    , content         varchar2(500)  not null -- 감상평
    , writedate           date default sysdate    -- 작성일
    , constraint PK_mvComment_tblSeq PRIMARY KEY (mvComSeq)
    , constraint FK_mvComment_tbl_mvSeq foreign key (fk_mvSeq) references mvdetail_tbl (mvSeq)
    , constraint FK_mvComment_tbl_userid foreign key (fk_userid) references mv_member (userid)
    );

    
    -- 영화 한줄 감상평 시퀀스
    create sequence mvComSeq
    start with 1
    increment by 1
    nomaxvalue
    nominvalue
    nocycle
    nocache;
    
    
    -- 플렛폼 리스트 테이블
    create table platform_tbl
    ( platformNum number not null -- 플렛폼 번호
    , name             varchar2(30) not null -- 플렛폼 이름
    , website           varchar2(100) not null -- 플렛폼 사이트 주소
    , constraint PK_platform_tbl_num PRIMARY KEY (platformNum)
    );
    
    
    -- 스포주의 감상문 게시판 테이블
    create table spoiler_tbl
    (spoilerSeq              number                 not null   -- 글번호
    , fk_userid                varchar2(50)          not null   -- 사용자ID
    , nickname               varchar2(50)                           -- 닉네임
    , title                        Nvarchar2(200)     not null   -- 글제목
    , content                Nvarchar2(2000)   not null   -- 글내용
    , viewcount             number default 0  not null   -- 글조회수
    , thumbsUp             number default 0 not null   -- 추천수
    , writedate              date default sysdate  not null   -- 글쓴시간
    , status                    number(1) default 1   not null   -- 글삭제여부  1:사용가능한글,  0:삭제된글
    ,constraint  PK_spoiler_tbl_seq primary key(spoilerSeq)
    ,constraint  FK_spoiler_tbl_userid foreign key(fk_userid) references mv_member(userid)
    ,constraint  CK_spoiler_tbl_status check( status in(0,1) )
    ); 
    
    -- 스포주의 감상문 게시판 시퀀스
    create sequence spoilerSeq
    start with 1
    increment by 1
    nomaxvalue
    nominvalue
    nocycle
    nocache;
        
    --  스포주의 감상문 게시판 댓글테이블
    create table spoiler_comment
    (ScomSeq      number                        not null   -- 댓글번호
    ,parentSeq     number                        not null   -- 원게시물 글번호
    ,fk_userid        varchar2(50)                not null   -- 사용자ID
    ,content        varchar2(1000)            not null   -- 댓글내용
    ,writedate      date default sysdate not null   -- 작성일자
    ,status            number(1) default 1    not null   -- 글삭제여부
                                                   -- 1 : 사용가능한 글,  0 : 삭제된 글
                                                   -- 댓글은 원글이 삭제되면 자동적으로 삭제되어야 한다.
    ,constraint PK_spoiler_comment_Seq primary key(ScomSeq)
    ,constraint FK_spoiler_comment_userid foreign key(fk_userid) references mv_member(userid)
    ,constraint FK_spoiler_comment_Seq foreign key(parentSeq) references spoiler_tbl(spoilerSeq) on delete cascade
    ,constraint CK_spoiler_comment_status check( status in(1,0) )
    );
    
    --  스포주의 감상문 게시판 댓글 시퀀스
    create sequence ScomSeq
    start with 1
    increment by 1
    nomaxvalue
    nominvalue
    nocycle
    nocache;
        
    
    -- 찜한 영화 리스트
    create table dibs_tbl
    ( dibsSeq           number                   not null   -- 찜리스트 시퀀스
    , fk_userid          varchar2(50)            not null   -- 사용자ID
    , MVurl              varchar2(200)          not null   -- 영화상세로 이동할 url
    , mvtitle                   varchar2(100)         not null  -- 영화 제목
    , dibDate           date default sysdate            -- 찜한 날짜
    , constraint PK_dibs_tbl_seq PRIMARY KEY(dibsSeq)
    , constraint  FK_dibs_tbl_userid foreign key(fk_userid) references mv_member(userid)
    );
    
    -- 찜한 영화 시퀀스
    create sequence dibsSeq
    start with 1
    increment by 1
    nomaxvalue
    nominvalue
    nocycle
    nocache;
    
    
    -- 본 영화 리스트
    create table watch_tbl
    ( watchSeq           number                   not null   -- 본리스트 시퀀스
    , fk_userid          varchar2(50)            not null   -- 사용자ID
    , MVurl              varchar2(200)          not null   -- 영화상세로 이동할 url
    , mvtitle                   varchar2(100)         not null  -- 영화 제목
    , watchDate           date default sysdate            -- 본 날짜
    , constraint PK_watch_tbl_seq PRIMARY KEY(watchSeq)
    , constraint  FK_watch_tbl_userid foreign key(fk_userid) references mv_member(userid)
    );
 
    -- 본 영화 시퀀스
    create sequence watchSeq
    start with 1
    increment by 1
    nomaxvalue
    nominvalue
    nocycle
    nocache;
    
    
     -- 자유게시판 테이블
    create table free_board
    ( freeSeq           number                not null   -- 글번호
    , fk_userid      varchar2(50)          not null   -- 사용자ID
    , nickname                 varchar2(50)                     -- 닉네임
    , title              Nvarchar2(200)        not null   -- 글제목
    , content        Nvarchar2(2000)       not null   -- 글내용
    , viewcount      number default 0      not null   -- 글조회수
    , writedate        date default sysdate  not null   -- 글쓴시간
    , status         number(1) default 1   not null   -- 글삭제여부  1:사용가능한글,  0:삭제된글
    , constraint  PK_free_board_seq primary key(freeSeq)
    , constraint  FK_free_board_userid foreign key(fk_userid) references mv_member(userid)
    , constraint  CK_free_board_status check( status in(0,1) )
    );
    
    -- 자유게시판 시퀀스
    create sequence freeSeq
    start with 1
    increment by 1
    nomaxvalue
    nominvalue
    nocycle
    nocache;
    
    
    -- 자유게시판 댓글테이블
    create table free_board_comment
    (comment_seq   number               not null   -- 댓글번호
    , parentSeq        number               not null   -- 원게시물 글번호
    , fk_userid           varchar2(50)         not null   -- 사용자ID
    , nickname          varchar2(50)                     -- 닉네임
    , content          varchar2(1000)       not null   -- 댓글내용
    , writedate         date default sysdate not null   -- 작성일자
    , status               number(1) default 1  not null   -- 글삭제여부
                                                   -- 1 : 사용가능한 글,  0 : 삭제된 글
                                                   -- 댓글은 원글이 삭제되면 자동적으로 삭제되어야 한다.
    ,constraint PK_free_board_comment_seq primary key(comment_seq)
    ,constraint FK_free_board_comment_userid foreign key(fk_userid)
                                        references mv_member(userid)
    ,constraint FK_free_board_comment_Seq foreign key(parentSeq)
                                          references free_board(free_seq) on delete cascade
    ,constraint CK_free_board_comment_status check( status in(1,0) )
    );
    
    -- 자유게시판 댓글 시퀀스
    create sequence comment_seq
    start with 1
    increment by 1
    nomaxvalue
    nominvalue
    nocycle
    nocache;
    
    
    -- Q&A 게시판 테이블
    create table question_board
    (question_seq            number                not null   -- 글번호
    ,fk_userid      varchar2(50)          not null   -- 사용자ID
    ,name           VARCHAR2(30)         not null   -- 글쓴이
    ,title          Nvarchar2(200)        not null   -- 글제목
    ,content        Nvarchar2(2000)       not null   -- 글내용
    ,viewcount      number default 0      not null   -- 글조회수
    ,writedate      date default sysdate  not null   -- 글쓴시간
    ,status         number(1) default 1   not null   -- 글삭제여부  1:사용가능한글,  0:삭제된글
    ,groupno        number                not null   -- 답변글쓰기에 있어서 그룹번호
                                                     -- 원글(부모글)과 답변글은 동일한 groupno 를 가진다.
                                                     -- 답변글이 아닌 원글(부모글)인 경우 groupno 의 값은 groupno 컬럼의 최대값(max)+1 로 한다.
    ,fk_seq         number default 0      not null   -- fk_seq 컬럼은 절대로 foreign key가 아니다.!!!!!!
                                                     -- fk_seq 컬럼은 자신의 글(답변글)에 있어서
                                                     -- 원글(부모글)이 누구인지에 대한 정보값이다.
                                                     -- 답변글쓰기에 있어서 답변글이라면 fk_seq 컬럼의 값은
                                                     -- 원글(부모글)의 seq 컬럼의 값을 가지게 되며,
                                                     -- 답변글이 아닌 원글일 경우 0 을 가지도록 한다.
    ,depthno        number default 0       not null  -- 답변글쓰기에 있어서 답변글 이라면
                                                     -- 원글(부모글)의 depthno + 1 을 가지게 되며,
                                                     -- 답변글이 아닌 원글일 경우 0 을 가지도록 한다.
    ,fileName       varchar2(255)                    -- WAS(톰캣)에 저장될 파일명(20190725092715353243254235235234.png)
    ,orgFilename    varchar2(255)                    -- 진짜 파일명(강아지.png)  // 사용자가 파일을 업로드 하거나 파일을 다운로드 할때 사용되어지는 파일명
    ,secret         number(1) default 0   not null
    ,constraint  PK_question_board primary key(question_seq)
    ,constraint  FK_question_board foreign key(fk_userid) references eclass_member(userid)
    ,constraint  CK_question_board check( status in(0,1) )
    );
    
    -- Q&A게시판 시퀀스
    create sequence question_seq
    start with 1
    increment by 1
    nomaxvalue
    nominvalue
    nocycle
    nocache;
    
    
    -- 공지사항 게시판 테이블
    create table notice_board
    (notice_seq     number                not null   -- 글번호
    ,title          Nvarchar2(200)        not null   -- 글제목
    ,content        Nvarchar2(2000)       not null   -- 글내용
    ,viewcount      number default 0      not null   -- 조회수
    ,writedate      date default sysdate  not null   -- 작성일자
    ,status         number(1) default 1   not null   -- 글삭제여부  1:사용가능한글,  0:삭제된글
    ,fileName       varchar2(255)                    -- WAS(톰캣)에 저장될 파일명(20190725092715353243254235235234.png)
    ,orgFilename    varchar2(255)                    -- 진짜 파일명(강아지.png)  // 사용자가 파일을 업로드 하거나 파일을 다운로드 할때 사용되어지는 파일명
    ,constraint  PK_notice_board_seq primary key(notice_seq)
    ,constraint  CK_tblBoard_status check( status in(0,1) )
    );
    
    -- 공지사항 게시판 시퀀스
    create sequence notice_seq
    start with 1
    increment by 1
    nomaxvalue
    nominvalue
    nocycle
    nocache;
    
    