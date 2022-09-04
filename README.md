# Route53 + S3ホスティングサービスをTerraformで構築する。

## 前提
- 独自ドメインでS3ホスティングすることを想定しているため、構築後はRoute53のネームサーバをドメイン取得サービスにて登録すること

    ### 参考
    https://qiita.com/1_ta/items/b5ae30165d4cefd4e0c1

- S3ホスティングしたサイトへのアクセスはマイIPで制御する。

## 実現したいこと
1. S3ホスティングサービスをTerraformで設定する。
2. Route53よりS3ホスティングサービスのエイリアスレコードをTerraformで設定する。

## システム構成図
構築するシステム構成は以下の通り<br>
<img src="./img/s3_hosting.jpg" alt="AWSシステム構成" title="AWSシステム構成">

## 事前準備
1. ローカル端末にTerraformをインストール
2. ローカル端末にAWS CLIをインストール
3. 以下の権限を有するIAMポリシーに紐づいたIAMユーザーを用意し、ローカル端末でAWS CLIでIAMクレデンシャル情報を設定する。
   1. AmazonS3FullAccess
   2. AmazonRoute53FullAccess

## 使用方法
1. main.tfファイル直下に移動し、以下のコマンドを実行する
    ```
    terraform init
    terraform plan
    terraform apply
    ```

2. 利用を終了したい場合、以下のコマンドで削除する
    ```
    terraform destroy
    ```

## ライセンス
MIT.
