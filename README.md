# generate-weekly-schedule-html-by-powershell
１週間の予定表HTMLをPowerShellで作成

ChatGPTに作ってもらいました。<br/>
OneNote のページをAPIで作りたかったが、Azureポータルを使うのが嫌だったので、ちょっと捻くれた方式にしてみた。

## 使い方

例)

1. 2025年1月の平日のみのスケジュールを生成<br/>
  `.\GenerateWeeklySchedules.ps1 -Year 2025 -Month 1`<br/>
  WeeklySchedules というフォルダにHTMLが作られる。

1. [Graph Explorer](https://developer.microsoft.com/en-us/graph/graph-explorer) を開く
1. 以下を設定する
    - エンドポイント: `https://graph.microsoft.com/v1.0/me/onenote/pages` を指定する
    - メソッド:  POST
    - ヘッダー
        - Content-Type: application/xhtml+xml
    - ボディ: HTML の中身
1. Run Query をクリックし、終わるまで待つ。（数秒かかる）
