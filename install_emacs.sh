#!/bin/bash

# Install Emacs and essential build tools
sudo apt-get update
sudo apt-get install -y emacs build-essential

# Download a basic Emacs configuration for C++
git clone https://github.com/abingham/emacs-eshell-completions.git ~/.emacs.d
git clone https://github.com/jwiegley/use-package.git ~/.emacs.d/site-lisp/use-package

# Create a minimal init.el configuration
cat > ~/.emacs.d/init.el <<EOF
;; Minimal init.el for C++ development
(require 'package)
(setq package-enable-at-startup nil)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(use-package cc-mode
  :ensure t
  :config
  (setq c-default-style "linux"
        c-basic-offset 4))

(use-package irony
  :ensure t
  :config
  (add-hook 'c++-mode-hook 'irony-mode)
  (add-hook 'c-mode-hook 'irony-mode)
  (add-hook 'irony-mode-hook 'irony-cdb-autosetup-compile-options))

(use-package company-irony
  :ensure t
  :config
  (eval-after-load 'company
    '(add-to-list 'company-backends 'company-irony)))

(use-package flycheck-irony
  :ensure t
  :config
  (eval-after-load 'flycheck
    '(add-hook 'flycheck-mode-hook #'flycheck-irony-setup)))

(use-package irony-eldoc
  :ensure t
  :config
  (add-hook 'irony-mode-hook 'irony-eldoc))
EOF

echo "Emacs setup for C++ development complete."
