const https = require('https');
const fs = require('fs');
const express = require('express');
const app = express();
const mysql = require('mysql2'); // MySQL 연결 라이브러리
const cors = require('cors'); // 클라이언트와 서버 간 통신 허용

const options = {
    key: fs.readFileSync('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'),
    cert: fs.readFileSync('path/to/your-cert.pem')
};

app.use(express.json());

https.createServer(options, app).listen(3000, () => {
    console.log('HTTPS 서버가 3000번 포트에서 실행 중입니다.');
});

// 정적 웹페이지 제공 (클리이언트 UI를 서버를 통해 제공 예: public/index.html에 저장된 HTML 페이지가 https://your-domain/index.html로 제공)
app.use(express.static('public'));

// CORS 허용 설정(모든 출처에서 서버에 요청 허용)
// 특정 도메인만 허용 app.use(cors({ origin: 'https://example.com' }));
app.use(cors());

// MySQL 데이터베이스 연결 설정
const db = mysql.createConnection({
    host: 'localhost',        // DB 호스트
    user: 'root',             // MySQL 사용자
    password: '1111', // MySQL 비밀번호
    database: 'merijob_db'   // 데이터베이스 이름
});

// MySQL 연결 확인
db.connect((err) => {
    if (err) {
        console.error('MySQL 연결 오류:', err);
    } else {
        console.log('MySQL 연결 성공');
    }
});

// 질문 데이터를 조회하는 API
app.get('/api/questions', (req, res) => {
    const sql = 'SELECT question FROM interview_questions'; // SQL 쿼리 수정하기
    db.query(sql, (err, results) => {
        if (err) {
            console.error('질문 조회 오류:', err);
            res.status(500).json({ error: '질문 조회 실패' }); // 에러 발생 시 응답
        } else {
            res.json(results); // 성공적으로 데이터를 반환
        }
    });
});

// 자기소개서 데이터를 저장하는 API
app.post('/api/resume', (req, res) => {
    const { resume } = req.body;

    if (!resume || resume.length === 0) {
        return res.status(400).json({ error: '저장할 데이터가 없습니다.' });
    }

    // 기존 데이터를 삭제 후 새 데이터 저장
    const deleteSql = 'DELETE FROM resumes';
    db.query(deleteSql, (deleteErr) => {
        if (deleteErr) {
            console.error('기존 데이터 삭제 오류:', deleteErr);
            return res.status(500).json({ error: '기존 데이터 삭제 실패' });
        }

        const insertSql = 'INSERT INTO resumes (question, answer) VALUES ?';
        const values = resume.map(item => [item.question, item.answer]);

        db.query(insertSql, [values], (insertErr) => {
            if (insertErr) {
                console.error('데이터 저장 오류:', insertErr);
                return res.status(500).json({ error: '데이터 저장 실패' });
            }
            res.status(200).json({ message: '저장 성공' });
        });
    });
});

