@echo off
chcp 65001 > nul
echo === 시장조사 매일 자동 실행 ===
echo 시작: %DATE% %TIME%

cd /d "D:\AI 폴더\1.claude\시장조사"

echo.
echo [1/4] 5개 매장 가격 수집...
node "C:\Users\dure\Desktop\AI 폴더\claude\erp-automation\market_research_full.js"
if errorlevel 1 (echo 수집 실패 & goto end)

echo.
echo [2/4] 엑셀 생성...
node "C:\Users\dure\Desktop\AI 폴더\claude\erp-automation\make_xlsx.js"

echo.
echo [3/4] history.js 갱신...
powershell -Command "$j = Get-Content -Raw 'history.json'; 'window.MARKET_HISTORY = ' + $j + ';' | Out-File -Encoding utf8 history.js"

echo.
echo [4/4] GitHub 동기화...
git add .
git -c user.name="sangyoung7730" -c user.email="sangyoung7730@users.noreply.github.com" commit -m "Daily update %DATE%"
git push

:end
echo === 완료: %DATE% %TIME% ===
exit /b 0
