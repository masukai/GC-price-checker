# ベースイメージとして軽量なPythonイメージを利用
FROM python:3.11-slim

# 依存パッケージをインストール
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# アプリケーションコードをコピー
COPY app /app
WORKDIR /app

# Cloud Run で実行するエントリポイント
CMD ["gunicorn", "-b", ":$PORT", "main:app"]
