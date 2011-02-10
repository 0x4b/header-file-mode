;;; header-file.el --- assign a major mode for header files

;; Copyright (C) 2010
;; Author: Kirk Kelsey

;; This file is *not* a part of GNU Emacs.

;;; License

;; This program is free software; you can redistribute it and/or modify it
;; under the terms of the GNU General Public License as published by the Free
;; Software Foundation; either version 2 of the License, or (at your option)
;; any later version.

;; This program is distributed in the hope that it will be useful, but WITHOUT
;; ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
;; FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for
;; more details.

;; You should have received a copy of the GNU General Public License along with
;; this program; if not, write to the Free Software Foundation, Inc., 59 Temple
;; Place - Suite 330, Boston, MA 02111-1307, USA.

;;; Commentary:

;; By assigning header-file-mode to .h files in auto-mode-alist, header files
;; we be opened in the mode used by the corresponding implementation file (as
;; determined by the `find-file' package). If a corresponding file cannot be
;; found, the mode assigned in `header-file-default-mode' is used. This is not
;; a proper mode in its own right, simply a trampoline to other modes.

;;; Code:
(require 'find-file)

(defconst header-file-mode-version "0.2" "Version of `header-file-mode'.")

(defcustom header-file-default-mode
  'c-mode
"Default mode to use if no match is found for the header file. The value should
  typically be the name of a major mode, but can be any function. This might be
  used to assign another function to do further mode inference.

The value can be set as a directory local variable like:
((nil . ((header-file-default-mode . objc-mode))))"
:group 'files
:type '(function))

;;;###autoload
(defun header-file-mode ()
  "Major mode to select header file major mode based on the mode
used for a matching file (see `ff-other-file-name')."
  (interactive)
  (hack-dir-local-variables)
  (let ((ff-ignore-include t))          ; don't use #include lines...
    (delay-mode-hooks
      (funcall
       (or (assoc-default (or (ff-other-file-name) "")
                          auto-mode-alist
                          (lambda (re other-file) (string-match re other-file))
                          nil)
           (or (and (boundp 'file-local-variables-alist)
                    (cdr (assoc 'header-file-default-mode
                                file-local-variables-alist)))
               header-file-default-mode))))))

(provide 'header-file)
