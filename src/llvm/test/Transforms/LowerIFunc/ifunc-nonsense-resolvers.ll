; NOTE: Assertions have been autogenerated by utils/update_test_checks.py UTC_ARGS: --check-globals --include-generated-funcs
; RUN: opt -S -passes=lower-ifunc < %s | FileCheck %s

@ifunc_with_arg = ifunc void (), ptr @resolver_with_arg

; Test a resolver with an argument (which probably should not be legal
; IR).
define ptr @resolver_with_arg(i64 %arg) {
  %cast = inttoptr i64 %arg to ptr
  ret ptr %cast
}

define void @call_with_arg() {
  call void @ifunc_with_arg()
  ret void
}
;.
; CHECK: @[[GLOB0:[0-9]+]] = internal global [1 x ptr] poison, align 8
; CHECK: @[[LLVM_GLOBAL_CTORS:[a-zA-Z0-9_$"\\.-]+]] = appending global [1 x { i32, ptr, ptr }] [{ i32, ptr, ptr } { i32 10, ptr @[[GLOB1:[0-9]+]], ptr null }]
; CHECK: @[[IFUNC_WITH_ARG:[a-zA-Z0-9_$"\\.-]+]] = ifunc void (), ptr @resolver_with_arg
;.
; CHECK-LABEL: define {{[^@]+}}@resolver_with_arg(
; CHECK-NEXT:    [[CAST:%.*]] = inttoptr i64 [[ARG:%.*]] to ptr
; CHECK-NEXT:    ret ptr [[CAST]]
;
;
; CHECK-LABEL: define {{[^@]+}}@call_with_arg(
; CHECK-NEXT:    call void @ifunc_with_arg()
; CHECK-NEXT:    ret void
;
;
; CHECK-LABEL: define {{[^@]+}}@1(
; CHECK-NEXT:    ret void
;