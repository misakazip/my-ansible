# common ロール

全ホストに共通する基本セットアップを行うロール(RHEL / Fedora 系専用)。

- 基本パッケージのインストール(dnf)
- システムタイムゾーンの設定
- Tailscale のセットアップ(任意)

## 変数

| 変数 | 既定値 | 説明 |
| --- | --- | --- |
| `common_base_packages` | `[git, curl, vim]` | インストールする基本パッケージ |
| `common_timezone` | `""` | タイムゾーン。空文字なら変更しない(例: `Asia/Tokyo`) |
| `common_tailscale_enabled` | `false` | `true` で Tailscale のインストール・接続を行う |
| `common_tailscale_authkey` | `""` | Tailscale 認証キー。**Vault で渡す**。空なら `tailscale up` をスキップ |
| `common_tailscale_up_args` | `""` | `tailscale up` への追加オプション(例: `--ssh --accept-routes`) |

## 依存

- `community.general` コレクション(`timezone` モジュール)

## 使用例

```yaml
- hosts: rhel
  roles:
    - role: common
      vars:
        common_timezone: Asia/Tokyo
```
