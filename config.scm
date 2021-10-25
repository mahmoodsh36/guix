(use-modules (gnu) (nongnu packages linux))
(use-modules (gnu) (nongnu packages mozilla))
(use-modules (gnu) (gnu packages base))
(use-modules (guix packages))
(use-modules (guix git-download))
(use-modules (guix build-system gnu))
(use-modules (guix licenses))
(use-modules (guix utils))
(use-modules (gnu system setuid))
(use-service-modules networking desktop xorg sound)
(use-package-modules vim gnome version-control curl wm
                     emacs xorg xdisorg image-viewers terminals
                     gtk rsync cran rust-apps shells bittorrent
                     gnuzilla pulseaudio compton video fonts tmux
                     freedesktop fontutils web-browsers package-management
                     emacs-xyz ssh cmake pkg-config image music photo android
                     glib python-xyz python unicode admin certs linux rust
                     crates-io disk imagemagick file haskell-xyz
                     bootloaders compression node)

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

(operating-system
 (kernel linux)
 (locale "en_US.utf8")
 (host-name "mahmooz")
 (timezone "Asia/Jerusalem")

 (keyboard-layout (keyboard-layout "us" "altgr-intl"))

 (kernel-loadable-modules (list rtl8812au-aircrack-ng-linux-module))

 (bootloader
  (bootloader-configuration
   (bootloader grub-efi-bootloader)
   ;;(timeout 1)
   (targets (list "/boot/efi"))))

 (firmware
  (append (list iwlwifi-firmware)
          %base-firmware))

 (users
  (cons*
   (user-account
    (name "mahmooz")
    (group "users")
    (supplementary-groups '("wheel" "audio" "adbusers"))
    (shell (file-append zsh "/bin/zsh"))
    (home-directory "/home/mahmooz"))
   %base-user-accounts))

 (packages
  (append
   (list
    ;; for https
    nss-certs

    ;; fonts
    fontconfig font-fantasque-sans font-dejavu

    ;; media
    mpv feh sxiv

    ;; X drivers
    libinput xf86-video-fbdev xf86-video-nouveau
    xf86-video-ati xf86-video-vesa
    ;; X commandline tools
    setxkbmap xclip xset xrdb scrot
    ;; X desktop
    awesome sxhkd xorg-server picom
    rofi clipit alacritty

    ;; text editors
    neovim

    ;; shell tools
    curl git zsh tmux transmission bat clyrics
    adb ranger vifm imagemagick file ffmpeg
    youtube-dl unzip

    ;; emacs
    emacs emacs-guix emacs-geiser

    ;; other
    libnotify network-manager rsync pulseaudio pulsemixer firefox
    openssh cmake gnu-make dbus playerctl hostapd flatpak

    ;; programming languages
    python python-pip
    rust rust-cargo-0.53
    node
    )
   %base-packages))

 (sudoers-file
  (plain-file
   "sudoers"
   "root ALL=(ALL) ALL
    %wheel ALL=(ALL) NOPASSWD: ALL"))

 (hosts-file
  (plain-file
   "hosts"
   "10.0.0.50 server
    127.0.0.1 youtube.com
    127.0.0.1 www.youtube.com
    127.0.0.1 instagram.com
    127.0.0.1 www.instagram.com"))

 (services
  (append
   (list (service network-manager-service-type)
         (udev-rules-service 'android android-udev-rules
                             #:groups '("adbusers"))
         (service wpa-supplicant-service-type)
         (service slim-service-type
                  (slim-configuration
                   (auto-login? #t)
                   (default-user "mahmooz")
                   (display ":0")
                   (vt "vt2")
                   (xorg-configuration (xorg-configuration (extra-config (list %xorg-libinput-config))))))
         (service xorg-server-service-type)
         (service alsa-service-type (alsa-configuration
                                     (pulseaudio? #t))))
   %base-services))

 (file-systems
  (cons*
   (file-system
    (device (file-system-label "guix"))
    (mount-point "/")
    (type "ext4"))
   (file-system
    (device (file-system-label "boot"))
    (type "vfat")
    (mount-point "/boot/efi"))
   %base-file-systems)))
