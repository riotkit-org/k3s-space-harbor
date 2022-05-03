wg-meshconf-regen: wg-meshconf-open
	cd ./wg-meshconf && wg-meshconf genconfig

wg-meshconf-init:
	command -v wg-meshconf > /dev/null || pip install --user wg-meshconf
	cd ./wg-meshconf && wg-meshconf init

wg-meshconf-commit: wg-meshconf-regen
	@cd ./wg-meshconf; \
	echo -n "Enter Ansible Vault encryption password: "; read vaultPass; echo -n "$${vaultPass}" > ../.vault-pass; \
	ansible-vault encrypt database.csv --vault-pass-file ../.vault-pass; \
	for file in $$(ls output); do \
	    ansible-vault encrypt output/$${file} --vault-pass-file ../.vault-pass; \
	done

	rm .vault-pass

wg-meshconf-open:
	@if [[ "$$(cat wg-meshconf/database.csv)" == *"ANSIBLE_VAULT;"* ]]; then \
  		ansible-vault decrypt wg-meshconf/database.csv; \
	fi

wg-meshconf-deploy:
	./ansible.sh ./playbook.yaml -i inventory/hosts.yaml --limit vpn
