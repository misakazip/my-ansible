# my-ansible

RHEL / Fedora 系(Rocky・AlmaLinux 含む)向けのセットアップ用 Ansible リポジトリ。

## ファイル位置

| パス | 役割 |
| --- | --- |
| `ansible.cfg` | Ansible 設定 |
| `requirements.yml` | 依存コレクション |
| `Makefile` | コマンドのショートカット |
| `inventory/hosts.yml` | 管理対象ホストの定義 |
| `inventory/group_vars/all.yml` | 全ホスト共通の変数 |
| `inventory/host_vars/<host>.yml` | ホスト固有の変数 |
| `playbooks/site.yml` | トップレベル playbook |
| `roles/common/defaults/main.yml` | 変数の既定値 |
| `roles/common/tasks/` | タスク本体(`main.yml` / `setup_sysctl.yml` / `setup_tailscale.yml`) |

## 変数フラグ

`inventory/group_vars/all.yml` または `host_vars/<host>.yml` で上書きする。

| 変数 | 既定 | 説明 |
| --- | --- | --- |
| `common_base_packages` | `[git, curl, vim]` | 導入する基本パッケージ |
| `common_timezone` | `Asia/Tokyo` | タイムゾーン |
| `common_tailscale_enabled` | `false` | `true` で Tailscale を導入・接続 |
| `common_tailscale_authkey` | `""` | 認証キー。**Vault で渡す**(空なら接続スキップ) |
| `common_tailscale_up_args` | `""` | `tailscale up` への追加オプション(例: `--ssh`) |
| `common_ping_disabled` | `false` | `true` で ICMP echo(ping)応答を無効化 |
| `common_tcp_keepalive` | 辞書 | TCP keepalive の sysctl 値 |
| `common_tcp_settings` | 辞書 | TCP チューニングの sysctl 値 |

## コマンドフラグ(Makefile)

| コマンド | 内容 |
| --- | --- |
| `make deps` | 依存コレクション/ロールを導入 |
| `make ping` | 疎通確認 |
| `make syntax` | 構文チェック(OK時は `syntax OK` のみ) |
| `make lint` | ansible-lint |
| `make check` | ドライラン(`--check --diff`) |
| `make run` | playbook を適用 |

- `LIMIT=<group>` で対象を限定: `make run LIMIT=rhel`
- `--tags <tag>` で特定タスクのみ実行: `sysctl` / `tailscale`
- Vault 使用時は `--ask-vault-pass` を付与

## ライセンス

[MIT License](LICENSE) © 2026 misaka
