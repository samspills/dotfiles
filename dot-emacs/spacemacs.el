(setq package-archives '(("gnu" . "https://elpa.gnu.org/packages/")
                         ("melpa" . "https://melpa.org/packages/")))
(package-refresh-contents)

(unless (package-installed-p 'use-package)
  (package-install 'use-package))

(eval-when-compile
  (require 'use-package))

(use-package general
  :ensure g
  :defer nil
  :config (general-evil-setup t))

(setq use-package-always-ensure t)

(customize-set-variable 'use-package-always-defer t)

(customize-set-variable 'load-prefer-newer t)
(use-package auto-compile
  :defer nil
  :config (auto-compile-on-load-mode))

(setq gc-cons-threshold 10000000)

;; Restore after startup
(add-hook 'after-init-hook
          (lambda ()
            (setq gc-cons-threshold 1000000)
            (message "gc-cons-threshold restored to %S"
                     gc-cons-threshold)))

(defun find-config ()
  "Edit config.org"
  (interactive)
  (find-file "~/dotfiles/dot-emacs/spacemacs.org"))

(spacemacs/set-leader-keys "f e c" 'find-config)

(use-package exec-path-from-shell
  :config
  (exec-path-from-shell-initialize)
  (add-to-list 'exec-path "/usr/local/bin"))

(spacemacs/declare-prefix "o" "sam")

(use-package auth-source)
(use-package auth-source-pass
  :after auth-source
  :defer nil
  :init
    (auth-source-pass-enable)
    (setq auth-source-debug t)
    (setq auth-sources '(password-store)))

(spacemacs/set-leader-keys "SPC" 'avy-goto-char-timer) ;; SPC-SPC then start typing a word

(setq custom-file "~/.emacs.d/custom.el")

(setq electric-indent-mode -1)
(add-hook 'after-change-major-mode-hook (lambda() (electric-indent-mode -1)))

(use-package golden-ratio
  :custom
  (golden-ratio-auto-scale t))

(setq create-lockfiles nil ; I don't care about locking files
      make-backup-files nil ; I don't like cleaning up backup-files
      user-full-name "Sam Pillsworth" ; my name
      ns-use-srgb-colorspace nil ; makes powerline separators look right
      ns-pop-up-frames nil
      split-height-threshold nil ; this line and next force preference for vertical splits
      split-width-threshold 0
      fill-column 100 ; fill in all buffers after 100 chars, overridden in specific lang settings
)

(spacemacs/toggle-indent-guide-globally-on)

(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))

(use-package tracking
  :preface
  (defvar tracking-mode-line-buffers)
  :config
  (spaceline-define-segment weetrack
    "weechat tracking"
    (when tracking-mode-line-buffers
      (powerline-raw tracking-mode-line-buffers))))

(use-package spaceline
  :init
  :config
  (spaceline-spacemacs-theme 'weetrack)
  (spaceline-toggle-minor-modes-off)
  (spaceline-toggle-major-mode-off)
  (spaceline-toggle-purpose-off)
  (spaceline-toggle-buffer-size-off)
  (spaceline-toggle-org-pomodoro-on)
  (spacemacs/toggle-display-time-on))

(server-start)

(defvar sam/org-dir "~/Documents/life/")
(use-package org
  :mode ("\\.org\\|org_archive\\'" . org-mode)
  :general
 (:prefix dotspacemacs-leader-key
  :states 'normal
          "oc" 'org-capture
          "os" 'org-attach-screenshot
          "od" 'org-agenda-daily-dashboard
          "ol" 'org-store-link
          "or" 'org-rubikloud
          "oj" 'org-journal
          "op" 'org-pomodoro
          "oi" 'org-clock-in
          "oo" 'org-clock-out)
  :custom
  (org-startup-indented t)
  (org-startup-folded t)
  (org-directory sam/org-dir)
  (org-agenda-files (list sam/org-dir))
  (org-outline-path-complete-in-steps nil)
  (org-refile-use-outline-path t)
  (org-refile-targets '((nil :maxlevel . 9)
                        (org-agenda-files :maxlevel . 9)))

  (org-drawers '("PROPERTIES" "LOGBOOK"))
  (org-hide-emphasis-markers t)
  (org-edit-src-content-indentation 0)
  (org-src-preserve-indentation t)
  (org-src-fontify-natively t)
  (org-src-tab-acts-natively t)
  (org-confirm-babel-evaluate nil)
  :custom-face

  :hook
  (org-mode . (lambda () (hl-todo-mode -1)))
  (org-mode . (lambda () (set-fill-column 80)))
  (org-mode . turn-on-auto-fill)
  (org-babel-after-execute . org-redisplay-inline-images)
  (org-mode . (lambda () (add-hook 'after-save-hook 'org-babel-tangle
                                   'run-at-end 'only-in-org-mode)))
  (org-babel-pre-tangle  . (lambda ()
                             (setq sam/pre-tangle-time (current-time))))
  (org-babel-post-tangle . (lambda ()
                             (message "org-babel-tangle took %s"
                                             (format "%.2f seconds"
                                                     (float-time (time-since sam/pre-tangle-time))))))
  :config
  (setq org-todo-keyword-faces
        '(
          ("TODO" :foreground "#ce537a" :weight bold)
          ("DEADLINE" :foreground "#ce537a" :weight bold)
          ("NEXT" :foreground "#bc6ec5" :weight bold)
          ("STARTED" :foreground "#bc6ec5" :weight bold)
          ("DONE" :foreground "#2aa1ae" :weight bold)
          ("HOLD" :foreground "#4f97d7" :weight bold)
          ("WAITING" :foreground "#4f97d7" :weight bold)
          ("CANCELLED" :foreground "#2d9574" :weight bold)
          ("MEETING" :foreground "#5d4d7a" :weight bold)
          ))
  (setq org-todo-keywords
        (quote ((sequence "TODO(t)" "NEXT(n)" "STARTED(s)" "DEADLINE(D)" "|" "DONE(d!)")
                (sequence "HOLD(h!)" "WAITING(w@/!)" "|" "CANCELLED(c@/!)" "MEETING(m)"))))
  (org-babel-do-load-languages 'org-babel-load-languages
                                 '((emacs-lisp . t)
                                   (python . t)
                                   (ipython . t)
                                   (shell . t)
                                   (plantuml . t))))

(defun org-journal (&optional arg)
  (interactive "P")
  (find-file "~/Documents/life/journal.org"))
(defun org-rubikloud (&optional arg)
  (interactive "P")
  (find-file "~/Documents/life/rubikloud.org"))

(use-package org-capture
  :ensure nil
  :config
  (add-to-list 'org-capture-templates
                `("t" "Work Task" entry (file+headline "~/Documents/life/rubikloud.org" "Projects")
                  "* TODO %^{prompt} :inbox: \n%?"))
   (add-to-list 'org-capture-templates
                `("i" "Interruption" entry (file+olp+datetree "~/Documents/life/rubikloud.org")
                  "* %^{prompt}\n%U\n%?" :clock-in t :clock-resume t))
   (add-to-list 'org-capture-templates
                `("n" "Task Note" entry (file+olp+datetree "~/Documents/life/rubikloud.org")
                  "* %^{prompt} %^G \n%T\n%K\n%?"))
   (add-to-list 'org-capture-templates
                `("r" "Reference" entry (file+headline "~/Documents/life/rubikloud.org" "Reference")
                  "* %^{prompt}\n%U\n%?"))
   (add-to-list 'org-capture-templates
                `("j" "Journal" entry (file+olp+datetree "~/Documents/life/rubikloud.org")
                  "* %^{prompt}\n%U\n%?"))
   (add-to-list 'org-capture-templates
                `("T" "Personal Task" entry (file+olp+datetree "~/Dropbox/life/journal.org")
                  "* TODO %?"))
   (add-to-list 'org-capture-templates
                `("P" "Personal Event" entry (file "~/Documents/life/sam-cal.org")
                  "* %^{Description} \n %^T \n %^{Notes}"))
   (add-to-list 'org-capture-templates
                `("f" "Future Note" entry (file+olp+datetree "~/Documents/life/rubikloud.org")
                  "* %^{prompt} \n%t\n%?" :time-prompt :clock-in t :clock-resume t)))

(use-package org-mac-link
  :ensure nil
  :after org
  :general
  (:prefix dotspacemacs-leader-key
   :states 'normal
           "og" 'org-mac-grab-link))

(use-package org-attach-screenshot
  :custom
  (org-attach-screenshot-command-line "screencapture -i %f")
  :config
  (setq org-attach-screenshot-dirfunction
        (lambda ()
          (progn (assert (buffer-file-name))
                 (concat (file-name-sans-extension (buffer-file-name))
                         "_Art_"))))
)

(defun org-get-target-headline (&optional prompt)
  "Prompt for a location in an org file and jump to it.

This is for promping for refile targets when doing captures."
  (let* ((target (save-excursion
                   (org-refile-get-location prompt nil nil)))
         (file (nth 1 target))
         (pos (nth 3 target))
         )
    (with-current-buffer (find-file-noselect file)
      (goto-char pos)
      (goto-char (org-end-of-subtree)))))

(use-package org-agenda
  :ensure nil
  :custom
  (org-agenda-prefix-format " %T %t %s")
  (org-agenda-skip-scheduled-if-done t)
  (org-agenda-skip-deadline-if-done t)
  (org-agenda-skip-deadline-prewarning-if-scheduled 'pre-scheduled)
  (org-agenda-log-mode-items '(closed state)) ; don't show state changes
  (org-agenda-start-with-log-mode t)
  (org-enforce-todo-dependencies t)
  (org-enforce-todo-checkbox-dependencies nil)
  (org-agenda-tags-column -100)
  :config
  (setq org-agenda-custom-commands
        (quote (("d" "Daily Dashboard"
                 ((agenda "" ((org-agenda-span 1)
                              (org-agenda-log-mode 1)
                              (org-agenda-include-inactive-timestamps 't)
                              (org-agenda-overriding-header "Today")))
                  (todo "STARTED"
                        ((org-agenda-overriding-header "Started Tasks")))
                  (todo "NEXT"
                        ((org-agenda-overriding-header "Next Tasks")))
                  (tags-todo "github"
                        ((org-agenda-overriding-header "Github Tasks")))
                  (agenda "" ((org-agenda-start-on-weekday nil)
                              (org-agenda-start-day "+1d")
                              (org-agenda-span 7)
                              (org-agenda-overriding-header "Next 7 Days")))
                  (tags "inbox"
                        ((org-agenda-overriding-header "Inbox")))
                  )
                 ((org-agenda-tag-filter-preset '("-habit")))
                 ))))
)

(defun org-agenda-daily-dashboard (&optional arg)
    (interactive "P")
    (org-agenda arg "d"))

(use-package org-gcal
  :custom
  (org-gcal-client-id (auth-source-pass-get "client" "org/org-gcal.el"))
  (org-gcal-client-secret (auth-source-pass-get 'secret "org/org-gcal.el"))
  :config
  (setq org-gcal-file-alist '(("samantha.pillsworth@rubikloud.com" .  "/Users/sam/Documents/life/rubikloud_cal.org"))
        ))

(use-package org-clocking
  :ensure nil
  :custom
  (org-clock-into-drawer t)
  (org-clock-out-remove-zero-time-clocks t)
  :hook
  (org-clock-in-hook . sam/clock-in-started)
  :config
  (defun sam/clock-in-started ()
    (when (not (and (boundp 'org-capture-mode) org-capture-mode))
      (cond
       ((and (member (org-get-todo-state) (list "TODO" "NEXT")))
        (org-todo "STARTED"))))
    )

)

(use-package clocker
    :ensure t
    :config
    (setq clocker-mode 1
          clocker-keep-org-file-always-visible nil
          )
    )

(use-package org-id
  :ensure nil
  :custom
  (org-id-link-to-org-use-id t)
)

(use-package ob-ipython
    ;; XXX org-capture: Capture abort: (json-readtable-error 47)
    ;; 作者假设 jupyter 正常运行，不好
    :disabled
    :homepage https://github.com/gregsexton/ob-ipython
    :ensure t
    ;; :config
    ;; (add-hook 'org-babel-after-execute-hook 'org-display-inline-images 'append)
    :defer t)

(require 'subr-x)
(setq homebrew-plantuml-jar-path
      (expand-file-name (string-trim (shell-command-to-string "brew list plantuml | grep jar"))))

(use-package plantuml-mode
  :custom
  (plantuml-jar-path homebrew-plantuml-jar-path))

(use-package ob-plantuml
  :ensure nil
  :after org
  :custom
  (org-plantuml-jar-path homebrew-plantuml-jar-path))

(use-package org-jira
  :general
  (:prefix dotspacemacs-leader-key
   :states 'normal
           "Ji" 'org-jira-get-issues
           "Jp" 'org-jira-progress-issue-next
           "Jt" 'org-jira-progress-issue
           "Jr" 'org-jira-refresh-issues-in-buffer
           "Jc" 'org-jira-create-issue
           "Js" 'org-jira-create-subtask
           "Jj" 'org-jira-get-subtasks
           "Jk" 'org-jira-update-comment
           "Ju" 'org-jira-update-issue
           "Jw" 'org-jira-update-worklogs-from-org-clocks)
  :custom
  (jiralib-url "https://rubikloud.atlassian.net")
  (sam/jiralib-cookie (auth-source-pass-get 'secret "org/org-jira.el"))
  (jiralib-token
      `("Cookie" . (sam/jiralib-cookie)))
  (org-jira-jira-status-to-org-keyword-alist
   '(("Selected for Development" . "TODO")
     ("To Do" . "NEXT")
     ("In Progress" . "STARTED")
     ("In Review" . "WAITING")
     ("On Hold (Blocked)" . "HOLD")
     ("Done" . "DONE")))
  (org-jira-working-dir "~/Documents/life")
  :config
  (defvar sam/org-jira-org-action-ids-alist
      '(("DS"
         ("21" . "TODO")
         ("31" . "STARTED")
         ("41" . "DONE")
         ("51" . "WAITING")
         ("61" . "TODO"))
        ("LCM"
         ("101" . "HOLD")
         ("111" . "DONE")
         ("81" . "TODO")
         ("41" . "WAITING")
         ("21" . "STARTED"))))
  (defmacro ensure-on-issue (&rest body)
      "Make sure we are on an issue heading, before executing BODY."
      (declare (debug t))
      (declare (indent 'defun))
      `(save-excursion
         (save-restriction
           (widen)
           (unless (looking-at "^\\*\\* ")
             (search-backward-regexp "^\\*\\* " nil t)) ; go to top heading
           (let ((org-jira-id (org-jira-id)))
             (unless (and org-jira-id (string-match (jiralib-get-issue-regexp) (downcase org-jira-id)))
               (error "Not on an issue region!")))
           ,@body)))
  (defun sam/org-jira-todo-hook ()
      "Progress issue workflow."
      (ensure-on-issue
       (org-back-to-heading t)
       (let* (
              (element (org-element-at-point))
              (tag (car (org-element-property :tags element)))
              (status (org-element-property :todo-keyword element))
              (proj-key (replace-regexp-in-string "_.*" "" tag))
              (action (car (rassoc status (cdr (assoc proj-key sam/org-jira-org-action-ids-alist))))))
         (message tag)
         (message proj-key)
         (message status)
         (message action)
         (org-jira-progress-issue-action action))))
  :hook
  (org-after-todo-state-change . sam/org-jira-todo-hook))

(spacemacs/declare-prefix "J" "jira")

(use-package company
  :hook
  (after-init . global-company-mode))

(use-package flycheck
  :custom
  (flycheck-checker 'python-flake8)
  (flycheck-checker-error-threshold 900)
  (flycheck-emacs-lisp-load-path 'inherit)
  :hook
  (after-init . global-flycheck-mode))

(use-package git-gutter
  :config
  (global-git-gutter-mode 't))

;; (use-package lsp-mode
;;   :pin melpa
;;   :init
;;   (require 'lsp-clients)
;;   :custom
;;   (lsp-print-io t)
;;   :config
;;   ()
;;   )

;; (use-package lsp-python-ms
;;   :hook (python-mode . lsp)
;;   :config
;;   ;; for dev build of language server
;;   (setq lsp-python-ms-dir
;;         (expand-file-name "/usr/local/etc/python-language-server/output/bin/Release/")))

(use-package projectile
  :custom
  (projectile-project-search-path '("~/rubikloud"))
)

(eval-after-load 'tramp '(setenv "SHELL" "/bin/bash"))
(setq tramp-default-method "ssh")
