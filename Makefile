
# Default LLVM installation directory
UNAME_S := $(shell uname -s)

ifeq ($(UNAME_S),Linux)
	DISTRO := $(shell lsb_release -si)
	ifeq ($(DISTRO),Ubuntu)
		LLVM_DIR ?= /usr/lib/llvm-17
		CLANG_COMMAND ?= /usr/bin/clang-17
		OPT_COMMAND ?= /usr/bin/opt-17
	endif
else ifeq ($(UNAME_S),Darwin)
	LLVM_DIR ?= /usr/local/opt/llvm
	CLANG_COMMAND ?= clang -I/usr/local/include
	OPT_COMMAND ?= opt
endif

# Target for cloning the repository
REPO_URL = https://github.com/ncsu-csc512-project/part1-dev.git
REPO_DIR = part1-dev


all: run


install-deps-on-ubuntu:
	sudo apt install tmux cmake fd-find -y

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

prereq:
	# if on ubuntu and clang-17 not found, run scripts/ubuntu-install-llvm.sh
	if [ ! -f $(CLANG_COMMAND) ]; then ./scripts/ubuntu-install-llvm.sh; fi
	


build: prereq setup build_dir
	# if not on linux
	# check UNAME_S
	if [ "$(UNAME_S)" != "Linux" ]; then \
		cmake -DMY_LLVM_INSTALL_DIR=$(LLVM_DIR) -S . -B build && cmake --build build; \
	else \
		VCPKG_CMAKE="$$(scripts/setup-vcpkg.sh)" && \
		cmake -DMY_LLVM_INSTALL_DIR=$(LLVM_DIR) -S . -B build -DCMAKE_TOOLCHAIN_FILE="$${VCPKG_CMAKE}" && cmake --build build; \
	fi
	

run: build inputs/input.ll
	$(OPT_COMMAND) -load-pass-plugin ./build/BranchPointerPass/libBranchPointerPass.so -passes=branch-pointer-pass -disable-output inputs/input.ll

clean:
	rm -rf build

sync-to-submission-repo-dryrun:
	rsync -au --delete --progress -h --include-from='include.txt' ./ ../part1-submission/ -n

sync-to-submission-repo:
	rsync -au --delete --progress -h --include-from='include.txt' ./ ../part1-submission/
	
update-vcl:
	rsync -au --progress -h . vcl:1 --exclude 'build' --exclude '.git'

update-vcl2:
	rsync -au --progress -h . vcl2:1 --exclude 'build' --exclude '.git'

update-vcl3:
	rsync -au --progress -h . vcl3:1 --exclude 'build' --exclude '.git'

.PHONY: all clone setup build run clean sync-to-submission-repo* prereq