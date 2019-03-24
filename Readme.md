# IssPay

IssPay 是用於服科所聊天機器人的後台，主要用於資料庫的交易管理，前台是透過chatfuel的平台所打造的。

# 主要功能

  - 交易管理
  - 貨品上架
  - 交易查詢
  - 金流管理

### Chatfuel Button JSON API Endpoint
專門用於 chatbot json_url 的 button
> GET api/v1/create_transaction 建立交易
> GET api/v1/delete_transaction 刪除交易
> GET api/v1/pay_all_transaction 還款

### Backend-Server API Endpoint
> GET api/v1/items 列出所有產品
* paremters : category, message_id, response_type(json/chatbot_msg)

### Project Structure

| 資料夾名稱 | 說明 |
| ------ | ------ |
| app/controller | routing的控制 |
| app/services | service object 用於跨model的服務 |
| app/representer | 表現層的object 用於json格式的規範 |
| app/views | html 檔案 |
| app/models | model object 負責處理資料與商業邏輯 |
| app/values | 用於處理數值而非物件的object |
| config | 組態檔案，設定環境變數 |
| spec | 測試檔案 |

### 後台網站
[IssPay](https://isspay.herokuapp.com/)