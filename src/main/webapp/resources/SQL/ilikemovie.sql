show user;
--USER이(가) "ILIKEMOVIE"입니다.
    
    drop table attach;
    drop table board_comment;
    drop table board;
    drop table what_kind_of_b;
    drop table follow;
    drop table mypage;
    drop table mv_platform_info;
    drop table mv_platform_info;
    drop table mv_comment;
    drop table mv_detail;
    drop table mv_member;
    
    drop sequence attach_sequence;
    drop sequence comment_sequence;
    drop sequence board_sequence;
    drop sequence mypage_sequence;
    drop sequence mv_com_sequence;
    drop sequence my_sequence;

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
    , bank_account          varchar2(30)                   -- 계좌번호(작가일 경우)
    , bank_number           varchar2(200)
    , point                      number default 0   not null           -- 포인트 (감상문 작성시 포인트)
    , writer_Level             number default 0    not null          --  작가 레벨
    , register_date           date default sysdate  not null      -- 가입일자
    , status                       number(1) default 1    not null      -- 회원상태   1:사용가능(가입중) / 0:사용불능(탈퇴)
    , last_login_date         date default sysdate   not null     -- 마지막 로그인 날짜
    , pwd_change_date   date default sysdate    not null    -- 암호 바꾼 날짜
    , file_name                  varchar2(255)                   -- 파일이름(프로필 사진)
    , original_name           varchar2(255)                   -- 파일이름 (진짜이름)
    , constraint PK_mv_member_userid primary key (userid)
    , constraint CK_mv_member_status check(status in(0,1))
    );
    
    insert into mv_member(userid, name, pwd, identity, email, mobile, point, WriterLevel, registerday, status, last_login_date, pwd_change_date, nickname)
    values('ivory0331', '문상아', 'qwer1234$', default, 'sanga95@naver.com', '01047039335', default, default, default, default, default, default, '' );
    commit;
    
    select *
    from mv_member;
    
    
    -- 영화 정보 테이블
    create table mv_detail
    ( my_sequence   number            not null  -- 영화 정보 시퀀스
    , title                    varchar2(200)  not null -- 영화 제목
    , mv_number       number            not null   -- 영화 번호(api의 Link의 번호)
    , mv_url               varchar2(50)   not null-- 영화 상세 주소
    ,constraint PK_mv_detail_seq PRIMARY KEY (my_sequence)
    );
    
    -- 영화 정보 시퀀스
    create sequence my_sequence
    start with 1
    increment by 1
    nomaxvalue
    nominvalue
    nocycle
    nocache;


    -- 영화 한줄 감상평 테이블
    create table mv_comment
    ( mv_com_sequence      number            not null -- 한줄 감상평 시퀀스
    , my_sequence               number            not null -- 영화 정보 시퀀스
    , userid                            varchar2(50)    not null -- 작성자
    , content                       varchar2(500)  not null -- 감상평
    , write_date                    date default sysdate  not null  -- 작성일
    , constraint PK_mv_comment_seq PRIMARY KEY (mv_com_sequence)
    , constraint FK_mvComment_tbl_mvSeq foreign key (my_sequence) references mv_detail (my_sequence)
    , constraint FK_mvComment_tbl_userid foreign key (userid) references mv_member (userid)
    );

    -- 영화 한줄 감상평 시퀀스
    create sequence mv_com_sequence
    start with 1
    increment by 1
    nomaxvalue
    nominvalue
    nocycle
    nocache;


    -- 플랫폼 리스트 테이블
    create table platform
    ( platform_number  number not null -- 플랫폼 번호
    , name                     varchar2(30) not null -- 플랫폼 이름
    , website                   varchar2(100) not null -- 플랫폼 사이트 주소
    , constraint PK_platform_num PRIMARY KEY (platform_number)
    );
    
    
    -- 플랫폼 종류 테이블
    create table mv_platform_info
    ( my_sequence           number  -- 영화 정보 시퀀스
    , platform_number     number  -- 플랫폼 시퀀스
    , constraint FK_platform_info_my_seq foreign key(my_sequence) references mv_detail(my_sequence)
    , constraint FK_platform_info_platform_num foreign key(platform_number) references platform(platform_number)
    );
    
    
    -- 마이페이지 (1.찜영화 2.본영화)
    create table mypage
    ( mypage_sequence    number                      not null -- 마이페이지-시퀀스
    , userid                         varchar2(50)              not null -- 아이디
    , my_sequence             number                      not null -- 영화정보-시퀀스
    , code                           number                      not null -- 구분 코드
    , mypage_date            date default sysdate not null  -- 등록날짜
    , constraint PK_mypage_mypage_seq PRIMARY KEY(mypage_sequence)
    , constraint FK_mypage_userid foreign key(userid) references mv_member(userid)
    , constraint FK_mypage_my_seq foreign key(my_sequence) references mv_detail(my_sequence)
    ); 
    
    -- 마이페이지 시퀀스
    create sequence mypage_sequence
    start with 1
    increment by 1
    nomaxvalue
    nominvalue
    nocycle
    nocache;
    
    
    -- 작가 팔로우 테이블
    create table follow
    ( mypage_sequence    number          not null -- 마이페이지-시퀀스
    , userid                         varchar2(50)  not null -- 아이디(작가의)
    , constraint FK_follow_mypage_seq foreign key(mypage_sequence) references mypage(mypage_sequence)
    , constraint FK_follow_userid foreign key(userid) references mv_member(userid)
    );


    -- 게시판 종류 테이블 (1.감상문 2. 자유 3. QnA 4. 공지사항)
    create table what_kind_of_b
    ( b_number     number      not null -- 게시판 번호
    , b_name        varchar2(30)  not null -- 게시판 이름
    , constraint PK_what_kind_of_b_num PRIMARY KEY(b_number)
    );
    
    
    -- 게시판 테이블
    create table board
    (board_sequence    number                  not null   -- 글번호
    , b_number              number                  not null   -- 게시판 번호
    , userid                     varchar2(50)          not null   -- 아이디
    , my_sequence         number                                  -- 영화정보
    , nickname               varchar2(50)                            -- 닉네임
    , title                         nvarchar2(200)      not null   -- 제목
    , content                 nvarchar2(200)                       -- 내용
    , view_count             number default 0                  -- 조회수
    , write_date              date default sysdate   not null   -- 작성 날짜 
    , status                     number(1) default 1  not null -- 글삭제여부  1:사용가능한글,  0:삭제된글
    , secret                    number(1) default 0                -- 비밀글 여부 0: 공개글 1: 비밀글
    , recommend           number                                     -- 추천수
    ,constraint  PK_board_seq primary key(board_sequence)
    ,constraint  FK_board_b_number foreign key(b_number) references what_kind_of_b(b_number)
    ,constraint  FK_board_userid foreign key(userid) references mv_member(userid)
    ,constraint  FK_board_my_sequence foreign key(my_sequence) references mv_detail(my_sequence)
    ,constraint  CK_board_status check( status in(0,1) )
    ,constraint  CK_board_secret check( status in(0,1) )
    ); 
    
    -- 게시판 시퀀스
    create sequence board_sequence
    start with 1
    increment by 1
    nomaxvalue
    nominvalue
    nocycle
    nocache;
        
        
    --  댓글테이블
    create table board_comment
    ( comment_sequence     number                        not null   -- 댓글번호
    , board_sequence           number                        not null   -- 원게시물 글번호
    , userid                            varchar2(50)                not null   -- 사용자ID
    , nickname                      varchar2(50)  
    , content                       Nvarchar2(500)            not null   -- 댓글내용
    , writedate                      date default sysdate   not null   -- 작성일자
    , status                            number(1) default 1    not null   -- 글삭제여부 1: 글 존재 0: 글 삭제
    ,constraint PK_board_comment_seq primary key(comment_sequence)
    ,constraint FK_board_comment_userid foreign key(userid) references mv_member(userid)
    ,constraint FK_board_comment_seq foreign key(board_sequence) references board(board_sequence) on delete cascade
    ,constraint CK_board_comment_status check( status in(1,0) )
    );
    
    --  댓글 시퀀스
    create sequence comment_sequence
    start with 1
    increment by 1
    nomaxvalue
    nominvalue
    nocycle
    nocache;
        
        
    -- 첨부파일 테이블
    create table attach
    ( attach_sequence       number            not null   -- 첨부파일-시퀀스
    , board_sequence        number            not null  -- 글번호-시퀀스
    , file_name                    varchar2(255)  not null  --  파일이름
    , org_file_name             varchar2(255)  not null  -- 실제파일이름
    ,constraint PK_attach_seq primary key(attach_sequence)
    ,constraint FK_attach_board_seq foreign key(board_sequence) references board(board_sequence)
    );
    
    -- 첨부파일 시퀀스
    create sequence attach_sequence
    start with 1
    increment by 1
    nomaxvalue
    nominvalue
    nocycle
    nocache;
    
    
