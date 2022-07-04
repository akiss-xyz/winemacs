;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

(global-auto-revert-mode 1)

;; Original:
;;(("TODO" warning bold)
;; ("FIXME" error bold)
;; ("HACK" font-lock-constant-face bold)
;; ("REVIEW" font-lock-keyword-face bold)
;; ("NOTE" success bold)
;; ("DEPRECATED" font-lock-doc-face bold)
;; ("BUG" error bold)
;; ("XXX" font-lock-constant-face bold))

(setq hl-todo-keyword-faces
    '(("TODO" warning bold)
      ("DONE" font-lock-doc-face bold)
      ("IMPROVE" font-lock-doc-face bold)
      ("NOTE" success bold)
      ("REVIEW" font-lock-keyword-face bold)

      ("STUB" font-lock-constant-face bold)
      ("HACK" font-lock-constant-face bold)
      ("TEMP" warning bold)
      ("FIXME" error bold)
      ("BUG" error bold)

      ("NOCOMMIT" error bold)
      ("NODEPLOY" error bold)

      ("DEPRECATED" font-lock-doc-face bold)))

;(after! hl-todo
;
;    (setq hl-todo-keyword-faces
;    '(("TODO" warning bold)
;        ("DONE" font-lock-doc-face bold)
;        ("IMPROVE" font-lock-doc-face bold)
;        ("NOTE" success bold)
;        ("REVIEW" font-lock-keyword-face bold)
;
;        ("STUB" font-lock-constant-face bold)
;        ("HACK" font-lock-constant-face bold)
;        ("TEMP" warning bold)
;        ("FIXME" error bold)
;        ("BUG" error bold)
;
;        ("NOCOMMIT" error bold)
;        ("NODEPLOY" error)
;
;        ("DEPRECATED" font-lock-doc-face bold))))
;
;(setq hl-todo-keyword-faces
;   '(("TODO" warning bold)
;     ("NOCOMMIT" error bold)
;     ("NODEPLOY" error)
;     ("DONE" font-lock-doc-face bold)
;     ("NOTE" success bold)
;     ("IMPROVE" font-lock-doc-face bold)
;     ("REVIEW" font-lock-keyword-face bold)
;
;     ("STUB" font-lock-constant-face bold)
;     ("HACK" font-lock-constant-face bold)
;     ("TEMP" warning bold)
;     ("FIXME" error bold)
;     ("BUG" error bold)
;
;     ("DEPRECATED" font-lock-doc-face bold)))

(setq svg-tag-tags
       '((":TODO:" . ((lambda (tag) (svg-tag-make "TODO" ))))))

(setq user-full-name "John Doe"
      user-mail-address "john@doe.com")

(setq display-line-numbers-type 'relative)

(map! :desc "View jumplist"
      :leader "O"
      #'+ivy/jump-list)

(defun me/insert-item-below-and-escape ()
  (interactive)
  (+org/insert-item-below 1)
  (evil-escape))

(map! :mode org-mode
      :desc "Insert below and escape"
      :nvi
      "C-S-l"
      #'me/insert-item-below-and-escape)

(defun me/insert-item-below ()
  (interactive)
  (+org/insert-item-below 1))

(map! :mode org-mode
      :desc "Insert below"
      :nvi
      "C-l"
      #'me/insert-item-below)

(defun me/insert-item-above-and-escape ()
  (interactive)
  (+org/insert-item-above 1)
  (evil-escape))

(map! :mode org-mode
      :desc "Insert above"
      :nvi
      "C-S-h"
      #'me/insert-item-above-and-escape)

(defun me/insert-item-above ()
  (interactive)
  (+org/insert-item-above 1))

(map! :mode org-mode
      :desc "Insert above"
      :nvi
      "C-h"
      #'me/insert-item-above)

(defun me/org-dwim-at-point ()
  (interactive)
  (+org/dwim-at-point 1)
  ;;(evil-escape)
  )

;; TODO Review this. Conflict with switch buffer C-k.
;;(map! :mode org-mode
;;      :desc "DWIM here"
;;      :nvi
;;      "C-k"
;;      #'me/org-dwim-at-point)

(map! :mode org-mode
      :desc "DWIM here"
      :nvi
      "C-j"
      #'me/org-dwim-at-point)

;(map! :mode org-mode
;      :desc "Insert below"
;      "S-h"
;      #'+org/insert-item-below)

(defun me/open-dir ()
  (interactive)
  (dired "."))

(map! :desc "Dired me"
      :leader "F"
      #'me/open-dir)

(map! :mode dired-mode
      :desc "Go up"
      :nv
      "h"
      #'dired-up-directory)

(map! :mode dired-mode
      :desc "Go in"
      :nv
      "l"
      #'dired-find-file)

(defun throwawayfunction ()
  ())

(use-package! olivetti)

(with-eval-after-load "olivetti"
  (with-eval-after-load "persp-mode"
    (defvar persp-olivetti-buffers-backup nil)
    (add-hook 'persp-before-deactivate-functions
              #'(lambda (fow)
                  (dolist (b (mapcar #'window-buffer
                                     (window-list (selected-frame)
                                                  'no-minibuf)))
                    (with-current-buffer b
                      (when (eq 'olivetti-split-window-sensibly
                                split-window-preferred-function)
                        (push b persp-olivetti-buffers-backup)
                        (remove-hook 'window-configuration-change-hook
                                     #'throwawayfunction t)
                        (setq-local split-window-preferred-function nil)
                        (olivetti-reset-all-windows))))))
    (add-hook 'persp-activated-functions
              #'(lambda (fow)
                  (dolist (b persp-olivetti-buffers-backup)
                    (with-current-buffer b
                      (setq-local split-window-preferred-function
                                  'olivetti-split-window-sensibly)
                      (add-hook 'window-configuration-change-hook
                                #'throwawayfunction nil t)))
                  (setq persp-olivetti-buffers-backup nil)))))

(defun me/centre-the-buffer ()
  (interactive)
  (olivetti-mode)
  (olivetti-set-width 115))

(add-hook 'display-line-numbers-mode-hook #'me/centre-the-buffer)
(add-hook 'org-mode-hook #'me/centre-the-buffer)
(add-hook 'dired-mode-hook #'me/centre-the-buffer)

(setq redisplay-dont-pause t
      scroll-margin 1
      scroll-step 1
      scroll-conservatively 1000
      scroll-preserve-screen-position 1)

(defun pt/split-window-thirds ()
  "Split a window into thirds."
  (interactive)
  (split-window-right)
  (split-window-right)
  (balance-windows))


(map! :desc "Split window into 3"
      :leader "w 3"
      #'pt/split-window-thirds)

(map! :desc "Increase height"
      :leader "w S-j"
      #'evil-window-increase-height)

(map! :desc "Decrease height"
      :leader "w S-k"
      #'evil-window-decrease-height)

(map! :desc "Increase width"
      :leader "w S-l"
      #'evil-window-increase-width)

(map! :desc "Decrease width"
      :leader "w S-h"
      #'evil-window-decrease-width)

(map! :desc "Select buffer"
      "C-k"
      #'+ivy/switch-buffer)

(map! :desc "Select buffer"
      :leader "k"
      #'+ivy/switch-buffer)

;;(+workspace/switch-to INDEX)
(map! :desc "Select tab"
      :leader "l"
      #'+workspace/switch-to)

(setq! initial-major-mode 'org-mode)

;;(setq doom-theme 'my-cyber)
(setq doom-theme 'doom-one)
(setq doom-modeline-enable-word-count nil)
(setq! doom-modeline-height 26)
;; (setq display-line-numbers-type 'nil)

(setq doom-modeline-icon (display-graphic-p))

;; Whether display the icon for `major-mode'. It respects `doom-modeline-icon'.
(setq doom-modeline-major-mode-icon t)

;; Whether display the colorful icon for `major-mode'.
;; It respects `all-the-icons-color-icons'.
(setq doom-modeline-major-mode-color-icon t)

(setq doom-modeline-enable-word-count nil)

;; Whether display the workspace name. Non-nil to display in the mode-line.
(setq doom-modeline-workspace-name nil)

;; Whether display the perspective name. Non-nil to display in the mode-line.
(setq doom-modeline-persp-name t)

;; If non nil the default perspective name is displayed in the mode-line.
(setq doom-modeline-display-default-persp-name nil)

;; If non nil the perspective name is displayed alongside a folder icon.
(setq doom-modeline-persp-icon t)

;; Whether display the `lsp' state. Non-nil to display in the mode-line.
(setq doom-modeline-lsp t)


;; Opacity
;;(set-frame-parameter (selected-frame) 'alpha '(85 . 50))
;;(add-to-list 'default-frame-alist '(alpha . (85 . 50)))

(setq doom-font
      (font-spec
         :family "Iosevka"
         ;;:family "IO Sevka"
         :size 14))

(setq-default tab-width 4)
(setq tab-width 4)

(setq require-final-newline nil)

(map! :desc "Comment selected stuff"
      :nvi
      "C-_"
      #'comment-dwim)

(map! :desc "Comment selected stuff"
      :nvi
      "C-c c"
      #'comment-dwim)

(setq fill-region 100)

(add-to-list 'auto-mode-alist '("\\.pl\\'" . prolog-mode))

(add-to-list 'auto-mode-alist '("\\.jj\\'" . java-mode))

(add-to-list 'auto-mode-alist '("\\.hpp\\'" . cpp-mode))
(add-to-list 'auto-mode-alist '("\\.cc\\'" . cpp-mode))
(add-to-list 'auto-mode-alist '("\\.ccm\\'" . cpp-mode))
(add-to-list 'auto-mode-alist '("\\.cppm\\'" . cpp-mode))

(add-to-list 'auto-mode-alist '("\\.lists\\'" . org-mode))

(add-to-list 'auto-mode-alist '("\\.service\\'" . conf-toml-mode))

(vimish-fold-global-mode 1)

(setq vimish-fold-marks '("region" . "endregion"))

(setq wdired-allow-to-change-permissions t)
(setq wdired-use-interactive-rename t)
(setq wdired-confirm-overwrite t)

(defun me/make-tmux-come-here-and-drop-to-shell ()
  (interactive)
  (ignore-errors (call-process "tmux" nil nil nil "respawn-pane" "-k" "-c" default-directory))
  ;(ignore-errors (call-process "tmux" nil nil nil "respawn-window" "-k" "-c" default-directory))
  ;;(+workspace/delete (+workspace-current-name))
  ;;(+workspaces-delete-associated-workspace-h)
  ;;(workspace-current-name)
  )

;;(defun me/make-tmux-come ()
;;  (interactive)
;;  (ignore-errors (call-process "tmux" nil nil nil
;;                               "respawn-window" "-k"
;;                               "-c" default-directory
;;                               "fish -C te -c fish"))
;;  )

;;(map! :desc "Make tmux come here & drop to shell."
;;      :leader "l"
;;      #'me/make-tmux-come-here-and-drop-to-shell)

;;'(add-hook 'kill-emacs-hook #'me/make-tmux-come-here-and-drop-to-shell)

(defun me/come-and-kill ()
  (interactive)
  (if (display-graphic-p) ;; TODO(akiss) do an if else, if we're in graphical, open term to replace emacs.
      (save-buffers-kill-terminal)
      (progn
        (me/make-tmux-come-here-and-drop-to-shell)
        (save-buffers-kill-terminal)
        ))
  )

;;(map! :desc "Make come, then kill."
;;      :leader "q q"
;;      #'me/come-and-kill)

(map! :desc "Make come, then kill. Quick."
      :leader "Q"
      #'me/come-and-kill)

(map! :desc "Make come, then kill. Quick."
      :leader "DEL"
      #'me/come-and-kill)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")
;; (setq org-hide-emphasis-markers nil)
(setq org-ellipsis " ↯")

;; => Org agenda stuff.
(setq org-agenda-start-with-log-mode t)

(setq org-log-done 'time)
(setq org-log-into-drawer t)

(setq org-tag-alist
      '((:startgroup)
        ;; Mutually exclusive tags go here
        ("uni" . U)
        (:endgroup)
        ;; Non-mutually exclusives go here
        ("lecture" . L)
        ("CS257-ACA" . ACA)

        ("errand" . E)
        ("shopping" . S)
        ("idea" . I)
        ("note" . N)
        ("recurring" . R)
        ("schedule" . S)))

;; Org mode and Latex, sitting in a tree.
(setq org-latex-create-formula-image-program 'dvipng)

(after! org
  ;;(require 'org-bullets)
  (setq! initial-major-mode 'org-mode)

  ;;(map! :desc "Insert below"
  ;;      :nvi
  ;;      "C-j"
  ;;      #'+org/insert-item-below 1)

  ;;(map! :desc "Insert above"
  ;;      :nvi
  ;;      "C-k"
  ;;      #'+org/insert-item-above 1)

  ;;(map! :desc "Do what I mean"
  ;;      :nvi
  ;;      "C-l"
  ;;      #'+org/dwim-at-point)

  (map! :desc "Insert krita sketch"
        :leader "i i"
        #'org-krita-insert-new-image)

  (plist-put org-format-latex-options :scale 1.4)

  ;; (setq org-bullets-bullet-list '("▷" "○" "▱" "◇" "⭔" "⬡"))
  ;; (setq org-bullets-bullet-list '("○" "▱" "⯈" "◇" "⭔" "⬡"))
  ;;(setq org-bullets-bullet-list '("○" "▱" "⯈" "⯁" "⬟" "⭓" "⬢"))
  ;;(setq org-bullets-bullet-list '("⯈" "⯁" "⭓" "⬢"))
    ;; ("⯈" "⯁" "⭓" "⬢")

    ;; -> Org habit
    (require 'org-habit)
  (add-to-list 'org-modules 'org-habit)
  (setq org-habit-graph-column 60)

  ;; -> Shift Enter to open new
  (evil-define-key 'normal evil-normal-state-map
    (kbd "S-<return>")
    '+org/insert-item-below)


  ;; -> Org capture
  (setq org-capture-templates
      '(("i" "Ideas")
         ("ii" "Idea" entry
                (file+olp "~/org/ideas.org" "Inbox")
                ;; Quick explanation of the pattern here:
                ;; %? -> Where the cursor gets placed, e.g. where the text goes
                ;; %U -> Timestamp of when it was created
                ;; %a -> a(ddress) in emacs of where this was made from
                ;; or %i...
                "* IDEA %?\n %U\n %a\n %i"
                :empty-lines 1)

        ("t" "Tasks/Projects")
          ("tt" "Task" entry
                (file+olp "~/org/tasks.org" "Inbox")
                "* TODO %?\n %U\n %a\n %i"
                :empty-lines 1)
          ("ts" "Clocked Subtask" entry
                (clock)
                "* TODO %?\n %U\n %a\n %i"
                :empty-lines 1)

        ("j" "Journal")
          ("jj" "Journal" entry
                (file+olp+datetree "~/org/journal.org")
                "\n* %<%I:%M %p> - Journal :journal:\n\n%?\n\n"
                :empty-lines 1)


        ("s" "Schedule")
          ("ss" "Task" entry
                (file+olp "~/org/schedule.org" "Inbox")
                "* TODO %?\n %U\n %a\n %i"
                :empty-lines 1)

        ("m" "Metrics")
          ("mw" "Weight" table-line
                (file+headline "~/org/metrics.org" "Weight")
                "| %U | %^{Weight} | %^{Notes} |"
                :kill-buffer t)))

  (setq org-agenda-files '("~/org/" "~/Uni/y2"))
  ;;(add-hook 'org-mode-hook (lambda () (org-bullets-mode 1)))
  )

(use-package! org-krita
  :config
  (add-hook 'org-mode-hook 'org-krita-mode))

(org-babel-do-load-languages
 'org-babel-load-languages
 '((prolog . t)))

(add-hook `c++-mode-hook 'lsp)

(map! :map c++-mode-map
      :desc "Switch to other file"
      :leader "c O"
      #'lsp-clangd-find-other-file)

(add-hook `c-mode-hook 'lsp)

(map! :map c-mode
      :desc "Switch to other file"
      :leader "c O"
      #'lsp-clangd-find-other-file)

(defun me/project-compile-with-ivy ()
  (interactive)
  (+ivy/project-compile))

(map! :desc "Compile project"
      :leader "c c"
      #'me/project-compile-with-ivy)

(map! :leader "o e" #'eshell)

(setq org-reveal-root "https://cdn.jsdelivr.net/npm/reveal.js")
