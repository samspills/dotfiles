;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "Sam Pillsworth"
      user-mail-address "srpillsworth@gmail.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom. Here
;; are the three important ones:
;;
;; + `doom-font'
;; + `doom-variable-pitch-font'
;; + `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;;
;; They all accept either a font-spec, font string ("Input Mono-12"), or xlfd
;; font string. You generally only need these two:
(setq doom-font (font-spec :family "Iosevka Nerd Font" :size 12))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-vibrant)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/Dropbox/life/")

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type 'relative)


;; Here are some additional functions/macros that could help you configure Doom:
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c g k').
;; This will open documentation for it, including demos of how they are used.
;;
;; You can also try 'gd' (or 'C-c g d') to jump to their definition and see how
;; they are implemented.

;;
;;; Additional variable settings
(setq-default fill-column 100)
(setq! fill-column 100)
(setq treemacs-width 32
      lsp-ui-sideline-enable t
      mode-line-default-help-echo nil
      show-help-function nil
      )

;;
;;; Modules

;;; shopify
(use-package! shadowenv
  :hook (after-init . shadowenv-global-mode))

;;; :lang org
(setq org-archive-location (concat org-directory "archive/%s::")
      org-ellipsis " ▼ "
      org-bullets-bullet-list '("☰" "☱" "☲" "☳" "☴" "☵" "☶" "☷" "☷" "☷" "☷")
      ;;; org-capture
      org-capture-inbox-file (expand-file-name "inbox.org" org-directory)
      org-capture-journal-file (expand-file-name "journal.org" org-directory)
      org-capture-templates '(("j" "Journal" entry (file+olp+datetree org-capture-journal-file)
                               "* %U %?\n%i\n%a" :prepend t)
                              ("w" "Web site" entry (file org-capture-inbox-file)
                               "* %(org-web-tools--url-as-readable-org)")
                              ("i" "inbox" entry (file org-capture-inbox-file)
                               "* TODO %?"))
      ;;; org-journal
      org-journal-date-prefix "#+TITLE: "
      org-journal-dir "~/Dropbox/life/braindump/dailies/"
      org-journal-date-format "%A, %d %B %Y"
      org-journal-enable-agenda-integration t
      ;;; org-roam
      org-roam-directory "~/Dropbox/life/braindump"
      org-roam-completion-system 'ivy
      )
(add-hook! 'org-mode-hook #'auto-fill-mode)

(add-hook! 'after-init-hook 'org-roam-mode)


;;; flycheck + lsp
(when (featurep! :lang python +lsp)
  (set-next-checker! 'python-mode 'lsp 'python-mypy)
  (set-next-checker! 'python-mode 'python-mypy 'python-pylint))
