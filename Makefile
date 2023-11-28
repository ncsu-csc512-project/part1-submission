
# Default LLVM installation directory
LLVM_DIR ?= /usr/local/opt/llvm
CLANG_COMMAND ?= clang -I/usr/local/include
OPT_COMMAND ?= opt

# Target for cloning the repository
REPO_URL = https://github.com/ncsu-csc512-project/part1-dev.git
REPO_DIR = part1-dev


all: run

inputs/input.ll: inputs/input.c
	# clang -S -emit-llvm inputs/input.c -o inputs/input.ll -g -O0
	$(CLANG_COMMAND) -S -emit-llvm inputs/input.c -o inputs/input.ll -g -O0 
	# $(CLANG_COMMAND) -S -emit-llvm inputs/input.c -o inputs/input.ll -g 
	# clang -S -emit-llvm inputs/input.c -o inputs/input.ll
	
# $(REPO_DIR):
# 	git clone $(REPO_URL)
#
# clone: $(REPO_DIR)

setup: clone
	export LLVM_DIR=$(LLVM_DIR)

build_dir:
	mkdir -p build

build: setup build_dir
	cmake -DMY_LLVM_INSTALL_DIR=$(LLVM_DIR) -S . -B build && cmake --build build

run: build
	$(OPT_COMMAND) -load-pass-plugin ./build/BranchPointerPass/libBranchPointerPass.so -passes=branch-pointer-pass -disable-output inputs/input.ll
	# opt -load-pass-plugin ./build/BranchPointerTracePass/libBranchPointerTracePass.so -passes=branch-pointer-trace -disable-output inputs/input.ll
	# $(OPT_COMMAND) -load-pass-plugin ./build/BranchPointerTracePass/libBranchPointerTracePass.so -passes=branch-pointer-trace -disable-output inputs/input.ll

clean:
	rm -rf build

sync-to-submission-repo-dryrun:
	rsync -au --delete --progress -h --include-from='include.txt' ./ ../part1-submission/ -n

sync-to-submission-repo:
	rsync -au --delete --progress -h --include-from='include.txt' ./ ../part1-submission/

.PHONY: all clone setup build run clean sync-to-submission-repo*