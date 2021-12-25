(define-module (full-os)
  #:use-module (gnu)
  #:use-module (nongnu packages mozilla)
  #:use-module (gnu services virtualization)
  #:use-module (minimal-os))

(use-package-modules tex libreoffice pdf imagemagick virtualization)

(define-public %my-full-packages
  (append
   (list texlive firefox libreoffice imagemagick qemu virt-manager)
   %my-minimal-packages))

(define-public %my-full-os
  (operating-system
   (inherit %my-minimal-os)
   (packages %my-full-packages)))

%my-full-os
