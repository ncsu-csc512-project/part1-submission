// https://github.com/ncsu-csc512-project/part1-dev
//
// CSC 512 Course Project
//
// Teddy Xinyuan Chen
//
//     xchen87
//
//     200539142
//
//     https://github.com/tddschn

#include "pub_tool_basics.h"
#include "pub_tool_clientstate.h"
#include "pub_tool_debuginfo.h"
#include "pub_tool_hashtable.h"
#include "pub_tool_libcassert.h"
#include "pub_tool_libcbase.h"
#include "pub_tool_libcprint.h"
#include "pub_tool_libcproc.h"
#include "pub_tool_machine.h"
#include "pub_tool_mallocfree.h"
#include "pub_tool_options.h"
#include "pub_tool_redir.h"
#include "pub_tool_replacemalloc.h"
#include "pub_tool_stacktrace.h"
#include "pub_tool_threadstate.h"
#include "pub_tool_tooliface.h"
#include "pub_tool_vki.h"
#include "pub_tool_xarray.h"
#include "pub_tool_xtree.h"
#include "valgrind.h"

// Global counter for executed instructions
static ULong total_instructions = 0;

static VG_REGPARM(0) void inc_instruction_count(void) { total_instructions++; }

static IRSB *br_instrument(VgCallbackClosure *closure, IRSB *sbIn,
                           const VexGuestLayout *layout,
                           const VexGuestExtents *vge,
                           const VexArchInfo *archinfo_host, IRType gWordTy,
                           IRType hWordTy) {
  IRSB *sbOut = deepCopyIRSBExceptStmts(sbIn);
  Int i;

  for (i = 0; i < sbIn->stmts_used; i++) {
    IRStmt *st = sbIn->stmts[i];
    if (!st)
      continue;

    // Copy statement to output block
    addStmtToIRSB(sbOut, st);

    // Instrumentation: count the instruction at Ist_IMark
    if (st->tag == Ist_IMark) {
      IRDirty *di = unsafeIRDirty_0_N(
          0, "inc_instruction_count",
          VG_(fnptr_to_fnentry)(&inc_instruction_count), mkIRExprVec_0());
      addStmtToIRSB(sbOut, IRStmt_Dirty(di));
    }
  }

  return sbOut;
}

static void br_post_clo_init(void) {
  // Any initialization that depends on command-line options goes here.
  // If you don't have any such initialization, you can leave this empty.
}

// Finalization function
static void br_fini(Int exitcode) {
  VG_(umsg)
  ("Total number of executed instructions: %llu\n", total_instructions);
}

// Initialization function
static void br_pre_clo_init(void) {
  VG_(details_name)("Branch");
  VG_(details_version)(NULL);
  VG_(details_description)("a binary profiling tool to count instructions");
  VG_(details_copyright_author)
  ("Copyright (C) 2023, and GNU GPL'd, by Teddy Xinyuan Chen.");
  VG_(details_bug_reports_to)(VG_BUGS_TO);
  VG_(details_avg_translation_sizeB)(275);

  VG_(basic_tool_funcs)(br_post_clo_init, br_instrument, br_fini);
}

VG_DETERMINE_INTERFACE_VERSION(br_pre_clo_init)
