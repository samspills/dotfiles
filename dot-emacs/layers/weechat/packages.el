;;; packages.el --- weechat layer packages file for Spacemacs.
;;
;; Copyright (c) 2012-2018 Sylvain Benner & Contributors
;;
;; Author: Sam Pillsworth <srpillsworth@gmail.com>
;; URL: https://github.com/syl20bnr/spacemacs
;;
;; This file is not part of GNU Emacs.
;;
;;; License: GPLv3

;;; Commentary:

;; See the Spacemacs documentation and FAQs for instructions on how to implement
;; a new layer:
;;
;;   SPC h SPC layers RET
;;
;;
;; Briefly, each package to be installed or configured by this layer should be
;; added to `weechat-packages'. Then, for each package PACKAGE:
;;
;; - If PACKAGE is not referenced by any other Spacemacs layer, define a
;;   function `weechat/init-PACKAGE' to load and initialize the package.

;; - Otherwise, PACKAGE is already referenced by another Spacemacs layer, so
;;   define the functions `weechat/pre-init-PACKAGE' and/or
;;   `weechat/post-init-PACKAGE' to customize the package as it is loaded.

;;; Code:

(defconst weechat-packages
  '(weechat
    tracking)
  "The list of Lisp packages required by the weechat layer.

Each entry is either:

1. A symbol, which is interpreted as a package to be installed, or

2. A list of the form (PACKAGE KEYS...), where PACKAGE is the
    name of the package to be installed or loaded, and KEYS are
    any number of keyword-value-pairs.

    The following keys are accepted:

    - :excluded (t or nil): Prevent the package from being loaded
      if value is non-nil

    - :location: Specify a custom installation location.
      The following values are legal:

      - The symbol `elpa' (default) means PACKAGE will be
        installed using the Emacs package manager.

      - The symbol `local' directs Spacemacs to load the file at
        `./local/PACKAGE/PACKAGE.el'

      - A list beginning with the symbol `recipe' is a melpa
        recipe.  See: https://github.com/milkypostman/melpa#recipe-format")

(defun weechat/init-tracking ()
  "Initialize tracking"
  (use-package tracking
    :defer t
    :init
    (evil-leader/set-key
      "ai <SPC>" 'tracking-next-buffer)))

(defun weechat/init-weechat ()
  "Initialize weechat-el"
  (use-package weechat
    :defer t
    :init
    (evil-leader/set-key
      "aiw" 'weechat-connect)
    (setq weechat-modules '(
                            weechat-button
                            weechat-color
                            weechat-tracking
                            ))
    (when (configuration-layer/layer-usedp 'spell-checking)
      (push 'weechat-spelling weechat-modules))
    (when (configuration-layer/layer-usedp 'auto-completion)
      (push 'weechat-complete weechat-modules))
    (setq weechat-auto-monitor-buffers t
          weechat-sync-active-buffer t
          weechat-sync-buffer-read-status t
          weechat-host-default "localhost"
          weechat-port-default 9000
          weechat-tracking-types '(:highlight :message))

    ;; TODO: Have predefined color schemes for spacemacs light
    ;;       and dark themes and set appropriately
    ;; If the highest precedence enabled theme is spacemacs-dark,
    ;; pick colors that fit better with the theme
    (when (eq 'spacemacs-dark (car custom-enabled-themes))
      ;; TODO: Finish tweaking the color list based on the theme
      (setq weechat-color-list '(unspecified
                                 "black"
                                 "dark gray"
                                 "dark red"
                                 "#d70000" ;; "red"
                                 "#67b11d" ;; "dark green"
                                 "#5faf00" ;; "light green"
                                 "brown"
                                 "#875f00" ;; "yellow"
                                 "#268bd2" ;; "dark blue"
                                 "light blue"
                                 "dark magenta"
                                 "magenta"
                                 "dark cyan"
                                 "light cyan"
                                 "gray"
                                 "white")))

    ;; show-smartparens doesn't interact well with this mode
    (add-hook 'weechat-mode-hook 'turn-off-show-smartparens-mode)
    (push 'weechat-mode evil-insert-state-modes)
    :config
    ;; Does this belong here or in the :config of weechat/init-tracking?
    (tracking-mode)))

;;; packages.el ends here
