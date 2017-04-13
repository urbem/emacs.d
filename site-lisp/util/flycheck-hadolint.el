;;; flycheck-hadolint.el --- Dockerfile linter written in Haskell

;; Copyright (C) 2017 Hang Yan

;; Author: Akiha Senda <hang.yan@hotmail.com>
;; URL: https://github.com/hangyan/flycheck-hadolint
;; Version: 1.0.0
;; Keywords: flycheck,docker,dockerfile
;; Package-Requires: ((flycheck "0.18"))

;; This file is not part of GNU Emacs.

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;; This is extension for Flycheck.

;; This is simple flycheck extension to lint on dockerfile.see:
;; https://github.com/hangyan/hadolint


;;;; Setup

;; (require 'flycheck-hadolint)
;;; Code:

(require 'flycheck)

(flycheck-def-option-var flycheck-hadolint-ignore-rules nil hadolint "Enable disable some rules
Example:
    DL3006
"
                         :type '(repeat (string :tag "rule"))
                         :safe #'flycheck-string-list-p
                         :package-version '(flychedck . "0.18"))

(flycheck-define-checker hadolint "A dockerfile lint use hadolint.

See URL
https://github.com/lukasmartinelli/hadolint "
                         :command ("hadolint" (option-list "--ignore="
                                                           flycheck-hadolint-ignore-rules concat)
                                   source-original)
                         :error-patterns ((warning line-start (file-name) ":" line ":  " (message)
                                                   line-end))
                         :modes (dockerfile-mode))

(add-to-list 'flycheck-checkers 'hadolint 'append)

(provide 'flycheck-hadolint)
;;; flycheck-hadolint.el ends here
