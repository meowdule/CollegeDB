-- 03-data-types-constraints
-- 데이터 타입과 제약 조건

-- 1. 제약 조건 

-- 1) NOT NULL
-- 기존 TEMP_STUDENT 테이블의 TEMP_STUDENT_NAME 컬럼을 NOT NULL로 설정
ALTER TABLE TEMP_STUDENT 
MODIFY TEMP_STUDENT_NAME VARCHAR(50) NOT NULL COMMENT '임시 학생 이름';

-- 테스트
-- 정상적으로 삽입됨
INSERT INTO TEMP_STUDENT (TEMP_STUDENT_NAME, EMAIL) 
VALUES ('홍길동', 'hong@example.com');

SELECT * FROM TEMP_STUDENT;

-- NOT NULL 위반 (TEMP_STUDENT_NAME이 NULL)
-- ❌ 오류 발생
INSERT INTO TEMP_STUDENT (EMAIL) 
VALUES ('lee@example.com');



-- 2) UNIQUE
-- 기존 TEMP_STUDENT 테이블의 EMAIL 컬럼을 UNIQUE로 설정
ALTER TABLE TEMP_STUDENT 
ADD CONSTRAINT unique_email UNIQUE (EMAIL);

-- 정상적으로 삽입됨
INSERT INTO TEMP_STUDENT (TEMP_STUDENT_NAME, EMAIL) 
VALUES ('이순신', 'lee@example.com');

SELECT * FROM TEMP_STUDENT;

-- UNIQUE 위반 (이메일이 중복됨)
-- ❌ 오류 발생
INSERT INTO TEMP_STUDENT (TEMP_STUDENT_NAME, EMAIL) 
VALUES ('김유신', 'lee@example.com');



-- 3) PRIMARY KEY
-- 새로운 TEMP_DEPARTMENT 테이블 생성
CREATE TABLE TEMP_DEPARTMENT (
    DEPT_ID CHAR(3),
    DEPT_NAME VARCHAR(50)
);

-- 중복된 데이터 삽입 (현재 PK가 없으므로 정상적으로 들어감)
INSERT INTO TEMP_DEPARTMENT (DEPT_ID, DEPT_NAME) 
VALUES ('D01', '컴퓨터공학과'),
		 ('D01', '전자공학과');

SELECT * FROM TEMP_DEPARTMENT;

-- 중복값이 있는 상태에서 PRIMARY KEY 추가 시도 (오류 발생 예상)
ALTER TABLE TEMP_DEPARTMENT 
ADD PRIMARY KEY (DEPT_ID);

-- 위에서 오류 발생하므로, 테이블 초기화 후 다시 진행
TRUNCATE TABLE TEMP_DEPARTMENT;

-- PRIMARY KEY 추가 (정상적으로 추가됨)
ALTER TABLE TEMP_DEPARTMENT 
ADD PRIMARY KEY (DEPT_ID);

-- 중복값 삽입 테스트 (첫 번째는 정상, 두 번째는 오류 발생)
INSERT INTO TEMP_DEPARTMENT (DEPT_ID, DEPT_NAME) 
VALUES ('D01', '컴퓨터공학과');

SELECT * FROM TEMP_DEPARTMENT;

-- PRIMARY KEY 위반 오류 발생
INSERT INTO TEMP_DEPARTMENT (DEPT_ID, DEPT_NAME) 
VALUES ('D01', '전자공학과');



-- 4) FOREIGN KEY
-- TEMP_STUDENT 테이블에 DEPT_ID 속성 추가 (이미 있다면 생략 가능)
ALTER TABLE TEMP_STUDENT 
ADD COLUMN DEPT_ID CHAR(3);

-- FOREIGN KEY 추가 전에 TEMP_STUDENT & TEMP_DEPARTMENT 테이블 초기화
TRUNCATE TABLE TEMP_STUDENT;
TRUNCATE TABLE TEMP_DEPARTMENT;

-- FOREIGN KEY 추가 (TEMP_DEPARTMENT.DEPT_ID를 참조)
ALTER TABLE TEMP_STUDENT 
ADD CONSTRAINT fk_department 
FOREIGN KEY (DEPT_ID) REFERENCES TEMP_DEPARTMENT(DEPT_ID);

-- 정상적인 데이터 삽입 (존재하는 DEPT_ID만 가능)
INSERT INTO TEMP_DEPARTMENT (DEPT_ID, DEPT_NAME) 
VALUES ('D01', '컴퓨터공학과'),
		 ('D02', '전자공학과');

SELECT * FROM TEMP_DEPARTMENT;

INSERT INTO TEMP_STUDENT (TEMP_STUDENT_NAME, EMAIL, DEPT_ID) 
VALUES ('홍길동', 'hong@example.com', 'D01'),
		 ('김유신', 'lee@example.com', 'D02');

SELECT * FROM TEMP_STUDENT;

-- FOREIGN KEY 위반 테스트 (존재하지 않는 학과 코드 사용)
-- 오류 발생 (D99는 TEMP_DEPARTMENT에 존재하지 않음)
INSERT INTO TEMP_STUDENT (TEMP_STUDENT_NAME, EMAIL, DEPT_ID) 
VALUES ('이순신', 'lee@example.com', 'D99');



-- 5) CHECK
-- TEMP_STUDENT 테이블 초기화
TRUNCATE TABLE temp_student;

-- TEMP_STUDENT 테이블에 AGE 속성 추가 (CHECK와 함께)
ALTER TABLE temp_student 
  ADD COLUMN AGE INT COMMENT '나이',
  ADD CONSTRAINT check_age CHECK (AGE > 18);

-- TEMP_STUDENT 테이블의 AGE 속성 CHECK 테스트
-- 정상적으로 삽입됨
INSERT INTO TEMP_STUDENT (TEMP_STUDENT_NAME, EMAIL, DEPT_ID, AGE) 
VALUES ('이순신', 'lee@example.com', 'D02', 20);

SELECT * FROM temp_student;

-- CHECK 위반 (AGE < 18)
INSERT INTO TEMP_STUDENT (TEMP_STUDENT_NAME, EMAIL, DEPT_ID, AGE) 
VALUES ('유관순', 'Yoo@example.com', 'D01', 16);



-- 6) DEFAULT
-- AGE 컬럼에 기본값 20 추가 (CHECK 제약 조건 유지)
ALTER TABLE TEMP_STUDENT 
MODIFY AGE INT DEFAULT 20 COMMENT '나이';

-- AGE 값을 입력하지 않고 데이터 삽입 (DEFAULT 값 적용 여부 테스트)
INSERT INTO TEMP_STUDENT (TEMP_STUDENT_NAME, EMAIL, DEPT_ID) 
VALUES ('홍길동', 'hong@example.com', 'D01');

SELECT * FROM temp_student;

-- 명시적으로 AGE 값을 입력하고 삽입
INSERT INTO TEMP_STUDENT (TEMP_STUDENT_NAME, EMAIL, DEPT_ID, AGE) 
VALUES ('김순신', 'lee2@example.com', 'D02', 25);

SELECT * FROM temp_student;
