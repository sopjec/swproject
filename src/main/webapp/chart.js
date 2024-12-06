// 감정 데이터 집계
const emotionData = [
    { type: 'neutral', value: 32 },  // 예시로 neutral의 빈도수
    { type: 'happy', value: 5 },
    { type: 'sad', value: 3 },
    { type: 'angry', value: 1 }
    // 실제 데이터에 맞게 수정 필요
];

// 각 감정의 빈도수 추출
const emotionLabels = emotionData.map(emotion => emotion.type);
const emotionValues = emotionData.map(emotion => emotion.value);

// 감정별 색상 설정
const backgroundColors = [
    'rgba(75, 192, 192, 0.2)',  // neutral - 청록색
    'rgba(255, 205, 86, 0.2)',  // happy - 노란색
    'rgba(201, 203, 207, 0.2)', // sad - 회색
    'rgba(255, 99, 132, 0.2)'   // angry - 빨간색
];
const borderColors = [
    'rgba(75, 192, 192, 1)',
    'rgba(255, 205, 86, 1)',
    'rgba(201, 203, 207, 1)',
    'rgba(255, 99, 132, 1)'
];

// 파이 차트 생성
const ctx = document.getElementById('emotionPieChart').getContext('2d');
const emotionPieChart = new Chart(ctx, {
    type: 'pie', // 차트 종류: 파이 차트
    data: {
        labels: emotionLabels,
        datasets: [{
            data: emotionValues,
            backgroundColor: backgroundColors,
            borderColor: borderColors,
            borderWidth: 1
        }]
    },
    options: {
        responsive: true,
        plugins: {
            legend: {
                position: 'top'
            },
            tooltip: {
                enabled: true
            }
        }
    }
});
