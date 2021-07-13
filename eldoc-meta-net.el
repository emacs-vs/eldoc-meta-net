;;; eldoc-meta-net.el --- Eldoc support for meta-net  -*- lexical-binding: t; -*-

;; Copyright (C) 2021  Shen, Jen-Chieh
;; Created date 2021-07-12 23:32:13

;; Author: Shen, Jen-Chieh <jcs090218@gmail.com>
;; Description: Eldoc support for meta-net
;; Keyword: eldoc c# dotnet sdk
;; Version: 0.1.0
;; Package-Requires: ((emacs "25.1") (meta-net "1.1.0"))
;; URL: https://github.com/emacs-vs/eldoc-meta-net

;; This file is NOT part of GNU Emacs.

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <https://www.gnu.org/licenses/>.

;;; Commentary:
;;
;; Eldoc support for meta-net
;;

;;; Code:

(require 'pcase)
(require 'subr-x)

(require 'eldoc)
(require 'meta-net)

(defgroup eldoc-meta-net nil
  "Eldoc support for meta-net."
  :prefix "eldoc-meta-net-"
  :group 'tool
  :link '(url-link :tag "Repository" "https://github.com/emacs-vs/eldoc-meta-net"))

;;
;; (@* "Util" )
;;

(defun eldoc-meta-net--inside-comment-p ()
  "Return non-nil if it's inside comment."
  (nth 4 (syntax-ppss)))

;;
;; (@* "Core" )
;;

(defun eldoc-meta-net--possible-function-point ()
  "This function get called infront of the opening curly bracket.

For example,

   SomeFunction<TypeA, TypeB>(a, b, c);
                             ^

This function also ignore generic type between < and >."
  (let ((start (point))
        (normal (save-excursion (forward-symbol -1) (point)))
        (generic (save-excursion (search-backward ">" nil t)
                                 (forward-char 1)
                                 (forward-sexp -1)
                                 (forward-symbol -1)
                                 (point)))
        result search-pt)
    (when (<= generic (line-beginning-position))
      (setq generic nil))
    ;; Make sure the result is number to avoid error
    (setq normal (or normal (point))
          generic (or generic (point))
          result (min normal generic))
    (goto-char result)  ; here suppose to be the start of the function name
    ;; We check to see if there is comma right behind the symbol
    (save-excursion
      (forward-symbol 1)
      (setq search-pt (point))
      (when (and (re-search-forward "[^,]*" nil t)
                 (string-empty-p (string-trim (buffer-substring search-pt (point)))))
        (setq result start)))
    (goto-char result)))

(defun eldoc-meta-net--function-name ()
  "Return the function name at point."
  (let* ((right 0) (left 0))
    (while (and (<= left right) (re-search-backward "\\((\\|)\\)" nil t))
      (if (equal (buffer-substring (point) (+ (point) 1)) "(")
          (setq left (+ left 1))
        (setq right (+ right 1))))
    (while (equal (buffer-substring (- (point) 1) (point)) " ")
      (goto-char (- (point) 1))))
  (save-excursion
    (eldoc-meta-net--possible-function-point)
    (unless (eldoc-meta-net--inside-comment-p) (thing-at-point 'symbol))))

(defun eldoc-meta-net--arg-string ()
  "Return argument string."
  (save-excursion
    (when (search-forward "(" nil t)
      (forward-char -1)
      (let ((beg (point)) arg-string)
        (forward-sexp 1)
        (setq arg-string (buffer-substring beg (point)))
        ;; Here we remove everything inside nested arguments
        ;;
        ;; For example,
        ;;
        ;;   Add(a, b, (x, y, z) => {  }, c)
        ;;
        ;; should return,
        ;;
        ;;   (a, b, => , c)
        ;;
        ;; Of course, if you are inside the x y z scope then it would just
        ;; return (x, y, z). This is fine since ElDoc should just only need
        ;; to know the first layer's function.
        (with-temp-buffer
          (insert arg-string)
          (goto-char (1+ (point-min)))
          (while (re-search-forward "[({]" nil t)
            (forward-char -1)
            (let ((start (point)))
              (forward-sexp 1)
              (delete-region start (point))))
          (buffer-string))))))

(defun eldoc-meta-net--arg-boundaries ()
  "Return a list of cons cell represent arguments' boundaries.

The start boundary should either behind of `(` or `,`; the end boundary should
either infront of `,` or `)`.

For example, (^ is start; $ is end)

    Add(var1, var2, var3)
        ^  $ ^   $ ^    $

This function also get called infront of the opening curly bracket.  See
function `eldoc-meta-net--possible-function-point' for the graph."
  (let (boundaries start (max-pt (save-excursion (forward-sexp 1))))
    (save-excursion
      (forward-char 1)
      (setq start (point))
      (while (re-search-forward "[,{()]" max-pt t)
        (pcase (string (char-before))
          ((or "," ")")
           (push (cons start (1- (point))) boundaries)
           (setq start (point)))
          ((or "{" "(") (forward-char -1) (forward-sexp 1)))))
    (reverse boundaries)))

(defun eldoc-meta-net-function ()
  "Main eldoc entry."
  (save-excursion
    (when-let* ((function-name (eldoc-meta-net--function-name))
                (arg-string (eldoc-meta-net--arg-string))
                (arg-bounds (eldoc-meta-net--arg-boundaries))  ; list of cons cell
                (arg-count (length arg-bounds)))
      (jcs-print function-name)
      (jcs-print arg-string)
      (jcs-print arg-bounds)
      (jcs-print arg-count)
      )))

(defun eldoc-meta-net--turn-on ()
  "Start the `eldoc-meta-net' worker."
  (unless meta-net-csproj-current (meta-net-read-project))
  (add-function :before-until (local 'eldoc-documentation-function) #'eldoc-meta-net-function)
  (eldoc-mode 1))

;;;###autoload
(defun eldoc-meta-net-enable ()
  "Turn on `eldoc-meta-net'."
  (interactive)
  (add-hook 'csharp-mode-hook #'eldoc-meta-net--turn-on)
  (add-hook 'csharp-tree-sitter-mode #'eldoc-meta-net--turn-on))

;;;###autoload
(defun eldoc-meta-net-disable ()
  "Turn off `eldoc-meta-net'."
  (interactive)
  (remove-hook 'csharp-mode-hook #'eldoc-meta-net--turn-on)
  (remove-hook 'csharp-tree-sitter-mode #'eldoc-meta-net--turn-on))

(provide 'eldoc-meta-net)
;;; eldoc-meta-net.el ends here
