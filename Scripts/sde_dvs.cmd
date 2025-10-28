;---------------------------------------------------------------------------
; Some control parameters
;---------------------------------------------------------------------------
(define tSiN_passivation 0.05)
(define tGaN_cap 	0.003)
(define NGaN_cap	5E18)
(define tAlGaN_spacer	0.002)
(define tAlGaN		@tAlGaN@)
(define NAlGaN		2E18)
(define xAlGaN		@xAlGaN@)
(define tGaN_channel	2.0)
(define NGaN_channel	1E15)
(define tSiC		0.01)


(define Lsg		1.0)
(define Lgd		3.0)
(define Lg		0.8)
(define Ls		0.5)
(define Ld		0.5)

;---------------------------------------------------------------------------
; Derived parameters
;---------------------------------------------------------------------------
; Vertical coordinates
(define Ytop 0.0)
(define Y0_SiN_passivation Ytop)
(define Y0_GaN_cap (+ Y0_SiN_passivation tSiN_passivation))
(define Y0_AlGaN_barrier (+ Y0_GaN_cap tGaN_cap))
(define Y0_GaN_channel (+ Y0_AlGaN_barrier tAlGaN))
(define Y0_AlGaN_spacer (- Y0_GaN_channel tAlGaN_spacer))
(define Y0_SiC_substrate (+ Y0_GaN_channel tGaN_channel))
(define Ybot (+ Y0_SiC_substrate tSiC))

; Horizontal coordinates
(define Xmax (+ Ls Lsg Lg Lgd Ld))
(define Xmin 0)
(define Xsrc Ls)
(define Xgt.l (+ Xsrc Lsg))
(define Xgt.r (+ Xgt.l Lg))
(define Xdrn (+ Xgt.r Lgd))

;---------------------------------------------------------------------------
; Build epi structure
;---------------------------------------------------------------------------
; Passivation
(sdegeo:create-rectangle 
  (position 0 Y0_SiN_passivation 0) (position Xmax Y0_GaN_cap 0) 
  "Nitride" "SiN_passivation" 
)
(sdedr:define-refinement-size "Ref.SiN_passivation" 99 0.0125 66 0.01 )
(sdedr:define-refinement-region "Ref.SiN_passivation" "Ref.SiN_passivation" "SiN_passivation")

; GaN cap
(sdegeo:create-rectangle 
  (position 0 Y0_GaN_cap 0) (position Xmax Y0_AlGaN_barrier 0) 
  "GaN" "GaN_cap" 
)
(sdedr:define-constant-profile "ndop_GaN_cap_const" "ArsenicActiveConcentration" NGaN_cap)
(sdedr:define-constant-profile-region "ndop_GaN_cap_const" "ndop_GaN_cap_const" "GaN_cap")

; AlGaN barrier
(sdegeo:create-rectangle 
  (position 0 Y0_AlGaN_barrier 0) (position Xmax Y0_AlGaN_spacer 0) 
  "AlGaN" "AlGaN_barrier" 
)
(sdedr:define-constant-profile "ndop_AlGaN_barrier_const" "ArsenicActiveConcentration" NAlGaN)
(sdedr:define-constant-profile-region "ndop_AlGaN_barrier_const" "ndop_AlGaN_barrier_const" "AlGaN_barrier")
(sdedr:define-constant-profile "xmole_AlGaN_barrier_const" "xMoleFraction" xAlGaN)
(sdedr:define-constant-profile-region "xmole_AlGaN_barrier_const" "xmole_AlGaN_barrier_const" "AlGaN_barrier")
(sdedr:define-refinement-size "Ref.AlGaN_barrier" 99 0.002 66 0.001 )
(sdedr:define-refinement-region "Ref.AlGaN_barrier" "Ref.AlGaN_barrier" "AlGaN_barrier" )

; AlGaN spacer
(sdegeo:create-rectangle 
  (position 0 Y0_AlGaN_spacer 0) (position Xmax Y0_GaN_channel 0) 
  "AlGaN" "AlGaN_spacer" 
)
(sdedr:define-constant-profile "ndop_AlGaN_spacer_const" "ArsenicActiveConcentration" 1e15)
(sdedr:define-constant-profile-region "ndop_AlGaN_spacer_const" "ndop_AlGaN_spacer_const" "AlGaN_spacer")
(sdedr:define-constant-profile "xmole_AlGaN_spacer_const" "xMoleFraction" xAlGaN)
(sdedr:define-constant-profile-region "xmole_AlGaN_spacer_const" "xmole_AlGaN_spacer_const" "AlGaN_spacer")

; GaN channel
(sdegeo:create-rectangle 
  (position 0 Y0_GaN_channel 0) (position Xmax (+ Y0_GaN_channel 0.005) 0) 
  "GaN" "GaN_channel" 
)
(sdedr:define-constant-profile "ndop_GaN_channel_const" "ArsenicActiveConcentration" 1e15)
(sdedr:define-constant-profile-region "ndop_GaN_channel_const" "ndop_GaN_channel_const" "GaN_channel")

; GaN buffer
(sdegeo:create-rectangle 
  (position 0 (+ Y0_GaN_channel 0.005) 0) (position Xmax Y0_SiC_substrate 0) 
  "GaN" "GaN_buffer" 
)
(sdedr:define-constant-profile "ndop_GaN_buffer_const" "ArsenicActiveConcentration" 1e15)
(sdedr:define-constant-profile-region "ndop_GaN_buffer_const" "ndop_GaN_buffer_const" "GaN_buffer")
(sdedr:define-refinement-size "Ref.GaN_buffer" 99 0.2 66 0.1 )
(sdedr:define-refinement-region "Ref.GaN_buffer" "Ref.GaN_buffer" "GaN_buffer" )

; AlN emulated as Oxide
(sdegeo:create-rectangle 
  (position 0 Y0_SiC_substrate 0) (position Xmax Ybot 0) 
  "Oxide" "SiC_substrate" 
)

;---------------------------------------------------------------------------
; "Build" device
;---------------------------------------------------------------------------
(define Ycontact (+ Y0_GaN_cap 0.04))

(define src.metal (sdegeo:create-rectangle 
  (position 0 Ytop 0) (position Xsrc Ycontact 0)
  "Metal" "tmp.source" 
))

(define drn.metal (sdegeo:create-rectangle 
  (position Xdrn Ytop 0) (position Xmax Ycontact 0)
  "Metal" "tmp.drain" 
))

(define gt.metal (sdegeo:create-rectangle 
  (position Xgt.l Ytop 0) (position Xgt.r Y0_GaN_cap 0)
  "Metal" "tmp.gate" 
))

; Define electrodes
(sdegeo:define-contact-set "drain")
(sdegeo:set-current-contact-set "drain")
(sdegeo:set-contact-boundary-edges drn.metal)
(sdegeo:delete-region drn.metal)
 
(sdegeo:define-contact-set "source")
(sdegeo:set-current-contact-set "source")
(sdegeo:set-contact-boundary-edges src.metal)
(sdegeo:delete-region src.metal)
 
(sdegeo:define-contact-set "gate")
(sdegeo:set-current-contact-set "gate")
(sdegeo:set-contact-boundary-edges gt.metal)
(sdegeo:delete-region gt.metal)

; Define thermodes
# (sdegeo:insert-vertex (position 0 (+ Ycontact 0.1) 0))
# (sdegeo:insert-vertex (position Xmax (+ Ycontact 0.1) 0))
# (sdegeo:define-contact-set "thermal")
# (sdegeo:set-current-contact-set "thermal")
# (sdegeo:define-2d-contact (find-edge-id (position 0.0001 Y0_SiC_substrate 0)) "thermal")
# (sdegeo:define-2d-contact (find-edge-id (position 0 (+ Ycontact 0.2) 0)) "thermal")
# (sdegeo:define-2d-contact (find-edge-id (position Xmax (+ Ycontact 0.2) 0)) "thermal")

;---------------------------------------------------------------------------
; 2D Doping profiles
;---------------------------------------------------------------------------
; Doping to facilitate ohmic contacts
# (sdedr:define-constant-profile "Ohmic" "ArsenicActiveConcentration" 5E+20)
#
# (sdedr:define-refinement-window "Pl.ohmic.d" "Rectangle"  
#		(position Xdrn Ytop 0) (position Xmax Ycontact 0))
# (sdedr:define-constant-profile-placement "Ohmic.d" "Ohmic" "Pl.ohmic.d" 0.002)
# 
# (sdedr:define-refinement-window "Pl.ohmic.s" "Rectangle"  
#		(position 0 Ytop 0) (position Xsrc Ycontact 0))
# (sdedr:define-constant-profile-placement "Ohmic.s" "Ohmic" "Pl.ohmic.s" 0.002)


;---------------------------------------------------------------------------
; Meshing
;---------------------------------------------------------------------------
; Global
(sdedr:define-refinement-window "Pl.global" "Rectangle"  
		(position 0 Ytop 0) (position Xmax Ybot 0))
(sdedr:define-refinement-size "Ref.global" (/ Xmax 16) (/ Ybot 16) 0.002 0.002)
(sdedr:define-refinement-placement "Ref.global" "Ref.global" "Pl.global")
(sdedr:define-refinement-function "Ref.global" "DopingConcentration" "MaxTransDiff" 1)
(sdedr:define-refinement-function "Ref.global" "MaxLenInt" "GaN" "Nitride" 0.0005 1.8)
(sdedr:define-refinement-function "Ref.global" "MaxLenInt" "GaN" "AlGaN" 0.0004 1.8 "DoubleSide")
(sdedr:define-refinement-function "Ref.global" "MaxLenInt" "GaN" "Oxide" 0.01 2)

; Channel
(sdedr:define-refinement-window "Pl.channel" "Rectangle"  
		(position Xgt.l Ytop 0) (position Xgt.r (+ Y0_GaN_channel 0.1) 0))
(sdedr:define-refinement-size "Ref.channel" (/ Lg 8) 99 0.004 66)
(sdedr:define-refinement-placement "Ref.channel" "Ref.channel" "Pl.channel")
(sdedr:define-refinement-function "Ref.channel" "MaxLenInt" "GaN" "" 0.0005 1.8)

; Electron spreading
(sdedr:define-refinement-window "Pl.eDensity" "Rectangle"  
  (position (- Xgt.r 0.4) Y0_GaN_cap 0) (position (+ Xgt.r 0.6) (+ Y0_GaN_channel 0.5) 0))
(sdedr:define-refinement-size "Ref.eDensity" 0.05 0.05 0.01 0.01)
(sdedr:define-refinement-placement "Ref.eDensity" "Ref.eDensity" "Pl.eDensity")

; Ungated drain
(sdedr:define-refinement-window "Pl.ungated.d" "Rectangle"  
  (position Xgt.r Y0_GaN_cap 0) (position Xdrn (+ Y0_GaN_channel 0.4) 0))
(sdedr:define-refinement-size "Ref.ungated.d" (/ Lgd 16) 99 (/ Lgd 32) 66)
(sdedr:define-refinement-placement "Ref.ungated.d" "Ref.ungated.d" "Pl.ungated.d")

; Ungated source
(sdedr:define-refinement-window "Pl.ungated.s" "Rectangle"  
  (position Xsrc Y0_GaN_cap 0) (position Xgt.l (+ Y0_GaN_channel 0.2) 0))
(sdedr:define-refinement-size "Ref.ungated.s" (/ Lsg 4) 99 (/ Lsg 8) 66)
(sdedr:define-refinement-placement "Ref.ungated.s" "Ref.ungated.s" "Pl.ungated.s")

; Drain contact edge
(sdedr:define-refinement-window "Pl.drain_c" "Rectangle"  
		(position (- Xdrn 0.1) Ytop 0) (position (+ Xdrn 0.06) Y0_GaN_channel 0))
(sdedr:define-refinement-size "Ref.drain_c" 0.01 99 0.002 66)
(sdedr:define-refinement-placement "Ref.drain_c" "Ref.drain_c" "Pl.drain_c")

 (sdedr:define-refinement-window "Pl.drain_c.t" "Rectangle"  
 		(position (- Xdrn 0.015) Y0_GaN_channel 0) (position Xmax (+ Ycontact 0.005) 0))
 (sdedr:define-refinement-size "Ref.drain_c.t" 0.1 0.05 0.002 0.002)
 (sdedr:define-refinement-placement "Ref.drain_c.t" "Ref.drain_c.t" "Pl.drain_c.t")

 (sdedr:define-refinement-window "Pl.drain_c.t2" "Rectangle"  
 		(position (- Xdrn 0.012) Y0_GaN_channel 0) (position Xdrn (+ Y0_GaN_channel 0.012) 0))
 (sdedr:define-refinement-size "Ref.drain_c.t2" 0.001 0.002 0.0005 0.001)
 (sdedr:define-refinement-placement "Ref.drain_c.t2" "Ref.drain_c.t2" "Pl.drain_c.t2")

; Source contact edge
(sdedr:define-refinement-window "Pl.source_c" "Rectangle"  
		(position (- Xsrc 0.04) Ytop 0) (position (+ Xsrc 0.04) Y0_GaN_channel 0))
(sdedr:define-refinement-size "Ref.source_c" 0.04 99 0.004 66)
(sdedr:define-refinement-placement "Ref.source_c" "Ref.source_c" "Pl.source_c" )

 (sdedr:define-refinement-window "Pl.source_c.t" "Rectangle"  
		(position Xmin Y0_GaN_cap 0) (position (+ Xsrc 0.015) (+ Ycontact 0.005) 0))
 (sdedr:define-refinement-size "Ref.source_c.t" 0.1 0.05 0.002 0.002)
 (sdedr:define-refinement-placement "Ref.source_c.t" "Ref.source_c.t" "Pl.source_c.t")

 (sdedr:define-refinement-window "Pl.source_c.t2" "Rectangle"  
		(position Xsrc Y0_GaN_channel 0) (position (+ Xsrc 0.012) (+ Y0_GaN_channel 0.012) 0))
 (sdedr:define-refinement-size "Ref.source_c.t2" 0.001 0.002 0.0005 0.001)
 (sdedr:define-refinement-placement "Ref.source_c.t2" "Ref.source_c.t2" "Pl.source_c.t2")

; Right gate contact edge
(sdedr:define-refinement-window "Pl.contact_r" "Rectangle"  
		(position (- Xgt.r 0.02) Ytop 0) (position (+ Xgt.r 0.02) (+ Y0_GaN_channel 0.005) 0))
(sdedr:define-refinement-size "Ref.contact_r" 0.005 99 0.001 66)
(sdedr:define-refinement-placement "Ref.contact_r" "Ref.contact_r" "Pl.contact_r")

; Left gate contact edge
(sdedr:define-refinement-window "Pl.contact_l" "Rectangle"  
		(position (- Xgt.l 0.02) Ytop 0) (position (+ Xgt.l 0.024) Y0_GaN_channel 0))
(sdedr:define-refinement-size "Ref.contact_l" 0.004 99 0.002 66)
(sdedr:define-refinement-placement "Ref.contact_l" "Ref.contact_l" "Pl.contact_l")


;---------------------------------------------------------------------------
(sde:build-mesh "-H" "n@node@")
;---------------------------------------------------------------------------
