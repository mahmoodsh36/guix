(define-module (minimal-os)
  #:use-module (gnu)
  #:use-module (gnu packages fonts)
  #:use-module (base-os)
  #:use-module (guix channels))

(use-service-modules desktop xorg)
(use-package-modules gcc sdl node crates-io rust python pdf android fontutils package-management
                     audio commencement python-web python-xyz python base cmake pulseaudio vim
                     emacs sqlite web-browsers admin rsync music linux bittorrent gnome terminals
                     gtk compton wm freedesktop xorg xdisorg compression video image-viewers code
                     emacs-xyz python-build)

;; (use-modules (packages scrcpy))
;; (use-modules (packages sxiv))

(define %xorg-libinput-config
  "Section \"InputClass\"
  Identifier \"Touchpads\"
  Driver \"libinput\"
  MatchDevicePath \"/dev/input/event*\"
  MatchIsTouchpad \"on\"

  Option \"Tapping\" \"on\"
  Option \"TappingDrag\" \"on\"
  Option \"DisableWhileTyping\" \"on\"
  Option \"MiddleEmulation\" \"on\"
  Option \"ScrollMethod\" \"twofinger\"
EndSection
")

(define-public %my-minimal-packages
  (append
   (list
    ;; fonts
    fontconfig font-fantasque-sans font-dejavu font-iosevka

    ;; media
    mpv feh sxiv

    ;; X drivers
    libinput xf86-video-fbdev xf86-video-nouveau
    xf86-video-ati xf86-video-vesa
    ;; X commandline tools
    setxkbmap xclip xset xrdb scrot zip acpi xprop xwininfo xdg-utils
    ;; X desktop
    awesome sxhkd xorg-server picom
    rofi clipit kitty libnotify

    ;; networking tools
    transmission yt-dlp clyrics rsync nmap tcpdump
    qutebrowser nyxt network-manager-applet

    ;; other
    emacs the-silver-searcher emacs-geiser emacs-geiser-guile
    zathura zathura-pdf-poppler
    flatpak
    vifm
    adb ;;scrcpy
    sqlite

    ;; audio/bluetooth
    pulseaudio pulsemixer pipewire
    bluez

    ;; build tools
    cmake gnu-make

    ;; programming languages
    python python-pip python-flask python-requests python-pyaudio
    ;;rust rust-cargo-0.53
    node
    sdl2 gcc-toolchain)
   %my-base-packages))

(define-public %my-channels
  (append
   (list
    ;; (channel
    ;;  (name 'guix-science)
    ;;  (url "https://codeberg.org/guix-science/guix-science")
    ;;  (branch "master")
    ;;  (introduction
    ;;   (make-channel-introduction
    ;;    "b1fe5aaff3ab48e798a4cce02f0212bc91f423dc"
    ;;    (openpgp-fingerprint
    ;;     "CA4F 8CF4 37D7 478F DA05  5FD4 4213 7701 1A37 8446"))))
    ;; (channel
    ;;  (name guix-hpc)
    ;;  (url "https://gitlab.inria.fr/guix-hpc/guix-hpc.git"))
    ;; (channel
    ;;   (name 'guix-gaming-games)
    ;;   (url "https://gitlab.com/guix-gaming-channels/games.git")
    ;;   (branch "master")
    ;;   (commit
    ;;     "6d94f531b17fe17957f90ee1ed70a8ebebf57a82")
    ;;   (introduction
    ;;     (make-channel-introduction
    ;;       "c23d64f1b8cc086659f8781b27ab6c7314c5cca5"
    ;;       (openpgp-fingerprint
    ;;         "50F3 3E2E 5B0C 3D90 0424  ABE8 9BDC F497 A4BB CC7F"))))
    ;; (channel
    ;;   (name 'guix-past)
    ;;   ;; (url "https://gitlab.inria.fr/guix-hpc/guix-past")
    ;;   (url "https://codeberg.org/guix-science/guix-past")
    ;;   (branch "master")
    ;;   (commit
    ;;     "8353f5e12b31a6f477956a10f68d271d805a634f")
    ;;   (introduction
    ;;     (make-channel-introduction
    ;;       "0c119db2ea86a389769f4d2b9c6f5c41c027e336"
    ;;       (openpgp-fingerprint
    ;;         "3CE4 6455 8A84 FDC6 9DB4  0CFB 090B 1199 3D9A EBB5"))))
    (channel
     (name 'guix)
     (url "https://codeberg.org/guix/guix-mirror")
     (branch "master")
     (commit
      "e124661486ec722b5c09a94b416f0104b9dde5a4")
     (introduction
      (make-channel-introduction
       "9edb3f66fd807b096b48283debdcddccfea34bad"
       (openpgp-fingerprint
        "BBB0 2DDF 2CEA F6A8 0D1D  E643 A2A0 6DF2 A33A 54FA"))))
    (channel
     (name 'rde)
     (url "https://git.sr.ht/~abcdw/rde")
     (branch "master")
     (commit
      "eaf0ec48cb06ee5dea1f86a502255e14c2b3973b")
     (introduction
      (make-channel-introduction
       "257cebd587b66e4d865b3537a9a88cccd7107c95"
       (openpgp-fingerprint
        "2841 9AC6 5038 7440 C7E9  2FFA 2208 D209 58C1 DEB0"))))
    (channel
     (name 'nonguix)
     (url "https://gitlab.com/nonguix/nonguix")
     (introduction
      (make-channel-introduction
       "897c1a470da759236cc11798f4e0a5f7d4d59fbc"
       (openpgp-fingerprint
        "2A39 3FFF 68F4 EF7A 3D29  12AF 6F51 20A0 22FB B2D5"))))
    ;; (channel
    ;;  (name 'guix-science-nonfree)
    ;;  (url "https://codeberg.org/guix-science/guix-science-nonfree.git")
    ;;  (introduction
    ;;   (make-channel-introduction
    ;;    "58661b110325fd5d9b40e6f0177cc486a615817e"
    ;;    (openpgp-fingerprint
    ;;     "CA4F 8CF4 37D7 478F DA05  5FD4 4213 7701 1A37 8446"))))
    )
   %default-channels))

(define %nonguix-key
  (plain-file "nonguix.pub"
              "(public-key (ecc (curve Ed25519) (q #C1FD53E5D4CE971933EC50C9F307AE2171A2D3B52C804642A7A35F84F3A4EA98#)))"))

(define-public %my-minimal-services
  (append
   (list (udev-rules-service 'android android-udev-rules
                             #:groups '("adbusers"))
         (service slim-service-type
                  (slim-configuration
                   (auto-login? #t)
                   (default-user "mahmooz")
                   (display ":0")
                   (vt "vt2")
                   (xorg-configuration (xorg-configuration (extra-config (list %xorg-libinput-config))))))
         (service xorg-server-service-type)
         ;;(bluetooth-service #:auto-enable? #t)
         )
   %my-base-services))

(define-public %my-minimal-os
  (operating-system
   (inherit %my-base-os)
   (packages %my-minimal-packages)
   (services
    (modify-services
     %my-minimal-services
     (guix-service-type
      config => (guix-configuration
                 (inherit config)
                 (guix (guix-for-channels %my-channels))
                 (authorize-key? #t)
                 (authorized-keys
                  (cons* %nonguix-key
                         %default-authorized-guix-keys))
                 ;; https://libreplanet.org/wiki/Group:Guix/Mirrors
                 (substitute-urls
                  '("https://substitutes.nonguix.org"
                    "https://guix.bordeaux.inria.fr/"
                    "https://hydra-guix-129.guix.gnu.org/"
                    "https://bordeaux-singapore-mirror.cbaines.net/"
                    "https://packages.pantherx.org/"
                    ;; "https://mirror.sjtu.edu.cn/guix/"
                    ;; "http://ci.guix.trop.in"
                    ;; "https://guix.tobias.gr/substitutes/"
                    ;; "http://substitutes.guix.sama.re/"
                    ))
                 (channels %my-channels)
                 ;; (extra-options '("--max-jobs=6"
                 ;;                  "--cores=0"))
                 ))))
   ))

%my-minimal-os