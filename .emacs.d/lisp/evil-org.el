;;; evil-org-mode.el --- evil keybindings for org-mode

;; Copyright: See respective authors
;; Author: See respective commits
;; URL: https://github.com/edwtjo/evil-org-mode.git
;; Git-Repository; git://github.com/edwtjo/evil-org-mode.git
;; Created: 2012-06-14
;; Version: 9999
;; Keywords: evil vim-emulation org-mode key-bindings presets

;; This file is not part of GNU Emacs

;; This program is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program. If not, see <http://www.gnu.org/licenses/>.

;; Known Bugs:
;; See, https://github.com/edwtjo/evil-org-mode/issues

(require 'evil)
(require 'evil-leader)
(require 'org)

(define-minor-mode evil-org-mode
  "Buffer local minor mode for evil-org"
  :init-value nil
  :lighter " EvilOrg"
  :keymap (make-sparse-keymap) ; defines evil-org-mode-map
  :group 'evil-org)

(add-hook 'org-mode-hook 'evil-org-mode) ;; only load with org-mode

(defun evil-org-new-line ()
  (interactive)
  (org-end-of-line)
  (org-return)
  (evil-insert 1))

(defun evil-org-insert-todo-heading ()
  (interactive)
  (org-end-of-line)
  (org-insert-todo-heading nil)
  (evil-insert 1))

;; regular normal state shortcuts.
(evil-define-key 'normal evil-org-mode-map
  "gh" 'outline-up-heading
  "gj" 'org-forward-same-level
  "gk" 'org-backward-same-level
  "gl" 'outline-next-visible-heading
  "H" 'org-beginning-of-line
  "L" 'org-end-of-line
  "t" 'org-todo
  "T" 'evil-org-insert-todo-heading
  "$" 'org-end-of-line
  "^" 'org-beginning-of-line
  "-" 'org-ctrl-c-minus
  "<" 'org-metaleft
  ">" 'org-metaright
  "o" 'evil-org-new-line)

;; leader shortcuts in normal state. (disabled for now)
;; (evil-leader/set-key 'normal evil-org-mode-map
;;   "c" 'org-cycle
;;   "e" 'org-export-dispatch
;;   "n" 'outline-next-visible-heading
;;   "p" 'outline-previous-visible-heading
;;   "t" 'org-set-tags-command
;;   "u" 'outline-up-heading)

;; normal & insert state shortcuts.
(mapcar (lambda (state)
          (evil-define-key state evil-org-mode-map
            (kbd "M-l") 'org-metaright
            (kbd "M-h") 'org-metaleft
            (kbd "M-k") 'org-metaup
            (kbd "M-j") 'org-metadown
            (kbd "M-L") 'org-shiftmetaright
            (kbd "M-H") 'org-shiftmetaleft
            (kbd "M-K") 'org-shiftmetaup
            (kbd "M-J") 'org-shiftmetadown)) '(normal insert))
(provide 'evil-org)
