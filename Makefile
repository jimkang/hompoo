include config.mk

HOMEDIR = $(shell pwd)
PROJECTNAME = hompoo
APPDIR = $(WEBDIR)/$(PROJECTNAME)
SSHCMD = ssh $(USER)@$(SERVER)

sync:
	rsync -avz $(HOMEDIR)/builds/ $(USER)@$(SERVER):$(APPDIR) --exclude .git

pushall: sync
	git push origin main

set-up-app-dir:
	ssh $(USER)@$(SERVER) "mkdir -p $(APPDIR)"
