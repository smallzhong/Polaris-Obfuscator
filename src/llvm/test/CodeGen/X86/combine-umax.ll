; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+sse2 | FileCheck %s --check-prefix=SSE2
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+sse4.1 | FileCheck %s --check-prefix=SSE41
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+sse4.2 | FileCheck %s --check-prefix=SSE42
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx | FileCheck %s --check-prefix=AVX
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx2 | FileCheck %s --check-prefix=AVX
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx512f | FileCheck %s --check-prefix=AVX
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx512bw | FileCheck %s --check-prefix=AVX

define <8 x i16> @test_v8i16_nosignbit(<8 x i16> %a, <8 x i16> %b) {
; SSE2-LABEL: test_v8i16_nosignbit:
; SSE2:       # %bb.0:
; SSE2-NEXT:    pand {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm0
; SSE2-NEXT:    psrlw $1, %xmm1
; SSE2-NEXT:    pminsw %xmm1, %xmm0
; SSE2-NEXT:    retq
;
; SSE41-LABEL: test_v8i16_nosignbit:
; SSE41:       # %bb.0:
; SSE41-NEXT:    pand {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm0
; SSE41-NEXT:    psrlw $1, %xmm1
; SSE41-NEXT:    pminuw %xmm1, %xmm0
; SSE41-NEXT:    retq
;
; SSE42-LABEL: test_v8i16_nosignbit:
; SSE42:       # %bb.0:
; SSE42-NEXT:    pand {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm0
; SSE42-NEXT:    psrlw $1, %xmm1
; SSE42-NEXT:    pminuw %xmm1, %xmm0
; SSE42-NEXT:    retq
;
; AVX-LABEL: test_v8i16_nosignbit:
; AVX:       # %bb.0:
; AVX-NEXT:    vpand {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm0, %xmm0
; AVX-NEXT:    vpsrlw $1, %xmm1, %xmm1
; AVX-NEXT:    vpminuw %xmm1, %xmm0, %xmm0
; AVX-NEXT:    retq
  %1 = and <8 x i16> %a, <i16 255, i16 255, i16 255, i16 255, i16 255, i16 255, i16 255, i16 255>
  %2 = lshr <8 x i16> %b, <i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1>
  %3 = icmp ult <8 x i16> %1, %2
  %4 = select <8 x i1> %3, <8 x i16> %1, <8 x i16> %2
  ret <8 x i16> %4
}

define <16 x i8> @test_v16i8_reassociation(<16 x i8> %a) {
; SSE2-LABEL: test_v16i8_reassociation:
; SSE2:       # %bb.0:
; SSE2-NEXT:    movdqa {{.*#+}} xmm1 = [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15]
; SSE2-NEXT:    pmaxub %xmm1, %xmm0
; SSE2-NEXT:    pmaxub %xmm1, %xmm0
; SSE2-NEXT:    retq
;
; SSE41-LABEL: test_v16i8_reassociation:
; SSE41:       # %bb.0:
; SSE41-NEXT:    movdqa {{.*#+}} xmm1 = [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15]
; SSE41-NEXT:    pmaxub %xmm1, %xmm0
; SSE41-NEXT:    pmaxub %xmm1, %xmm0
; SSE41-NEXT:    retq
;
; SSE42-LABEL: test_v16i8_reassociation:
; SSE42:       # %bb.0:
; SSE42-NEXT:    movdqa {{.*#+}} xmm1 = [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15]
; SSE42-NEXT:    pmaxub %xmm1, %xmm0
; SSE42-NEXT:    pmaxub %xmm1, %xmm0
; SSE42-NEXT:    retq
;
; AVX-LABEL: test_v16i8_reassociation:
; AVX:       # %bb.0:
; AVX-NEXT:    vmovdqa {{.*#+}} xmm1 = [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15]
; AVX-NEXT:    vpmaxub %xmm1, %xmm0, %xmm0
; AVX-NEXT:    vpmaxub %xmm1, %xmm0, %xmm0
; AVX-NEXT:    retq
  %1 = call <16 x i8> @llvm.umax.v16i8(<16 x i8> %a, <16 x i8> <i8 0, i8 1, i8 2, i8 3, i8 4, i8 5, i8 6, i8 7, i8 8, i8 9, i8 10, i8 11, i8 12, i8 13, i8 14, i8 15>)
  %2 = call <16 x i8> @llvm.umax.v16i8(<16 x i8> %1, <16 x i8> <i8 0, i8 1, i8 2, i8 3, i8 4, i8 5, i8 6, i8 7, i8 8, i8 9, i8 10, i8 11, i8 12, i8 13, i8 14, i8 15>)
  ret <16 x i8> %2
}
declare <16 x i8> @llvm.umax.v16i8(<16 x i8> %x, <16 x i8> %y)