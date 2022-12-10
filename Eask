(package "eldoc-meta-net"
         "0.1.0"
         "Eldoc support for meta-net")

(website-url "https://github.com/emacs-vs/eldoc-meta-net")
(keywords "convenience" "eldoc" "c#" "dotnet" "sdk")

(package-file "eldoc-meta-net.el")

(script "test" "echo \"Error: no test specified\" && exit 1")

(source "jcs-elpa")
(source "melpa")

(depends-on "emacs" "26.1")
(depends-on "meta-net")
(depends-on "ht")
(depends-on "csharp-mode")

(development
 (depends-on "ert-runner"))

(setq network-security-level 'low)  ; see https://github.com/jcs090218/setup-emacs-windows/issues/156#issuecomment-932956432
