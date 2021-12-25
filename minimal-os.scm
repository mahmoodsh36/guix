(define-module (minimal-os)
  #:use-module (gnu)
  #:use-module (nongnu packages fonts) ;; for microsoft core web fonts
  #:use-module (base-os))

(use-service-modules desktop xorg)
(use-package-modules gcc sdl node crates-io rust python pdf android fontutils fonts package-management
                     audio commencement python-web python-xyz python base cmake pulseaudio vim
                     emacs sqlite web-browsers admin rsync music linux bittorrent gnome terminals
                     gtk compton wm freedesktop xorg xdisorg compression video image-viewers code
                     emacs-xyz)

(use-modules (packages scrcpy))
(use-modules (packages sxiv))

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
    fontconfig font-fantasque-sans font-dejavu font-microsoft-web-core-fonts
    font-google-noto ;; for emojis

    ;; media
    mpv feh sxiv

    ;; X drivers
    libinput xf86-video-fbdev xf86-video-nouveau
    xf86-video-ati xf86-video-vesa
    ;; X commandline tools
    setxkbmap xclip xset xrdb scrot zip acpi xprop xwininfo
    ;; X desktop
    awesome sxhkd xorg-server picom
    rofi clipit kitty libnotify

    ;; networking tools
    transmission yt-dlp clyrics rsync nmap tcpdump
    qutebrowser nyxt

    ;; data
    sqlite

    ;; other
    emacs the-silver-searcher emacs-geiser emacs-geiser-guile
    zathura zathura-pdf-poppler
    flatpak
    vifm
    adb scrcpy

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
                             #:groups '("adbusers"))
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

%my-minimal-os
