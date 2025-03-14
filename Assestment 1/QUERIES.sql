SELECT COUNT(*) AS NUM_STUDENT FROM SCORE A
WHERE COURSE_ID = 1000004
AND A.SCORE BETWEEN 75 AND 80
AND A.SCORE < ( 
SELECT MAX(B.SCORE)
FROM SCORE B
WHERE B.STUDENT_ID = A.STUDENT_ID
AND B.SCORE != 1000004
)

SELECT
	B.NAME,
    SUM(CASE WHEN A.SCORE >= 85 AND A.SCORE<= 100 THEN 1 ELSE 0 END) AS [100-85],
    SUM(CASE WHEN A.SCORE >= 70 AND A.SCORE < 85 THEN 1 ELSE 0 END) AS [85-70],
    SUM(CASE WHEN A.SCORE >= 60 AND A.SCORE < 70 THEN 1 ELSE 0 END) AS [70-60],
    SUM(CASE WHEN A.SCORE < 60 THEN 1 ELSE 0 END) AS [<60],
	C.NAME
FROM
    SCORE A
    JOIN COURSE B ON B.COURSE_ID = A.COURSE_ID
    JOIN TEACHER C ON C.TEACHER_ID = B.TEACHER_ID
GROUP BY
    B.NAME,
    C.NAME;

SELECT B.NAME, B.GENDER, A.SCORE
FROM SCORE A
JOIN SCORE A2 ON A.STUDENT_ID = A2.STUDENT_ID
AND A.SCORE = A2. SCORE
AND A.COURSE_ID <> A2.COURSE_ID
JOIN SCORE A3 ON A.STUDENT_ID = A3.STUDENT_ID
AND A.SCORE = A3. SCORE
AND A.COURSE_ID <> A3.COURSE_ID
JOIN STUDENT B ON B.STUDENT_ID = A.STUDENT_ID

WITH SAMESCORE AS (
    SELECT
        B.NAME,
        B.GENDER,
        A.SCORE,
        ROW_NUMBER() OVER (PARTITION BY B.STUDENT_ID ORDER BY A.SCORE DESC) AS rn
    FROM
        SCORE A
        JOIN STUDENT B ON B.STUDENT_ID = A.STUDENT_ID
        JOIN SCORE A2 ON A.STUDENT_ID = A2.STUDENT_ID
                     AND A.SCORE = A2.SCORE
                     AND A.COURSE_ID <> A2.COURSE_ID
)
SELECT
    NAME,
    GENDER,
    SCORE
FROM
    SAMESCORE
WHERE
    rn = 1;