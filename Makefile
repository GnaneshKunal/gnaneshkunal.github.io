# Makefile for myblog

.PHONY: all publish publish_no_init

all: pub

pub:
								@echo "Publishing... with default Emacs configuration."
								emacs --funcall org-publish-all

publish: publish.el
								@echo "Publishing... with current Emacs configurations."
								emacs --batch --load publish.el --funcall org-publish-all

publish_no_init: publish.el
								@echo "Publishing... with --no-init."
								emacs --batch --no-init --load publish.el --funcall org-publish-all

clean:
								@echo "Cleaning up.."
								@rm -rvf *.elc
								@rm -rvf public/img/* public/*.html public/css/*
								@rm -rvf ~/.org-timestamps/*

touch:
								@echo "Touching files.."
								@touch org/what-are-containers.org
								@touch org/numpy-vs-lists.org
								@touch org/flashing-nodemcu.org
								@touch org/applying-transfer-learning-resnet.org
								@touch org/dumped-spacemacs.org
								@touch org/local-paths.org
								@touch org/using-js-pkgs-without-types.org
								@touch org/why-scala-implicits.org
								@touch org/cpp-recursive-lambdas.org
								@touch org/avahi-docker-non-root.org
								@touch org/in-browsers-we-trust.org

prepare: clean touch

submit:
								@echo "Pushing changes to 'generator' branch"
								git push origin generator --force
release: submit
								@echo "Releasing from 'generator' branch to 'master' branch..."
								git subtree push --prefix=public origin master
								# git push origin `git subtree split --prefix public generator`:master --force
