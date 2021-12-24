(define-module (minimal-os)
  #:use-module (gnu)
  #:use-module (base-os))

(use-service-modules desktop xorg)
(use-package-modules gcc sdl node crates-io rust python pdf android fontutils fonts
                     audio commencement python-web python-xyz python base cmake pulseaudio
                     emacs sqlite web-browsers admin rsync music linux bittorrent gnome terminals
                     gtk compton wm freedesktop xorg xdisorg compression video image-viewers)

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
    fontconfig font-fantasque-sans font-dejavu
    font-google-noto ;; for emojis

    ;; media
    mpv feh sxiv

    ;; X drivers
    libinput xf86-video-fbdev xf86-video-nouveau
    xf86-video-ati xf86-video-vesa
    ;; X commandline tools
    setxkbmap xclip xset xrdb scrot zip acpi
    ;; X desktop
    awesome sxhkd xorg-server picom
    rofi clipit kitty libnotify

    ;; networking tools
    transmission yt-dlp clyrics rsync nmap tcpdump
    qutebrowser

    ;; data
    sqlite

    ;; other
    emacs
    zathura zathura-pdf-poppler

    ;; audio/bluetooth
    pulseaudio pulsemixer pipewire
    bluez

    ;; build tools
    cmake gnu-make

    ;; programming languages
    python python-pip python-flask python-requests python-pyaudio
    rust rust-cargo-0.53
    node
    sdl gcc-toolchain)
   %my-base-packages))


(define-public %my-minimal-services
  (append
   (list (udev-rules-service 'android android-udev-rules
                             #:groups '("adb"))
         (service slim-service-type
                  (slim-configuration
                   (auto-login? #t)
                   (default-user "mahmooz")
                   (display ":0")
                   (vt "vt2")
                   (xorg-configuration (xorg-configuration (extra-config (list %xorg-libinput-config))))))
         (service xorg-server-service-type)
         (bluetooth-service #:auto-enable? #t))
   %my-base-services))

(define-public %my-minimal-os
  (operating-system
   (inherit %my-base-os)
   (packages %my-minimal-packages)
   (services %my-minimal-services)))
