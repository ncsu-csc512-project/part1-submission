# Key Points Detection

**Background:** The running time of a compiled C program is decided
mainly by two kinds of events: (i) the decisions made at each branching
point; (ii) the values of the function pointers. So to study the runtime
of a program, it is necessary to collect these dynamic behaviors of a
program during its executions.

**Objective:** The first goal of this project is to create a profiling
tool that can make the execution of a program output a **branch-pointer
trace** after the execution of the program. A collected *branch-pointer
trace* records the branches and function pointer values in an execution
of the program, in a form as follows:

\*func_0x32576867 \# the value of a function pointer when the function
it points to is invoked

br_2

br_2

br_2

br_3

In the trace, "br_x" is the ID of a branch in the program. Its meaning
should be defined in a dictionary file produced by the tool as follows:

br_2: fileX, 5, 6

br_3: fileX, 5, 8

where, "fileX" is the name of the source code file the branch resides,
"5" is the line number of the branching statement in "fileX", and "6" is
the target line number of the branch. Below is an example source code in
"fileX" producing the above example trace:

Line 1: int main(){

Line 2: void (\*fun_ptr)(int) = &fun;

Line 3: (\*fun_ptr)(10);

Line 4:

Line 5: for (c=0; c\<3; c++){

Line 6: c = c + 1;

Line 7: }

Line 8: return c;

Line 9: }

Your profiling tool may ignore external libraries, focusing on user
code.



Our hypothesis is that for any two runs of a given program on different
inputs, if their *branch-pointer traces* are identical, the numbers of
executed instructions must be identical (assuming that the ignored
libraries do not behave differently). After the two profiling tools are
developed, check that hypothesis by running it on different inputs that
lead to the same branch-pointer traces.

**Methods:**

Add one or more passes into [[LLVM]{.underline}](https://llvm.org/docs/)
