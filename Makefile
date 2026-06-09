.DEFAULT_GOAL := help
PLAYBOOK ?= playbooks/site.yml
LIMIT    ?=
ANSIBLE_LIMIT := $(if $(LIMIT),--limit $(LIMIT),)

.PHONY: help deps lint syntax check ping run

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | \
		awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-10s\033[0m %s\n", $$1, $$2}'

deps: ## requirements.yml のコレクション/ロールを導入
	ansible-galaxy collection install -r requirements.yml
	ansible-galaxy role install -r requirements.yml 2>/dev/null || true

lint: ## ansible-lint を実行
	ansible-lint

syntax: ## playbook の構文チェック(OK時は OK のみ、エラー時は内容を表示)
	@out=$$(ansible-playbook $(PLAYBOOK) --syntax-check 2>&1); \
	if [ $$? -eq 0 ]; then echo "syntax OK"; else echo "$$out"; exit 1; fi

check: ## ドライラン(--check --diff)
	ansible-playbook $(PLAYBOOK) --check --diff $(ANSIBLE_LIMIT)

ping: ## 全ホストへの疎通確認
	ansible all -m ping $(ANSIBLE_LIMIT)

run: ## playbook を実行(例: make run LIMIT=rhel)
	ansible-playbook $(PLAYBOOK) $(ANSIBLE_LIMIT)
