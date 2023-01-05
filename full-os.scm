(define-module (full-os)
  #:use-module (gnu)
  #:use-module (nongnu packages mozilla)
  #:use-module (nongnu packages chrome)
  #:use-module (gnu packages fonts)
  #:use-module (gnu services virtualization)
  #:use-module (minimal-os))

(use-package-modules tex libreoffice pdf imagemagick virtualization video inkscape)

(define-public %my-full-packages
  (append
   (list
    font-google-noto texlive libreoffice imagemagick qemu
    virt-manager ffmpeg google-chrome-stable inkscape sagemath)
   %my-minimal-packages))

(define-public %my-full-os
  (operating-system
   (inherit %my-minimal-os)
   (packages %my-full-packages)))

%my-full-os