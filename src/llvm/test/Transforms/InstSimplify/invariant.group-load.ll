; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -passes=instsimplify -S < %s | FileCheck %s

@A = linkonce_odr hidden constant { i64, i64 } { i64 2, i64 3 }
@B = linkonce_odr hidden global { i64, i64 } { i64 2, i64 3 }

declare ptr @llvm.strip.invariant.group.p0(ptr %p)
declare ptr @llvm.launder.invariant.group.p0(ptr %p)

define i64 @f() {
; CHECK-LABEL: @f(
; CHECK-NEXT:    ret i64 3
;
  %a = call ptr @llvm.strip.invariant.group.p0(ptr @A)
  %b = getelementptr i8, ptr %a, i32 8
  %d = load i64, ptr %b
  ret i64 %d
}

define i64 @g() {
; CHECK-LABEL: @g(
; CHECK-NEXT:    ret i64 3
;
  %a = call ptr @llvm.launder.invariant.group.p0(ptr @A)
  %b = getelementptr i8, ptr %a, i32 8
  %d = load i64, ptr %b
  ret i64 %d
}

define i64 @notconstantglobal() {
; CHECK-LABEL: @notconstantglobal(
; CHECK-NEXT:    [[A:%.*]] = call ptr @llvm.launder.invariant.group.p0(ptr @B)
; CHECK-NEXT:    [[B:%.*]] = getelementptr i8, ptr [[A]], i32 8
; CHECK-NEXT:    [[D:%.*]] = load i64, ptr [[B]], align 4
; CHECK-NEXT:    ret i64 [[D]]
;
  %a = call ptr @llvm.launder.invariant.group.p0(ptr @B)
  %b = getelementptr i8, ptr %a, i32 8
  %d = load i64, ptr %b
  ret i64 %d
}

define i64 @notconstantgepindex(i32 %i) {
; CHECK-LABEL: @notconstantgepindex(
; CHECK-NEXT:    [[A:%.*]] = call ptr @llvm.launder.invariant.group.p0(ptr @A)
; CHECK-NEXT:    [[B:%.*]] = getelementptr i8, ptr [[A]], i32 [[I:%.*]]
; CHECK-NEXT:    [[D:%.*]] = load i64, ptr [[B]], align 4
; CHECK-NEXT:    ret i64 [[D]]
;
  %a = call ptr @llvm.launder.invariant.group.p0(ptr @A)
  %b = getelementptr i8, ptr %a, i32 %i
  %d = load i64, ptr %b
  ret i64 %d
}

define i64 @volatile() {
; CHECK-LABEL: @volatile(
; CHECK-NEXT:    [[A:%.*]] = call ptr @llvm.launder.invariant.group.p0(ptr @A)
; CHECK-NEXT:    [[B:%.*]] = getelementptr i8, ptr [[A]], i32 8
; CHECK-NEXT:    [[D:%.*]] = load volatile i64, ptr [[B]], align 4
; CHECK-NEXT:    ret i64 [[D]]
;
  %a = call ptr @llvm.launder.invariant.group.p0(ptr @A)
  %b = getelementptr i8, ptr %a, i32 8
  %d = load volatile i64, ptr %b
  ret i64 %d
}