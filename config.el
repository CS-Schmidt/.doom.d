;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;;; Commentary:

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!

;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `after!' block, otherwise Doom's defaults may override your settings. E.g.
;;
;;   (after! PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look up their documentation).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.

;;; Code:

;;;; Completion
;; ----------------------------------------------------------------
(after! which-key
  (setq which-key-idle-delay 0.3))

;;;; Editing
;; ----------------------------------------------------------------
;; Set indentation width.
(setq-default tab-width 2)

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)

;; Configure `fill-column' and show the fill column indicator in file editing
;; major modes.
(setq-default fill-column 80)
(add-hook 'text-mode-hook #'display-fill-column-indicator-mode)
(add-hook 'prog-mode-hook #'display-fill-column-indicator-mode)

;;;; Styling
;; ----------------------------------------------------------------
;; Doom exposes several (optional) variables for controlling fonts. See
;; documentation with  C-h v doom-font' for more information.
(setq doom-font (font-spec :family "Source Code Pro" :size 12 :weight 'medium))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'spacemacs-dark)

;; The `default-frame-alist' variable is a list of frame parameters which
;; control the default appearance and behaviour of all frames in Emacs. By
;; changing the value of the `alpha' parameter we can give each frame a
;; transparency effect.
(add-to-list 'default-frame-alist '(alpha 95 95))

;;;; Org
;; ----------------------------------------------------------------
(after! org
  (setq org-startup-folded t
        org-startup-indented nil
        org-startup-with-inline-images t
        org-startup-with-latex-preview t
        org-tags-column -77
        org-hide-emphasis-markers t
        org-pretty-entities t
        org-fontify-quote-and-verse-blocks t
        ;; The `org-emphasis-regexp-components' variable sets the Regex
        ;; components that will be used to recognize emphasized text in
        ;; `org-mode'. Tweaking this variable can correct odd highlighting
        ;; behavior for text that is meant to be emphasized. This variable
        ;; should be initialized before org package is loaded, org will use it
        ;; instead of the default.
        ;;
        ;; TODO: Simplify the prematch and postmatch strings.
        org-emphasis-regexp-components '("[:space:]({\"[—–-"
                                         "][:space:])}\".?!,;:–—-"
                                         "[:space:]​"
                                         "."
                                         3))
  (defface org-link-id '((t :inherit org-link :underline nil))
                         "Face for org-mode links prefixed with 'id:'."
                         :group 'org-faces)
  (org-link-set-parameters "id" :face 'org-link-id)
  (custom-theme-set-faces 'user
                          '(org-document-title ((t . ((:height 1.4 :underline nil)))))
                          '(org-level-1 ((t . ((:inherit outline-1 :height 1.3)))))
                          '(org-level-2 ((t . ((:inherit outline-2 :height 1.2)))))
                          '(org-level-3 ((t . ((:inherit outline-3 :height 1.1)))))
                          '(org-footnote ((t . ((:weight bold :underline nil))))))
 (customize-set-variable 'org-emphasis-alist '(("*" (:foreground "#bb6dc4" :weight bold))
                                               ("/" (:foreground "#2c9372" :slant italic))
                                               ("_" (:underline t))
                                               ("=" org-verbatim verbatim)
                                               ("~" (:foreground "#cc5279" :background "#171c21"))
                                               ("+" (:strike-through t))))
  (customize-set-variable 'org-format-latex-options '(:foreground default
                                                      :background default
                                                      :scale 1.0
                                                      :html-foreground "Black"
                                                      :html-background "Transparent"
                                                      :html-scale 1.0
                                                      :matchers ("begin" "$1" "$" "$$" "\\(" "\\["))))

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")

(use-package! org-appear
  :after org
  :config
  (add-hook 'org-mode-hook #'org-appear-mode)
  :custom
  (org-appear-autoemphasis t)
  (org-appear-autolinks t)
  (org-appear-inside-latex t))

(use-package! org-modern
  :init
  (global-org-modern-mode)
  :custom
  (org-modern-star '("​" "​" "​" "◈")) ; sets headline stars to empty space
  (org-modern-list '((?- . "•")
                     (?+ . "➤")))
  (org-modern-tag nil)
  (org-modern-table nil)
  (org-modern-horizontal-rule nil))

(use-package! org-inline-anim
  :hook (org-mode-hook . #'org-inline-anim-mode))

(use-package! valign
  :after org
  :config
  (add-hook 'org-mode-hook #'valign-mode))

;;;; Org Roam
;; ----------------------------------------------------------------
(use-package! org-roam
  :config
  (org-roam-db-autosync-mode)
  :custom
  (org-roam-directory (file-truename "~/Study/personal-knowledge-management/")))

(use-package! org-roam-ui
  :after org-roam
  :config
  (setq org-roam-ui-sync-theme t
        org-roam-ui-follow t
        org-roam-ui-update-on-save t
        org-roam-ui-open-on-start t))

(use-package! org-drill
  :after org-roam
  :config
  (setq org-drill-maximum-duration 30)
  (setq org-drill-maximum-items-per-session 40))

;; Org-drill review function.
(defun zzz/org-drill ()
  "Initiates an org-drill review sessions on my org-roam database."
  ;; Interactive.
  ;; Selects from available org mode tags in database.
  (interactive)
  (if (featurep 'org-roam)
      (with-eval-after-load 'org-roam
        (let* ((topics (flatten-tree (org-roam-db-query [:select :distinct tag
                                                         :from tags])))
               (drill (completing-read "Select drill topic: " topics))
               (file-paths (flatten-tree (org-roam-db-query [:select file
                                                             :from nodes
                                                             :inner-join tags
                                                             :on (= nodes:id tags:node-id)
                                                             :where (= tags:tag $s1)]
                                                            drill))))
          (org-drill file-paths)))
    (message "org-roam is not loaded")))


;;;; Other
;; ----------------------------------------------------------------
;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
;; (setq user-full-name "John Doe"
;;       user-mail-address "john@doe.com")

;;; $DOOMDIR/config.el end here
