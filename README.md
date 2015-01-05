mybashrc
========

~/.bashrc で実行するコードを記述する

```bash
# ~/.bashrc
. path/to/mybashrc/bin/mybashrc.sh
```


設定
----

`~/.mybashrc` に書き設定を行う

```bash
mybashrc_local() {
  alias command=path/to/command
  # etc.
}
mybashrc_is_product() {
  if [ $project_root_dir = "path/to/project" ]; then
    is_product=0
  else
    is_product=1
  fi
}
mybashrc_project_root_dir_list() {
  project_root_dir_list=(
    project/root/dir
  )
}


mybashrc_disable_change_window_title() {
	: # disabled=1 ( disable change window title )
}
```

* `mybashrc_local` : 各ホスト用の設定
* `mybashrc_is_product` : is_product に 1 を設定するとプロンプトの色が変わる
* `mybashrc_project_root_dir_list` : パスを列挙するとそのパスの下にいるときにプロンプトの色が変わる

