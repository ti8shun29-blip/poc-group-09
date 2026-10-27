<!DOCTYPE html>
<html lang="zh-TW">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>委婉拒絕主管小工具</title>
    <style>
        :root {
            --bg-color: #f4f7f6;
            --card-bg: #ffffff;
            --text-color: #333333;
            --primary-color: #4a90e2;
            --primary-hover: #357abd;
            --border-color: #e1e8ed;
            --shadow: 0 4px 6px rgba(0, 0, 0, 0.05);
        }

        body {
            font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", Arial, sans-serif;
            background-color: var(--bg-color);
            color: var(--text-color);
            margin: 0;
            padding: 20px;
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
        }

        .container {
            background-color: var(--card-bg);
            border-radius: 12px;
            box-shadow: var(--shadow);
            width: 100%;
            max-width: 600px;
            padding: 30px;
            box-sizing: border-box;
        }

        h1 {
            font-size: 1.5rem;
            margin-top: 0;
            text-align: center;
            color: #2c3e50;
        }

        p.subtitle {
            text-align: center;
            color: #7f8c8d;
            font-size: 0.9rem;
            margin-bottom: 25px;
        }

        .category-selector {
            display: flex;
            gap: 10px;
            margin-bottom: 20px;
            justify-content: center;
            flex-wrap: wrap;
        }

        .btn-category {
            background-color: #eef2f7;
            border: none;
            padding: 8px 14px;
            border-radius: 20px;
            cursor: pointer;
            font-size: 0.85rem;
            color: #555;
            transition: all 0.2s;
        }

        .btn-category.active, .btn-category:hover {
            background-color: var(--primary-color);
            color: white;
        }

        .result-box {
            background-color: #fafbfc;
            border: 1px solid var(--border-color);
            border-radius: 8px;
            padding: 20px;
            min-height: 100px;
            display: flex;
            align-items: center;
            justify-content: center;
            text-align: center;
            font-size: 1.05rem;
            line-height: 1.6;
            margin-bottom: 20px;
            color: #2c3e50;
        }

        .action-buttons {
            display: flex;
            gap: 10px;
        }

        .btn {
            flex: 1;
            padding: 12px;
            border: none;
            border-radius: 6px;
            font-size: 1rem;
            cursor: pointer;
            font-weight: 500;
            transition: background-color 0.2s;
        }

        .btn-primary {
            background-color: var(--primary-color);
            color: white;
        }

        .btn-primary:hover {
            background-color: var(--primary-hover);
        }

        .btn-secondary {
            background-color: #e2e8f0;
            color: #4a5568;
        }

        .btn-secondary:hover {
            background-color: #cbd5e1;
        }

        .toast {
            text-align: center;
            color: #27ae60;
            font-size: 0.85rem;
            margin-top: 10px;
            height: 20px;
            opacity: 0;
            transition: opacity 0.3s;
        }

        .toast.show {
            opacity: 1;
        }
    </style>
</head>
<body>

    <div class="container">
        <h1>🛡️ 委婉拒絕主管小工具</h1>
        <p class="subtitle">職場生存必備，用最高情商說「不」</p>

        <div class="category-selector">
            <button class="btn-category active" onclick="setCategory('all', this)">全部隨機</button>
            <button class="btn-category" onclick="setCategory('workload', this)">工作量爆滿</button>
            <button class="btn-category" onclick="setCategory('priority', this)">卡在優先級</button>
            <button class="btn-category" onclick="setCategory('quality', this)">為品質把關</button>
        </div>

        <div class="result-box" id="resultText">
            點擊下方按鈕，獲取今日的職場高情商拒絕金句！
        </div>

        <div class="action-buttons">
            <button class="btn btn-secondary" onclick="generateExcuse()">換一句</button>
            <button class="btn btn-primary" onclick="copyText()">一鍵複製</button>
        </div>

        <div class="toast" id="toastMsg">已成功複製到剪貼簿！</div>
    </div>

    <script>
        const excuses = [
            { category: 'workload', text: "主管，我很樂意協助這項任務。不過評估目前手頭上的 [專案A] 和 [專案B] 都在衝刺階段，如果接下這個，可能會影響到其他項目的進度。您覺得我應該調整哪部分的優先順序呢？" },
            { category: 'workload', text: "報告主管，目前我手邊的常態工作和待辦事項已經排滿這周的時間了。如果這項任務非常緊急，可能需要請您幫忙指點一下，哪一個現有任務可以先暫停或交接出去？" },
            { category: 'priority', text: "主管，這項任務聽起來很重要。為了確保我能把主要精力放在您先前交代過最重要的 [核心專案] 上，您建議這件新任務的優先級要排在 [核心專案] 的前面嗎？" },
            { category: 'priority', text: "這部分我非常理解您的考量。不過根據目前手邊項目的排程，這週若要兼顧，可能無法達到預期的交付水準。我們可以評估延後到下週，或者縮減範圍來執行嗎？" },
            { category: 'quality', text: "主管，為了確保產出品質，這項工作需要比較完整且專注的時間來處理。如果這幾天插單進來，我擔心兩邊的品質都會打折扣。您看是否能交給對這塊更熟悉的夥伴來處理會更有效率？" },
            { category: 'quality', text: "謝謝主管的信任！但考量到我目前的專業領域與現有專案的匹配度，如果由 [同事名字] 來接手這個任務，或許能更快、更完美地達成您的期望。" }
        ];

        let currentCategory = 'all';

        function setCategory(category, element) {
            currentCategory = category;
            
            // 更新按鈕樣式
            document.querySelectorAll('.btn-category').forEach(btn => btn.classList.remove('active'));
            element.classList.add('active');
            
            generateExcuse();
        }

        function generateExcuse() {
            let filtered = excuses;
            if (currentCategory !== 'all') {
                filtered = excuses.filter(item => item.category === currentCategory);
            }
            
            const randomIndex = Math.floor(Math.random() * filtered.length);
            document.getElementById('resultText').innerText = filtered[randomIndex].text;
        }

        function copyText() {
            const text = document.getElementById('resultText').innerText;
            if (text.includes("點擊下方按鈕")) {
                generateExcuse();
                return;
            }
            
            navigator.clipboard.writeText(text).then(() => {
                const toast = document.getElementById('toastMsg');
                toast.classList.add('show');
                setTimeout(() => {
                    toast.classList.remove('show');
                }, 2000);
            });
        }

        // 初始化先隨機帶入一句
        generateExcuse();
    </script>
</body>
</html>
