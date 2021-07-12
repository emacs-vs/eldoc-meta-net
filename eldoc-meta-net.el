;;; eldoc-meta-net.el --- Eldoc support for meta-net  -*- lexical-binding: t; -*-

;; Copyright (C) 2021  Shen, Jen-Chieh
;; Created date 2021-07-12 23:32:13

;; Author: Shen, Jen-Chieh <jcs090218@gmail.com>
;; Description: Eldoc support for meta-net
;; Keyword: eldoc c# dotnet sdk
;; Version: 0.1.0
;; Package-Requires: ((emacs "24.3") (meta-net "1.1.0"))
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

(require 'eldoc)
(require 'meta-net)

(defgroup eldoc-meta-net nil
  "Eldoc support for meta-net."
  :prefix "eldoc-meta-net-"
  :group 'tool
  :link '(url-link :tag "Repository" "https://github.com/emacs-vs/eldoc-meta-net"))

(provide 'eldoc-meta-net)
;;; eldoc-meta-net.el ends here
