(define-module (packages scrcpy)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (guix packages)
  #:use-module (guix download)
  #:use-module (guix git-download)
  #:use-module (gnu packages pkg-config)
  #:use-module (gnu packages video)
  #:use-module (gnu packages sdl)
  #:use-module (guix build-system meson))

(define-public scrcpy-sources
  (origin
    (method url-fetch)
    (uri (string-append
          "https://github.com/Genymobile/scrcpy/releases/download/v1.16/scrcpy-server-v1.16"))
    (sha256
     (base32
      "0ciq7d4x9qff40a5s35z8wx6w585pwnd3nbvmdh093a9nh2rx9wl"))))

(define-public scrcpy
  (package
    (name "scrcpy-server")
    (version "1.16")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/Genymobile/scrcpy.git")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32
         "1zi0wx621mgal0hkvggg0hnl2ahviwwd3bbahyy4sz3bspkii14j"))))
    (build-system meson-build-system)
    (arguments
     `(#:glib-or-gtk? #f
       #:configure-flags (list
                          (string-append "-Dprebuilt_server="
                                         (assoc-ref %build-inputs "prebuilt-server"))))) 
    (inputs
     `(("sdl" ,sdl2)
       ("prebuilt-server" ,scrcpy-sources)
       ("ffmpeg" ,ffmpeg)))
    (native-inputs
     `(("pkg-config" ,pkg-config)))
    (home-page "https://github.com/Genymobile/scrcpy")
    (synopsis "Share Android screen to your pc")
    (description "scrcpy is an application that provides display and
control of Android devices connected on USB. It does not require root
access.")
    (license license:asl2.0)))

scrcpy
