param (
    [int]$Year = (Get-Date).Year,  # 引数で年を指定（デフォルトは現在の年）
    [int]$Month = (Get-Date).Month # 引数で月を指定（デフォルトは現在の月）
)

# 日付フォーマット関数
function Format-Date ($date) {
    $dayOfWeek = $date.ToString("ddd", [System.Globalization.CultureInfo]::GetCultureInfo("ja-JP"))
    return $date.ToString("M/d") + "($dayOfWeek)"
}

# 出力フォルダを設定
$outputDir = "./WeeklySchedules"
if (-not (Test-Path -Path $outputDir)) {
    New-Item -ItemType Directory -Path $outputDir | Out-Null
}

# 月の初日と月末日を計算
$startDate = Get-Date -Year $Year -Month $Month -Day 1
$endDate = $startDate.AddMonths(1).AddDays(-1)

$currentDate = $startDate
$weekNumber = 1

while ($currentDate -le $endDate) {
    # HTMLのヘッダー
    $html = @"
<!DOCTYPE html>
<html>
<head>
    <title>$Year/$Month</title>
</head>
<body>
    <table>
        <thead>
            <tr>
                <th>日付</th>
                <th>名前</th>
                <th>予定</th>
            </tr>
        </thead>
        <tbody>`n
"@

    # 1週間分の平日のみを追加
    while ($currentDate -le $endDate) {
        $dayOfWeek = $currentDate.DayOfWeek

        # 平日のみテーブルに追加
        if ($dayOfWeek -ne [DayOfWeek]::Saturday -and $dayOfWeek -ne [DayOfWeek]::Sunday) {
            $formattedDate = Format-Date $currentDate
            $html += "            <tr><td>$formattedDate</td><td></td><td></td></tr>`n"
            $html += "            <tr><td></td><td></td><td></td></tr>`n"
            $html += "            <tr><td></td><td></td><td></td></tr>`n"
        }

        # 次の日へ
        $currentDate = $currentDate.AddDays(1)

        # 土曜日になったらループを抜ける
        if ($dayOfWeek -eq [DayOfWeek]::Saturday) {
            break
        }
    }

    # HTMLのフッター
    $html += @"
        </tbody>
    </table>
</body>
</html>
"@

    # ファイル名を生成
    $fileName = "weekly_schedule_${Year}_${Month}_week${weekNumber}.html"
    $filePath = Join-Path $outputDir $fileName

    # ファイルに保存
    Set-Content -Path $filePath -Value $html -Encoding UTF8
    Write-Host "HTMLファイルを生成しました: $filePath"

    # 次の週に進む
    $weekNumber++
}
