;; -*- mode: eask; lexical-binding: t -*-

(package "sideline-cider"
         "0.1.0"
         "Show CIDER result with sideline")

(website-url "https://github.com/emacs-sideline/sideline-cider")
(keywords "convenience")

(package-file "sideline-cider.el")

(script "test" "echo \"Error: no test specified\" && exit 1")

(source 'gnu)
(source 'melpa)
(source 'jcs-elpa)

(depends-on "emacs" "28.1")
(depends-on "sideline")
(depends-on "cider")

(setq network-security-level 'low)  ; see https://github.com/jcs090218/setup-emacs-windows/issues/156#issuecomment-932956432
