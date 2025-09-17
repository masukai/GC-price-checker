import os
import json
from datetime import date, timedelta

from flask import Flask
from google.cloud import bigquery
import requests

app = Flask(__name__)


# BigQueryを利用して前日の料金を集計する関数
# 環境変数 BILLING_TABLE には課金エクスポートテーブルを指定する
# 例: mydataset.gcp_billing_export_v1_xxxxxx

def fetch_cost():
    client = bigquery.Client()
    table = os.environ["BILLING_TABLE"]
    today = date.today()
    yesterday = today - timedelta(days=1)

    query = f"""
        SELECT
          IFNULL(SUM(cost), 0) AS cost
        FROM `{table}`
        WHERE usage_start_time >= '{yesterday}'
          AND usage_start_time < '{today}'
    """

    result = client.query(query).result()
    row = list(result)[0]
    return float(row.cost)


# Google Chat にメッセージを送信する関数
# 環境変数 CHAT_WEBHOOK_URL にはWebhook URLを設定する

def send_to_chat(cost: float):
    url = os.environ["CHAT_WEBHOOK_URL"]
    headers = {"Content-Type": "application/json; charset=UTF-8"}
    message = {"text": f"昨日のGCP料金は $ {cost:.2f} でした。"}
    requests.post(url, headers=headers, data=json.dumps(message))


# Cloud Run から呼び出されるエンドポイント
# スケジューラからHTTPリクエストを受け取り、この関数が実行される

@app.route("/", methods=["POST", "GET"])
def main():
    cost = fetch_cost()
    send_to_chat(cost)
    return "ok"


if __name__ == "__main__":
    app.run(debug=True, host="0.0.0.0", port=int(os.environ.get("PORT", 8080)))
