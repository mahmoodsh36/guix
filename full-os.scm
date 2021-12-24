(define-module (full-os)
  #:use-module (gnu)
  #:use-module (nongnu packages mozilla)
  #:use-module (minimal-os))

(use-package-modules tex libreoffice pdf)

(define-public %my-full-os
  (operating-system
   (inherit %my-minimal-os)
   (packages
    (append
     (list texlive firefox libreoffice)
     %my-minimal-packages))))

%my-full-os
