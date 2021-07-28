Ubuntu用のdotfiles。AnsibleでOSと設定を整え、開発ツールは[mise](https://mise.jdx.dev/)で管理します。

初回はAnsibleをUbuntuのパッケージから導入し、このリポジトリで実行します。

```bash
sudo apt update
sudo apt install -y ansible-core
ansible-playbook -i localhost, setup/playbook.yml --ask-become-pass
```

通常ユーザーで実行してください。
リポジトリの配置先は任意です。設定ファイルをリンクするので、セットアップ後もリポジトリを残してください。
完了後はログインし直してfishとDockerグループを反映します。

セットアップの内容とオプションは[playbook](setup/playbook.yml)と[変数](setup/vars.yml)、
開発ツールは[miseの設定](mise/config.toml)を参照してください。
既存の実ディレクトリがリンク先にある場合は、内容を確認して退避してから再実行してください。

一部だけ実行する場合:

```bash
# フォント（fontconfig導入済みの場合）
ansible-playbook -i localhost, setup/playbook.yml --tags fonts
# Codex CLIとClaude Code CLI
ansible-playbook -i localhost, setup/playbook.yml --tags ai-clis
# デスクトップアプリ（amd64）
ansible-playbook -i localhost, setup/playbook.yml --tags desktop-apps --ask-become-pass
# 導入済みのデスクトップアプリを更新
ansible-playbook -i localhost, setup/playbook.yml --tags desktop-apps --ask-become-pass \
  -e update_desktop_apps=true
```

フォントの変更は起動済みのAlacrittyを開き直すと反映されます。
AI CLIを更新するには`--tags ai-clis -e update_ai_clis=true`を指定し、初回の認証は起動後に行います。
以前miseでCodexを導入していた場合は、`mise uninstall codex`で旧版を削除してください。
Codexの設定共有は保留中です。Ansibleは`~/.codex`の設定やルールを配置・リンクしません。

### SSH鍵

SSH接続用とGitHub認証用に別々の鍵を作ります。既存の秘密鍵は上書きしません。
新しい鍵のパスフレーズは対話入力します。空にする場合は入力と確認でそれぞれEnterを押してください。
パスフレーズがない秘密鍵は、ファイルを入手されるとそのまま使われます。

```bash
ansible-playbook -i localhost, setup/playbook.yml --tags ssh-keys
```

鍵の生成中、パスフレーズは同じマシンの他のユーザーからプロセス引数として見える可能性があります。

通常のSSH接続では接続先に`~/.ssh/id_ed25519.pub`の内容を公開鍵として登録します。
GitHubでは`~/.ssh/id_ed25519_github.pub`を認証用の公開鍵として登録します。
秘密鍵（`.pub`が付かないファイル）は共有しないでください。

GitHub用の鍵を選択するため、`~/.ssh/config`に以下を追加します。既存の`Host *`設定がある場合は、その前に追加してください。

```sshconfig
Host github.com
    HostName github.com
    User git
    IdentityFile ~/.ssh/id_ed25519_github
    IdentitiesOnly yes
```

GitHub CLIでログインし、対話画面で`~/.ssh/id_ed25519_github.pub`を選んで登録します。

```bash
gh auth login --git-protocol ssh --web
```

CLIで登録できない場合は、`cat ~/.ssh/id_ed25519_github.pub`で表示した内容を
[GitHubのSSH鍵設定](https://github.com/settings/keys)から「New SSH key」で認証用として登録してください。
登録後、`ssh -T git@github.com`で接続を確認します。初回は表示されたホスト鍵の指紋を
[GitHubの公開指紋](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/githubs-ssh-key-fingerprints)と照合してください。
認証成功時はシェルが提供されない旨が表示され、コマンドの終了コードは1になります。

cargo-release・cargo-watchは任意のグローバルツールです。必要なマシンで以下を実行します。

```bash
ansible-playbook -i localhost, setup/playbook.yml --tags dotfiles,mise \
  -e install_rust_tools=true
```

有効化後は通常の`mise install`・`mise upgrade`でも管理されます。

Dockerとログインシェル変更を省く場合:

```bash
ansible-playbook -i localhost, setup/playbook.yml --ask-become-pass \
  -e '{"install_docker": false, "set_fish_login_shell": false}'
```

設定リンクの更新には`--tags dotfiles`、miseの導入には`--tags dotfiles,mise`を指定できます。
セットアップの再実行は未導入のツールを補います。導入済みツールを最新版に更新するときは、fishで以下を実行します。

```fish
mise self-update --yes
mise upgrade --yes
fisher update
```

バージョンを固定する場合は`mise/config.toml`を編集してください。
Rust betaが必要なプロジェクトでは`mise use rust@beta`で個別に指定できます。
以前のユーザーフォルダー名変更ダイアログは自動実行しません。必要ならデスクトップセッションで
`env LANGUAGE=C LC_MESSAGES=C xdg-user-dirs-gtk-update`を実行してください。

変更内容の確認:

```bash
ansible-playbook -i localhost, setup/playbook.yml --syntax-check
ansible-playbook -i localhost, setup/playbook.yml --check --diff --ask-become-pass
```

チェックモードではフォントのダウンロード・キャッシュ更新、mise・AI CLI・Fisherのインストーラー、GUIアプリのダウンロード・導入、Dockerのサービス操作などは実行しません。
ダウンロードやツールのビルドが成功するかどうかは通常実行で確認してください。
