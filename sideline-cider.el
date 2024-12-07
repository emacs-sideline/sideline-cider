;;; sideline-cider.el --- Show CIDER result with sideline  -*- lexical-binding: t; -*-

;; Copyright (C) 2024  Shen, Jen-Chieh

;; Author: Shen, Jen-Chieh <jcs090218@gmail.com>
;; Maintainer: Shen, Jen-Chieh <jcs090218@gmail.com>
;; URL: https://github.com/emacs-sideline/sideline-cider
;; Version: 0.1.0
;; Package-Requires: ((emacs "28.1") (sideline "0.1.0") (cider "1.16.1"))
;; Keywords: convenience

;; This file is not part of GNU Emacs.

;; This program is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program. If not, see <https://www.gnu.org/licenses/>.

;;; Commentary:
;;
;; Show CIDER result with sideline.
;;

;;; Code:

(require 'sideline)
(require 'cider)

(defgroup sideline-cider nil
  "Show CIDER result with sideline."
  :prefix "sideline-cider-"
  :group 'tool
  :link '(url-link :tag "Repository" "https://github.com/emacs-sideline/sideline-cider"))

(defvar sideline-cider--buffer nil
  "Record the evaluation buffer.")

(defvar-local sideline-cider--callback nil
  "Callback to display result.")

(defvar-local sideline-cider--overlay-face nil
  "Face to display overlay.")

;;;###autoload
(defun sideline-cider (command)
  "Backend for sideline.

Argument COMMAND is required in sideline backend."
  (cl-case command
    (`candidates (cons :async
                       (lambda (callback &rest _)
                         (setq sideline-cider--callback callback
                               sideline-cider--buffer (current-buffer)))))
    (`face (or sideline-cider--overlay-face
               'cider-result-overlay-face))))

(defun sideline-cider--result (value _value-type &optional _point overlay-face &rest _)
  "Display the result VALUE."
  (when (and value
             sideline-cider--buffer)
    (with-current-buffer sideline-cider--buffer
      (setq sideline-cider--overlay-face overlay-face)
      (funcall sideline-cider--callback (list (sideline-2str value))))))

(defun sideline-cider--mode ()
  "Add hook to `sideline-mode-hook'."
  (cond (sideline-mode
         (advice-add #'cider--display-interactive-eval-result :override #'sideline-cider--result))
        (t
         (advice-remove #'cider--display-interactive-eval-result #'sideline-cider--result))))

;;;###autoload
(defun sideline-cider-setup ()
  "Setup for `cider'."
  (add-hook 'sideline-mode-hook #'sideline-cider--mode)
  (sideline-cider--mode))  ; Run once

(provide 'sideline-cider)
;;; sideline-cider.el ends here
