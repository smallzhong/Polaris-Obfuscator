; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -S -passes=loop-rotate < %s -verify-loop-info -verify-dom-info -verify-memoryssa | FileCheck %s

target datalayout = "e-m:e-p:32:32-i64:64-v128:64:128-a:0:32-n32-S64"
target triple = "thumbv8m.base-arm-none-eabi"

%struct.List = type { ptr, i32 }

define void @list_add(ptr nocapture %list, ptr %data) {
; CHECK-LABEL: @list_add(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[TMP0:%.*]] = load ptr, ptr [[LIST:%.*]], align 4
; CHECK-NEXT:    [[VAL2:%.*]] = getelementptr inbounds [[STRUCT_LIST:%.*]], ptr [[TMP0]], i32 0, i32 1
; CHECK-NEXT:    [[TMP1:%.*]] = load i32, ptr [[VAL2]], align 4
; CHECK-NEXT:    [[VAL1:%.*]] = getelementptr inbounds [[STRUCT_LIST]], ptr [[DATA:%.*]], i32 0, i32 1
; CHECK-NEXT:    [[TMP2:%.*]] = load i32, ptr [[VAL1]], align 4
; CHECK-NEXT:    [[CMP3:%.*]] = icmp slt i32 [[TMP1]], [[TMP2]]
; CHECK-NEXT:    br i1 [[CMP3]], label [[IF_THEN_LR_PH:%.*]], label [[IF_ELSE6:%.*]]
; CHECK:       if.then.lr.ph:
; CHECK-NEXT:    br label [[IF_THEN:%.*]]
; CHECK:       for.cond:
; CHECK-NEXT:    [[CURR_0:%.*]] = phi ptr [ [[TMP5:%.*]], [[IF_THEN]] ]
; CHECK-NEXT:    [[PREV_0:%.*]] = phi ptr [ [[CURR_04:%.*]], [[IF_THEN]] ]
; CHECK-NEXT:    [[VAL:%.*]] = getelementptr inbounds [[STRUCT_LIST]], ptr [[CURR_0]], i32 0, i32 1
; CHECK-NEXT:    [[TMP3:%.*]] = load i32, ptr [[VAL]], align 4
; CHECK-NEXT:    [[TMP4:%.*]] = load i32, ptr [[VAL1]], align 4
; CHECK-NEXT:    [[CMP:%.*]] = icmp slt i32 [[TMP3]], [[TMP4]]
; CHECK-NEXT:    br i1 [[CMP]], label [[IF_THEN]], label [[FOR_COND_IF_ELSE6_CRIT_EDGE:%.*]]
; CHECK:       if.then:
; CHECK-NEXT:    [[CURR_04]] = phi ptr [ [[TMP0]], [[IF_THEN_LR_PH]] ], [ [[CURR_0]], [[FOR_COND:%.*]] ]
; CHECK-NEXT:    [[TMP5]] = load ptr, ptr [[CURR_04]], align 4
; CHECK-NEXT:    [[TOBOOL:%.*]] = icmp eq ptr [[TMP5]], null
; CHECK-NEXT:    br i1 [[TOBOOL]], label [[IF_ELSE:%.*]], label [[FOR_COND]]
; CHECK:       if.else:
; CHECK-NEXT:    [[NEXT_LCSSA:%.*]] = phi ptr [ [[CURR_04]], [[IF_THEN]] ]
; CHECK-NEXT:    store ptr [[DATA]], ptr [[NEXT_LCSSA]], align 4
; CHECK-NEXT:    store ptr null, ptr [[DATA]], align 4
; CHECK-NEXT:    br label [[FOR_END:%.*]]
; CHECK:       for.cond.if.else6_crit_edge:
; CHECK-NEXT:    [[SPLIT:%.*]] = phi ptr [ [[PREV_0]], [[FOR_COND]] ]
; CHECK-NEXT:    br label [[IF_ELSE6]]
; CHECK:       if.else6:
; CHECK-NEXT:    [[PREV_0_LCSSA:%.*]] = phi ptr [ [[SPLIT]], [[FOR_COND_IF_ELSE6_CRIT_EDGE]] ], [ null, [[ENTRY:%.*]] ]
; CHECK-NEXT:    [[TOBOOL7:%.*]] = icmp eq ptr [[PREV_0_LCSSA]], null
; CHECK-NEXT:    br i1 [[TOBOOL7]], label [[IF_ELSE12:%.*]], label [[IF_THEN8:%.*]]
; CHECK:       if.then8:
; CHECK-NEXT:    [[TMP7:%.*]] = load i32, ptr [[PREV_0_LCSSA]], align 4
; CHECK-NEXT:    store i32 [[TMP7]], ptr [[DATA]], align 4
; CHECK-NEXT:    store ptr [[DATA]], ptr [[PREV_0_LCSSA]], align 4
; CHECK-NEXT:    br label [[FOR_END]]
; CHECK:       if.else12:
; CHECK-NEXT:    [[TMP10:%.*]] = load i32, ptr [[LIST]], align 4
; CHECK-NEXT:    store i32 [[TMP10]], ptr [[DATA]], align 4
; CHECK-NEXT:    store ptr [[DATA]], ptr [[LIST]], align 4
; CHECK-NEXT:    br label [[FOR_END]]
; CHECK:       for.end:
; CHECK-NEXT:    ret void
;
entry:
  %0 = load ptr, ptr %list, align 4
  br label %for.cond

for.cond:                                         ; preds = %if.then, %entry
  %curr.0 = phi ptr [ %0, %entry ], [ %3, %if.then ]
  %prev.0 = phi ptr [ null, %entry ], [ %curr.0, %if.then ]
  %val = getelementptr inbounds %struct.List, ptr %curr.0, i32 0, i32 1
  %1 = load i32, ptr %val, align 4
  %val1 = getelementptr inbounds %struct.List, ptr %data, i32 0, i32 1
  %2 = load i32, ptr %val1, align 4
  %cmp = icmp slt i32 %1, %2
  br i1 %cmp, label %if.then, label %if.else6

if.then:                                          ; preds = %for.cond
  %3 = load ptr, ptr %curr.0, align 4
  %tobool = icmp eq ptr %3, null
  br i1 %tobool, label %if.else, label %for.cond

if.else:                                          ; preds = %if.then
  %next.lcssa = phi ptr [ %curr.0, %if.then ]
  store ptr %data, ptr %next.lcssa, align 4
  store ptr null, ptr %data, align 4
  br label %for.end

if.else6:                                         ; preds = %for.cond
  %prev.0.lcssa = phi ptr [ %prev.0, %for.cond ]
  %tobool7 = icmp eq ptr %prev.0.lcssa, null
  br i1 %tobool7, label %if.else12, label %if.then8

if.then8:                                         ; preds = %if.else6
  %4 = load i32, ptr %prev.0.lcssa, align 4
  store i32 %4, ptr %data, align 4
  store ptr %data, ptr %prev.0.lcssa, align 4
  br label %for.end

if.else12:                                        ; preds = %if.else6
  %5 = load i32, ptr %list, align 4
  store i32 %5, ptr %data, align 4
  store ptr %data, ptr %list, align 4
  br label %for.end

for.end:                                          ; preds = %if.else12, %if.then8, %if.else
  ret void
}

define i32 @test2(ptr %l) {
; CHECK-LABEL: @test2(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[TMP0:%.*]] = load i32, ptr [[L:%.*]], align 4
; CHECK-NEXT:    [[TOBOOL2:%.*]] = icmp eq i32 [[TMP0]], 0
; CHECK-NEXT:    br i1 [[TOBOOL2]], label [[CLEANUP:%.*]], label [[DO_COND_LR_PH:%.*]]
; CHECK:       do.cond.lr.ph:
; CHECK-NEXT:    br label [[DO_COND:%.*]]
; CHECK:       do.body:
; CHECK-NEXT:    [[A_0:%.*]] = phi i32 [ [[REM:%.*]], [[DO_COND]] ]
; CHECK-NEXT:    [[TMP1:%.*]] = load i32, ptr [[L]], align 4
; CHECK-NEXT:    [[TOBOOL:%.*]] = icmp eq i32 [[TMP1]], 0
; CHECK-NEXT:    br i1 [[TOBOOL]], label [[DO_BODY_CLEANUP_CRIT_EDGE:%.*]], label [[DO_COND]]
; CHECK:       do.body.cleanup_crit_edge:
; CHECK-NEXT:    [[SPLIT:%.*]] = phi i32 [ [[A_0]], [[DO_BODY:%.*]] ]
; CHECK-NEXT:    br label [[CLEANUP]]
; CHECK:       cleanup:
; CHECK-NEXT:    [[A_0_LCSSA:%.*]] = phi i32 [ [[SPLIT]], [[DO_BODY_CLEANUP_CRIT_EDGE]] ], [ 100, [[ENTRY:%.*]] ]
; CHECK-NEXT:    store i32 10, ptr [[L]], align 4
; CHECK-NEXT:    br label [[CLEANUP2:%.*]]
; CHECK:       do.cond:
; CHECK-NEXT:    [[TMP2:%.*]] = phi i32 [ [[TMP0]], [[DO_COND_LR_PH]] ], [ [[TMP1]], [[DO_BODY]] ]
; CHECK-NEXT:    [[MUL:%.*]] = mul nsw i32 [[TMP2]], 13
; CHECK-NEXT:    [[REM]] = srem i32 [[MUL]], 27
; CHECK-NEXT:    [[TMP3:%.*]] = load i32, ptr [[L]], align 4
; CHECK-NEXT:    [[TOBOOL1:%.*]] = icmp eq i32 [[TMP3]], 0
; CHECK-NEXT:    br i1 [[TOBOOL1]], label [[CLEANUP2_LOOPEXIT:%.*]], label [[DO_BODY]]
; CHECK:       cleanup2.loopexit:
; CHECK-NEXT:    br label [[CLEANUP2]]
; CHECK:       cleanup2:
; CHECK-NEXT:    [[RETVAL_2:%.*]] = phi i32 [ [[A_0_LCSSA]], [[CLEANUP]] ], [ 0, [[CLEANUP2_LOOPEXIT]] ]
; CHECK-NEXT:    ret i32 [[RETVAL_2]]
;
entry:
  br label %do.body

do.body:                                          ; preds = %do.cond, %entry
  %a.0 = phi i32 [ 100, %entry ], [ %rem, %do.cond ]
  %0 = load i32, ptr %l, align 4
  %tobool = icmp eq i32 %0, 0
  br i1 %tobool, label %cleanup, label %do.cond

cleanup:                                          ; preds = %do.body
  %a.0.lcssa = phi i32 [ %a.0, %do.body ]
  store i32 10, ptr %l, align 4
  br label %cleanup2

do.cond:                                          ; preds = %do.body
  %mul = mul nsw i32 %0, 13
  %rem = srem i32 %mul, 27
  %1 = load i32, ptr %l, align 4
  %tobool1 = icmp eq i32 %1, 0
  br i1 %tobool1, label %cleanup2.loopexit, label %do.body

cleanup2.loopexit:                                ; preds = %do.cond
  br label %cleanup2

cleanup2:                                         ; preds = %cleanup2.loopexit, %cleanup
  %retval.2 = phi i32 [ %a.0.lcssa, %cleanup ], [ 0, %cleanup2.loopexit ]
  ret i32 %retval.2
}

define i32 @no_rotate(ptr %l) {
; CHECK-LABEL: @no_rotate(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[DO_BODY:%.*]]
; CHECK:       do.body:
; CHECK-NEXT:    [[A_0:%.*]] = phi i32 [ 100, [[ENTRY:%.*]] ], [ [[REM:%.*]], [[DO_COND:%.*]] ]
; CHECK-NEXT:    [[TMP0:%.*]] = load i32, ptr [[L:%.*]], align 4
; CHECK-NEXT:    [[TOBOOL:%.*]] = icmp eq i32 [[TMP0]], 0
; CHECK-NEXT:    br i1 [[TOBOOL]], label [[CLEANUP:%.*]], label [[DO_COND]]
; CHECK:       cleanup:
; CHECK-NEXT:    [[A_0_LCSSA:%.*]] = phi i32 [ [[A_0]], [[DO_BODY]] ]
; CHECK-NEXT:    store i32 10, ptr [[L]], align 4
; CHECK-NEXT:    br label [[CLEANUP2:%.*]]
; CHECK:       do.cond:
; CHECK-NEXT:    [[MUL:%.*]] = mul nsw i32 [[A_0]], 13
; CHECK-NEXT:    [[REM]] = srem i32 [[MUL]], 27
; CHECK-NEXT:    [[TMP1:%.*]] = load i32, ptr [[L]], align 4
; CHECK-NEXT:    [[TOBOOL1:%.*]] = icmp eq i32 [[TMP1]], 0
; CHECK-NEXT:    br i1 [[TOBOOL1]], label [[CLEANUP2_LOOPEXIT:%.*]], label [[DO_BODY]]
; CHECK:       cleanup2.loopexit:
; CHECK-NEXT:    br label [[CLEANUP2]]
; CHECK:       cleanup2:
; CHECK-NEXT:    [[RETVAL_2:%.*]] = phi i32 [ [[A_0_LCSSA]], [[CLEANUP]] ], [ 0, [[CLEANUP2_LOOPEXIT]] ]
; CHECK-NEXT:    ret i32 [[RETVAL_2]]
;
entry:
  br label %do.body

do.body:                                          ; preds = %do.cond, %entry
  %a.0 = phi i32 [ 100, %entry ], [ %rem, %do.cond ]
  %0 = load i32, ptr %l, align 4
  %tobool = icmp eq i32 %0, 0
  br i1 %tobool, label %cleanup, label %do.cond

cleanup:                                          ; preds = %do.body
  %a.0.lcssa = phi i32 [ %a.0, %do.body ]
  store i32 10, ptr %l, align 4
  br label %cleanup2

do.cond:                                          ; preds = %do.body
  %mul = mul nsw i32 %a.0, 13
  %rem = srem i32 %mul, 27
  %1 = load i32, ptr %l, align 4
  %tobool1 = icmp eq i32 %1, 0
  br i1 %tobool1, label %cleanup2.loopexit, label %do.body

cleanup2.loopexit:                                ; preds = %do.cond
  br label %cleanup2

cleanup2:                                         ; preds = %cleanup2.loopexit, %cleanup
  %retval.2 = phi i32 [ %a.0.lcssa, %cleanup ], [ 0, %cleanup2.loopexit ]
  ret i32 %retval.2
}
