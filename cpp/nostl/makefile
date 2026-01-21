# Generate clangd dummy file for autocompletion
.clangd:
	@echo 'CompileFlags:' > .clangd
	@echo '    Add: [' >> .clangd
	@echo '        "-I/usr/lib/gcc/x86_64-unknown-linux-gnu/14.2/include/",' >> .clangd
	@echo '        "-nostdinc++",' >> .clangd
	@echo '        "-std=c++20",' >> .clangd
	@echo '        ]' >> .clangd

main.o: main.cpp
	g++ \
		-std=c++20 \
		-c -fPIC \
		-o $@ $< \
		-Wall -Wextra -Werror \
		-fno-exceptions -fno-rtti \
		-fno-threadsafe-statics \
		-ffreestanding \
		-nostdinc++

out: main.o
	# gcc seems to do way more than expected
	# linking so let it do it
	# ld --output $@ $< -lc
	gcc -o $@ $< -nodefaultlibs -lc -lgcc -lSDL3

.PHONY: clean
clean:
	rm main.o || true
	rm out    || true

.PHONY: all
all: out

.DEFAULT_GOAL := all
.MAIN: all

# ls -1 | while read line; do echo "namespace std {\n#include <$line>\n}" > $line; done

# make clean && make && ./out

# /usr/lib/gcc/x86_64-unknown-linux-gnu/14.2/include/

