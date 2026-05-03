#!/bin/bash

# 標準出力(stdout)の出力先を変更
# >(...) はプロセス置換で、コマンドの出力を別プロセスに渡す
# tee:
#  - 出力をファイル(/var/log/userdata.log)に保存しつつ、次のコマンドにも流す
# logger:
#  - syslog に "userdata" というタグ付きでログを送る
#  - -s オプションで標準エラーにも出力
# 2>&1:
#  - 標準エラー(stderr)も標準出力(stdout)と同じ出力先にまとめる
# 2>/dev/console:
#  - logger の標準エラーを EC2 のコンソールログにも出力（トラブルシュート用）
exec > >(tee /var/log/userdata.log | logger -t userdata -s 2>/dev/console) 2>&1



# Shell Options
# e : エラーがあったら直ちにシェルを終了
# u : 未定義変数を使用したときにエラーとする
# o : シェルオプションを有効にする
# pipefail : パイプラインの返り値を最後のエラー終了値にする (エラー終了値がない場合は0を返す)
set -euo pipefail

########################################
# Package Update
########################################
dnf update -y

########################################
# TimeZone
########################################
timedatectl set-timezone Asia/Tokyo

########################################
# Locale & Keymap
########################################
localectl set-locale LANG=ja_JP.UTF-8
localectl set-keymap jp

########################################
# HostName
########################################
hostnamectl set-hostname dev-host

########################################
# NGINX Install
########################################
dnf install nginx -y
cat <<EOF > /usr/share/nginx/html/index.html
<!doctype html>
<html lang="ja">
  <head>
    <meta charset="UTF-8" />
    <title>Cloud-Init Test Page</title>
    <style>
      html,
      body {
        height: 100%;
        margin: 0;
      }
      body {
        display: flex;
        justify-content: center; /* 縦方向中央 */
        align-items: center; /* 横方向中央 */
        font-family: Arial, Helvetica, sans-serif;
        background-color: #f4f4f4;
      }
      .container {
        background: #ffffff;
        padding: 30px 40px;
        border-radius: 6px;
        max-width: 800px;
        box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
        text-align: center;
      }
      h1 {
        color: #333333;
        margin-top: 0;
      }
      p {
        font-size: 14px;
        line-height: 1.6;
      }
    </style>
  </head>

  <body>
    <div class="container">
      <h1>nginx is working!</h1>
      <p>This page was created automatically by cloud-init user-data.</p>
      <p>
        If you are seeing this page, nginx has been installed and started
        successfully.
      </p>
    </div>
  </body>
</html>
EOF
systemctl enable --now nginx

########################################
# CloudWatch Agent Install
########################################
dnf install amazon-cloudwatch-agent -y

cat <<'EOF' > /opt/aws/amazon-cloudwatch-agent/bin/config.json
${cwagent_conf}
EOF

/opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a fetch-config \
-m ec2 -s \
-c file:/opt/aws/amazon-cloudwatch-agent/bin/config.json