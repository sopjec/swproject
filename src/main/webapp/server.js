const https = require('https');
const fs = require('fs');
const express = require('express');
const app = express();

const options = {
    key: fs.readFileSync('path/to/your-key.pem'),
    cert: fs.readFileSync('path/to/your-cert.pem')
};

app.use(express.static('public'));

https.createServer(options, app).listen(3000, () => {
    console.log('HTTPS 서버가 3000번 포트에서 실행 중입니다.');
});
