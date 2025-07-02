// 필요한 모듈 불러오기
var createError = require('http-errors');
var express = require('express');
var path = require('path');
var cookieParser = require('cookie-parser');
var logger = require('morgan');
var cors = require('cors'); // CORS 모듈 추가

var indexRouter = require('./routes/index');
var usersRouter = require('./routes/users');

var app = express();

// view engine setup (템플릿 엔진: jade, 필요 없으면 제거 가능)
app.set('views', path.join(__dirname, 'views'));
app.set('view engine', 'jade');

app.use(logger('dev'));
app.use(express.json());
app.use(express.urlencoded({ extended: false }));
app.use(cookieParser());
app.use(express.static(path.join(__dirname, 'public')));
app.use(cors()); // CORS 미들웨어 추가

app.use('/', indexRouter);
app.use('/users', usersRouter);

// === Flutter 연동용 API 엔드포인트 ===
app.get('/api/message', function(req, res) {
  res.json({ message: '이건 백엔드에서 온 데이터입니다.' });
});

// 404 핸들러 (항상 라우터 뒤에 위치해야 함)
app.use(function(req, res, next) {
  next(createError(404));
});

// 에러 핸들러
app.use(function(err, req, res, next) {
  res.locals.message = err.message;
  res.locals.error = req.app.get('env') === 'development' ? err : {};
  res.status(err.status || 500);
  res.render('error');
});

// 서버 실행
app.listen(3000, function() {
  console.log('Express 서버가 3000번 포트에서 실행 중');
});

module.exports = app;
