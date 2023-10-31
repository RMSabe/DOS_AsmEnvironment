This are tests routines created to test some functionalities.

To use a test routine, use the "%include" directive to include the test file into MAIN.ASM file. Then add a "jmp _teststart" instruction right after the "_main:" label.
Only one test file may be included at the "MAIN.ASM" file at a time. Including multiple test files in "MAIN.ASM" might result in unexpected runtime behavior or assembler errors.
