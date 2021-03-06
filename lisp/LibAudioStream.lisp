;; ============================================================================================
;; The LibAudioStream Library is Copyright (c) Grame, Computer Music Research Laboratory 03-05
;;
;; Grame : Computer Music Research Laboratory
;; Web : http://www.grame.fr/Research
;; ============================================================================================

;; This file contains definitions for entry points of the LibAudioStream library
;; It must be used with the LibAudioStream.Framework located in /System/Library/Frameworks

(in-package :cl-user)

(defpackage "LibAudioStream"
  (:nicknames "LAS")
  (:use common-lisp))

(in-package :las)

(push :libaudiostream *features*)

(defvar *libaudiostream-pathname* 
  #+win32
  "/WINDOWS/system32/LibAudioStream.dll"
  #+(or darwin macos macosx) 
  "/Library/Frameworks/LibAudioStream.framework/LibAudioStream"
  #+(or linux (and clisp unix (not macos)))
  "/usr/lib/libLibAudioStream.so")

(defvar *libaudiostream* nil)

(defun libaudiostream-framework ()
  (or *libaudiostream*
      (setq *libaudiostream*
            (if (probe-file *libaudiostream-pathname*)
                (progn 
                  (print (concatenate 'string "Loading LibAudioStream library: " (namestring *libaudiostream-pathname*))) 
                  (fli:register-module "LibAudioStream" 
                                       :real-name (namestring *libaudiostream-pathname*)
                                       :connection-style :immediate)
                 ;(cffi:load-foreign-library *libaudiostream-pathname*)
                  (hcl::add-special-free-action 'audio-cleanup) 
                  t)))))

; (hcl::remove-special-free-action 'audio-cleanup)

;;;  (libaudiostream-framework)

;; libsndfile types

(defparameter SF_FORMAT_WAV     #x010000)
(defparameter SF_FORMAT_AIFF	#x020000)
(defparameter SF_FORMAT_AU	#x030000)
(defparameter SF_FORMAT_RAW	#x040000)
(defparameter SF_FORMAT_PAF	#x050000)
(defparameter SF_FORMAT_SVX	#x060000)
(defparameter SF_FORMAT_NIST	#x070000)
(defparameter SF_FORMAT_VOC	#x080000)
(defparameter SF_FORMAT_IRCAM	#x0A0000)
(defparameter SF_FORMAT_W64	#x0B0000)
(defparameter SF_FORMAT_MAT4	#x0C0000)
(defparameter SF_FORMAT_MAT5	#x0D0000)	
(defparameter SF_FORMAT_PCM_S8	#x0001)
(defparameter SF_FORMAT_PCM_16	#x0002)
(defparameter SF_FORMAT_PCM_24	#x0003)
(defparameter SF_FORMAT_PCM_32	#x0004)
(defparameter SF_FORMAT_PCM_U8	#x0005)


;;---------------------------------------------------------------------------------
;;---------------------------------------------------------------------------------
;;
;; 				Player Data Structures
;;
;;---------------------------------------------------------------------------------
;;---------------------------------------------------------------------------------

(defparameter kPortAudioRenderer 0)
(defparameter kJackRenderer 1)
(defparameter kCoreAudioRenderer 2)

(defparameter no_err 0)
(defparameter open_err -1)
(defparameter load_err -2)
(defparameter file_not_found_err -3)
(defparameter state_err -4)

(cffi:defcstruct TChannelInfo 
  (fStatus :long)
  (fCurFrame :long)
  (fVol :float)
  (fPanLeft :float)
  (fPanRight :float)
  (fLeftOut :long)
  (fRightOut :long))


(cffi:define-foreign-type audio-name () ':pointer)
(cffi:define-foreign-type sound-ptr () ':pointer)
(cffi:define-foreign-type effect-ptr () ':pointer)
(cffi:define-foreign-type effectlist-ptr () ':pointer)

(defstruct las-sound (ptr nil))
(defstruct las-effect (ptr nil))
(defstruct las-effectlist (ptr nil))

(defmethod las-null-ptr-p ((obj las-sound))
  (cffi:null-pointer-p (las-sound-ptr obj)))

(defmethod las-null-ptr-p ((obj las-effect))
  (cffi:null-pointer-p (las-effect-ptr obj)))

(defmethod las-null-ptr-p ((obj las-effectlist))
  (cffi:null-pointer-p (las-effectlist-ptr obj)))

(defparameter *ptr-counter* 0)

(defun register-rsrc (obj)
  ;(print (list "new" obj))
  (incf *ptr-counter*)
  (when (> *ptr-counter* 100) (sys::gc-all))
  (hcl::flag-special-free-action obj))

(defmethod audio-cleanup ((obj las-sound))
  (decf *ptr-counter*)
  ;(print (list "clean" obj))
  (DeleteSound obj))

(defmethod audio-cleanup ((obj las-effect))
  (decf *ptr-counter*)
  (DeleteEffect obj))

(defmethod audio-cleanup ((obj las-effectlist))
  (decf *ptr-counter*)
  (DeleteEffectList obj))

(defmethod audio-cleanup ((obj t)) nil)

;;................................................................................: status
(defmacro status (e)
 `(cffi:foreign-slot-value ,e 'TChannelInfo 'fStatus))

;;................................................................................: vol
(defmacro vol (e)
 `(cffi:foreign-slot-value ,e 'TChannelInfo 'fVol))

;;................................................................................: pan
(defmacro panLeft (e)
 `(cffi:foreign-slot-value ,e 'TChannelInfo 'fPanLeft))

(defmacro panRight (e)
 `(cffi:foreign-slot-value ,e 'TChannelInfo 'fPanRight))

;;................................................................................: left-out
(defmacro left-out (e)
 `(cffi:foreign-slot-value ,e 'TChannelInfo 'fLeftOut))

;;................................................................................: right-out
(defmacro right-out (e)
 `(cffi:foreign-slot-value ,e 'TChannelInfo 'fRightOut))


;entrypoints
;................................................................................: LibAudioStream
(cffi:defcfun ("LibVersion" lib-version) :short)

(defun LibVersion () 
 (lib-version))
     

;;; Build sound
;................................................................................: MakeNullSound
(cffi:defcfun ("MakeNullSoundPtr" make-null-sound-ptr) sound-ptr (length :long))

(defun MakeNullSound (length)
  (let ((snd (make-las-sound :ptr (make-null-sound-ptr length))))
    (register-rsrc snd)
    snd))

;................................................................................: MakeReadSound

#-lispworks
(cffi:defcfun  ("MakeReadSoundPtr" make-read-sound-ptr) sound-ptr (s audio-name))

#-lispworks
(defun MakeReadSound (name)
  (cffi:with-foreign-string (s name)
    (let ((snd (make-las-sound :ptr (make-read-sound-ptr s))))
      (register-rsrc snd)
      snd)))

#+lispworks
(fli:define-foreign-function (make-read-sound-ptr "MakeReadSoundPtr")
    ((str (:reference-pass (:ef-mb-string :external-format #+cocoa :macos-roman #-cocoa :latin-1))))
  :result-type :pointer)

#+lispworks
(defun MakeReadSound (name)
  (let ((snd (make-las-sound :ptr (make-read-sound-ptr name))))
    (register-rsrc snd)
    snd))

;................................................................................: MakeRegionSound

#-lispworks
(cffi:defcfun  ("MakeRegionSoundPtr" make-region-sound-ptr) sound-ptr (s audio-name) (begin :long) (end :long))

#-lispworks
(defun MakeRegionSound (name begin end)
  (cffi:with-foreign-string (s name)
    (let ((snd (make-las-sound :ptr (make-region-sound-ptr s begin end))))
    (register-rsrc snd)
    snd)))

#+lispworks
(fli:define-foreign-function (make-region-sound-ptr "MakeRegionSoundPtr")
    ((str (:reference-pass (:ef-mb-string :external-format #+cocoa :macos-roman #-cocoa :latin-1)))
     (begin :long) (end :long))
  :result-type :pointer)

#+lispworks
(defun MakeRegionSound (name begin end)
  (let ((snd (make-las-sound :ptr (make-region-sound-ptr name begin end))))
    (register-rsrc snd)
    snd))


;................................................................................: MakStereoSound
(cffi:defcfun ( "MakeStereoSoundPtr" make-stereo-sound) sound-ptr (sound sound-ptr))

(defun MakeStereoSound (sound)
   (let ((snd (make-las-sound :ptr (make-stereo-sound (las-sound-ptr sound)))))
     (register-rsrc snd)
    snd))

;................................................................................: MakeFadeSound
(cffi:defcfun ("MakeFadeSoundPtr" make-fade-sound-ptr) sound-ptr (sound sound-ptr) (fadein :long) (fadeout :long))

(defun MakeFadeSound (sound fadein fadeout)
   (let ((snd (make-las-sound :ptr (make-fade-sound-ptr (las-sound-ptr sound) fadein fadeout))))
     (register-rsrc snd)
    snd))

;................................................................................: MakeLoopSound
(cffi:defcfun ("MakeLoopSoundPtr" make-loop-sound-ptr) sound-ptr (sound sound-ptr) (len :long))

(defun MakeLoopSound (sound len)
   (let ((snd (make-las-sound :ptr (make-loop-sound-ptr (las-sound-ptr sound) len))))
     (register-rsrc snd)
    snd))
                   

;................................................................................: MakeCutSound
(cffi:defcfun  ("MakeCutSoundPtr" make-cut-sound-ptr) sound-ptr (sound sound-ptr) (begin :long) (end :long))

(defun MakeCutSound (sound begin end)
   (let ((snd (make-las-sound :ptr (make-cut-sound-ptr (las-sound-ptr sound) begin end))))
     (register-rsrc snd)
    snd))

;................................................................................: MakeSeqSound
(cffi:defcfun  ("MakeSeqSoundPtr" make-seq-sound-ptr) sound-ptr (s1 sound-ptr) (s2 sound-ptr) (crossfade :long))

(defun MakeSeqSound (s1 s2 crossfade)
   (let ((snd (make-las-sound :ptr (make-seq-sound-ptr (las-sound-ptr s1) (las-sound-ptr s2) crossfade))))
    (register-rsrc snd)
    snd))


;................................................................................: MakeMixSound
(cffi:defcfun  ("MakeMixSoundPtr" make-mix-sound-ptr) sound-ptr (s1 sound-ptr) (s2 sound-ptr))

(defun MakeMixSound (s1 s2 )
   (let ((snd (make-las-sound :ptr (make-mix-sound-ptr (las-sound-ptr s1) (las-sound-ptr s2)))))
     (register-rsrc snd)
    snd))


;................................................................................: MakeTransformSound
(cffi:defcfun  ( "MakeTransformSoundPtr" make-transform-sound-ptr) sound-ptr (sound sound-ptr) (effectlist effectlist-ptr) (fadein :long) (fadeout :long))

(defun MakeTransformSound (sound effectlist fadein fadeout )
   (let ((snd (make-las-sound :ptr (make-transform-sound-ptr (las-sound-ptr sound) (las-effectlist-ptr effectlist) fadein fadeout))))
     (register-rsrc snd)
    snd))

;................................................................................: MakeWriteSound
(cffi:defcfun  ( "MakeWriteSoundPtr" make-write-sound-ptr) sound-ptr (s audio-name) (sound sound-ptr) (format :long))

(defun MakeWriteSound (name sound format)
   (cffi:with-foreign-string (s name)
     (let ((snd (make-las-sound :ptr (make-write-sound-ptr s (las-sound-ptr sound) format))))
       (register-rsrc snd)
       snd)))
 

;................................................................................: MakeInputSound
(cffi:defcfun  ( "MakeInputSoundPtr" make-input-sound-ptr) sound-ptr)

(defun MakeInputSound ()
   (let ((snd (make-las-sound :ptr (make-input-sound-ptr))))
     (register-rsrc snd)
     snd))
 

;................................................................................: MakeRendererSound
(cffi:defcfun  ( "MakeRendererSoundPtr" make-renderer-sound-ptr) sound-ptr (sound sound-ptr))

(defun MakeRendererSound (sound)
  (let ((snd (make-las-sound :ptr (make-renderer-sound-ptr (las-sound-ptr sound)))))
    (register-rsrc snd)
    snd))

;................................................................................: GetLengthSound
(cffi:defcfun  ( "GetLengthSoundPtr" get-lenght-sound-ptr) :long (sound sound-ptr))

(defun GetLengthSound (sound)
  (get-lenght-sound-ptr (las-sound-ptr sound)))

;................................................................................: GetChannelsSound
(cffi:defcfun  ( "GetChannelsSoundPtr" get-channel-sound-ptr) :long (sound sound-ptr))

(defun GetChannelsSound (sound)
  (get-channel-sound-ptr (las-sound-ptr sound)))

;................................................................................: ResetSound
(cffi:defcfun  ( "ResetSoundPtr" reset-sound-ptr) :void (sound sound-ptr))

(defun ResetSound (sound)
  (reset-sound-ptr (las-sound-ptr sound)))

;................................................................................: ReadSound
(cffi:defcfun  ("ReadSoundPtr" read-sound-ptr) :long (sound sound-ptr) (buffer :pointer) (buffer-size :long) (channels :long))

(defun ReadSound (sound buffer buffer_size channels)
  (read-sound-ptr (las-sound-ptr sound) buffer buffer_size channels))

;................................................................................: DeleteSound
(cffi:defcfun  ( "DeleteSoundPtr" delete-sound) :void (sound sound-ptr))

(defun DeleteSound (sound)
  (delete-sound (las-sound-ptr sound)))


;................................................................................: OpenAudioPlayer
(cffi:defcfun  ("OpenAudioPlayer" open-audio-player) :pointer
                     (inchan :long)
                     (outchan :long)
                     (channels :long)
                     (sr :long)
                     (bs :long)
                     (sbs :long)
                     (rtbs :long)
                     (renderer :long)
                     (thread_num :long))

(defun OpenAudioPlayer (inchan outchan channels sr bs sbs rtbs renderer thread_num)
  (open-audio-player inchan outchan channels sr bs sbs rtbs renderer thread_num))

;;................................................................................: CloseAudioPlayer
(cffi:defcfun  ( "CloseAudioPlayer" close-audio-player) :void (player :pointer))

(defun CloseAudioPlayer (player)
  (close-audio-player player))

;; Channels
;................................................................................: LoadChannel


(cffi:defcfun  ("LoadChannelPtr" load-channel-ptr) :long
   (player :pointer)
   (sound sound-ptr)
   (chan :long)
   (vol :float)
   (panLeft :float)
   (panRight :float))


(defun LoadChannel (player sound chan vol panLeft panRight)
  (load-channel-ptr player (las-sound-ptr sound) chan vol panLeft panRight))


;................................................................................: GetInfoChannel
(cffi:defcfun  ("GetInfoChannel" get-info-channel) :void (player :pointer) (chan :long) (info :pointer))


(defun GetInfoChannel (player chan info) 
  (get-info-channel player chan info))

;; Transport
;................................................................................: StartAudioPlayer
(cffi:defcfun  ("StartAudioPlayer" start-audio-player) :void (player :pointer) )

(defun StartAudioPlayer (player)
  (start-audio-player player))

;................................................................................: StartAudioPlayer
(cffi:defcfun  ("StopAudioPlayer" stop-audio-player) :void (player :pointer) )

(defun StopAudioPlayer (player)
  (stop-audio-player player))

;................................................................................: StartSound
(cffi:defcfun  ("StartChannel" start-channel) :void (player :pointer) (chan :long) )

(defun StartChannel (player chan)
  (start-channel player chan))

;................................................................................: ContSound
(cffi:defcfun  ("ContChannel" cont-channel) :void (player :pointer) (chan :long) )

(defun ContChannel (player chan)
  (cont-channel player chan))

;................................................................................: StopSound
(cffi:defcfun  ("StopChannel" stop-channel) :void (player :pointer) (chan :long) )

(defun StopChannel (player chan)
  (stop-channel player chan))

;; Params

;................................................................................: SetVolChannel
(cffi:defcfun  ("SetVolChannel" set-vol-channel) :void (player :pointer) (chan :long) (vol :float) )

(defun SetVolChannel (player chan vol)
  (set-vol-channel player chan vol))

;................................................................................: SetPanChannel
(cffi:defcfun  ("SetPanChannel" set-pan-channel) :void (player :pointer) (chan :long) (panleft :float) (panright :float))

(defun SetPanChannel (player chan panLeft panRight)
  (set-pan-channel player chan panLeft panRight))

;................................................................................: SetEffectListChannel
(cffi:defcfun  ("SetEffectListChannel" set-effect-list-channel) :void (player :pointer) (chan :long) (effect_list effectlist-ptr) (fadein :long) (fadeout :long))

(defun SetEffectListChannel (player chan effect_list fadein fadeout)
  (set-effect-list-channel player chan (las-effectlist-ptr effect_list) fadein fadeout))

;; Master

;................................................................................: SetVolAudioPlayer
(cffi:defcfun  ("SetVolAudioPlayer" set-vol-audio-player) :void (player :pointer)  (vol :float))

(defun SetVolAudioPlayer (player vol)
 (set-vol-audio-player player vol))
;................................................................................: SetPanSound
(cffi:defcfun  ("SetPanAudioPlayer" set-pan-audio-player) :void (player :pointer)  (vol :float) (panl :float) (panr :float))

(defun SetPanAudioPlayer (player panLeft panRight)
  (set-pan-audio-player player panLeft panRight))

;................................................................................: SetEffectAudioPlayer
(cffi:defcfun  ("SetEffectListAudioPlayer" set-effect-list-audio-player) :void (player :pointer)  (effectlist effectlist-ptr) (fadein :long) (fadeout :long))

(defun SetEffectListAudioPlayer (player effect_list fadein fadeout)
  (set-effect-list-audio-player player (las-effectlist-ptr effect_list) fadein fadeout))

;;;========================== EFFECTS 

(cffi:defcfun  ("DeleteEffectListPtr" delete-effect-list-ptr) :void  (effectlist effectlist-ptr) )

(defun DeleteEffectList (effect_list)
 (delete-effect-list-ptr (las-effectlist-ptr effect_list)))

(cffi:defcfun  ("DeleteEffectPtr" delete-effect-ptr) :void  (effect effect-ptr))

(defun DeleteEffect (effect)
  (delete-effect-ptr (las-effect-ptr effect)))

(cffi:defcfun  ("MakeAudioEffectListPtr" make-audio-effect-list) effectlist-ptr)

(defun MakeAudioEffectList ()
  (let ((effect_list (make-las-effectlist :ptr (make-audio-effect-list))))
    (register-rsrc effect_list)
    effect_list))


(cffi:defcfun  ("AddAudioEffectPtr" add-audio-effect-ptr) effectlist-ptr (effectlist effectlist-ptr) (effect effect-ptr))
     
(defun AddAudioEffect (effect-list effect)
  (add-audio-effect-ptr (las-effectlist-ptr effect-list) (las-effect-ptr effect))
  effect-list)

(cffi:defcfun  ("RemoveAudioEffect" remove-audio-effect-ptr) effectlist-ptr  (effectlist effectlist-ptr) (effect effect-ptr))

(defun RemoveAudioEffect (effect-list effect)
  (remove-audio-effect-ptr (las-effectlist-ptr effect-list) (las-effect-ptr effect))
  effect-list)
    
(cffi:defcfun  ("MakeVolAudioEffectPtr" make-vol-audio-effect-ptr) effect-ptr  (gain :float))

(defun MakeVolAudioEffect (gain)
  (let ((effect (make-las-effect :ptr (make-vol-audio-effect-ptr gain))))
     (register-rsrc effect)
     effect))

(cffi:defcfun  ("MakeMonoPanAudioEffectPtr" make-mono-pan-audio-effect-ptr) effect-ptr (pan :float))

(defun MakeMonoPanAudioEffect (pan)
  (let ((effect (make-las-effect :ptr (make-mono-pan-audio-effect-ptr pan))))
    (register-rsrc effect)
    effect))

(cffi:defcfun  ("MakeStereoPanAudioEffectPtr" make-stereo-pan-audio-effect-ptr) effect-ptr (panl :float) (panr :float))

(defun MakeStereoPanAudioEffect (panLeft panRight)
  (let ((effect (make-las-effect :ptr (make-stereo-pan-audio-effect-ptr panLeft panRight))))
    (register-rsrc effect)
    effect))

(cffi:defcfun  ("MakeFaustAudioEffectPtr" make-faust-audio-effect-ptr) effect-ptr (s audio-name))

(defun MakeFaustAudioEffect (name)
  (cffi:with-foreign-string (s name)
    (let ((effect (make-las-effect :ptr (make-faust-audio-effect-ptr s))))
      (register-rsrc effect)
      effect)))


(cffi:defcfun  ("GetControlCountEffectPtr" get-control-count-effect-ptr) :long  (effect effect-ptr))

(defun GetControlCount (effect)
  (get-control-count-effect-ptr (las-effect-ptr effect)))

(cffi:defcfun  ("GetControlParamEffectPtr" get-control-param-effect-ptr) :void  (effect effect-ptr) (control :long) (name audio-name) (min :pointer) (max :pointer) (init :pointer))

(defun GetControlParam (effect control)
  (let ((name (cffi::%foreign-alloc 64))
        (min (cffi::%foreign-alloc 4))
        (max (cffi::%foreign-alloc 4))
        (init (cffi::%foreign-alloc 4) ) str minrep maxrep initrep)
 (get-control-param-effect-ptr (las-effect-ptr effect) control name min max init)
 (setf str (cffi::foreign-string-to-lisp name))
 (setf minrep (cffi::mem-ref min :float))
 (setf maxrep (cffi::mem-ref max :float))
 (setf initrep (cffi::mem-ref init :float))
 (cffi::foreign-free name)
 (cffi::foreign-free min)
 (cffi::foreign-free max)
 (cffi::foreign-free init)
 (values str minrep maxrep initrep)))


(cffi:defcfun  ("SetControlValueEffectPtr" set-control-value-effect-ptr) :void  (effect effect-ptr) (control :long) (value :float))

(defun SetControlValue (effect control value)
 (set-control-value-effect-ptr (las-effect-ptr effect) control value))

(cffi:defcfun  ("GetControlValueEffectPtr" get-control-value-effect-ptr) :float  (effect effect-ptr) (control :long))

(defun GetControlValue (effect control)
  (get-control-value-effect-ptr (las-effect-ptr effect) control))


