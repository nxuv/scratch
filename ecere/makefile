
build/:
	mkdir build

bin/:
	mkdir bin

# build/hello.sym: build/ hello.ec
# 	ecp -c hello.ec -symbols build -o build/default.hello.sym
#
# build/default.hello.ec: build/ hello.ec
# 	ecs -c hello.ec -symbols build -o build/default.hello.ec
#
# build/hello.c: build/hello.sym build/default.hello.ec
# 	ecc -c build/default.hello.ec -symbols build -o build/hello.c -nolinenumbers
#
# bin/hello: bin/ build/hello.c
# 	gcc -o bin/hello build/hello.c -Lec

# Reminder
# $@ target name
# $? newer prereq
# $^ all prereq
# $< first prereq

CFLAGS := -fPIC -Wall -Wextra -Werror -Wno-unused-parameter -Wno-unused-but-set-variable -Wno-unused-variable
ECARGS := -symbols build/ -nolinenumbers -fPIC

build/%.sym: %.ec
	ecp -c $< -o $@ $(ECARGS)

build/%.c: %.ec build/%.sym
	ecc -c $< -o $@ $(ECARGS)
	# ecc -c $< -o $@ $(ECARGS) | grep -v "C89 style" || true

build/%.o: build/%.c
	gcc -c $< -o $@ $(CFLAGS)

build/%.imp: build/%.c

build/%.entry.ec: build/%.sym build/%.imp
	ecs $^ -o $@ $(ECARGS) -dynamiclib

build/%.entry.sym: build/%.entry.ec
	ecp -c $< -o $@ $(ECARGS)

build/%.entry.c: build/%.entry.ec build/%.entry.sym
	ecc -c $< -o $@ $(ECARGS)

build/%.entry.o: build/%.entry.c
	gcc -c $< -o $@ $(CFLAGS)

bin/hello: build/hello.o build/hello.entry.o
	gcc $^ -o $@ -lecere -lm

bin/graphics: build/graphics.o build/graphics.entry.o
	gcc $^ -o $@ -lecere -lm -lSDL3 -lGL

.PHONY: all
all: build/ bin/ bin/hello bin/graphics

.PHONY: clean
clean:
	rm -rf build
	rm -rf bin

SHELL=bash
.SHELLFLAGS   := -o pipefail -c
.DEFAULT_GOAL := all
.MAIN: all

# mkdir -p obj/
# ecp -cpp gcc -module test -g -fPIC -Wall -D_DEBUG -c form1.ec -o obj/form1.sym
# ecc -cpp gcc -module test -g -fPIC -Wall -D_DEBUG -c form1.ec -o obj/form1.c -symbols obj/
# gcc -g -fPIC -Wall -D_DEBUG -c obj/form1.c -o obj/form1.o
# ecs -console   @obj/symbols.lst -symbols obj/debug.linux -o obj/test.main.ec
# ecp -cpp gcc -module test -g -fPIC -Wall -D_DEBUG -c obj/test.main.ec -o obj/test.main.sym -symbols obj/
# ecc -cpp gcc -module test -g -fPIC -Wall -D_DEBUG -c obj/test.main.ec -o obj/test.main.c -symbols obj/
# gcc -g -fPIC -Wall -D_DEBUG -c obj/test.main.c -o obj/test.main.o
# gcc    @obj/objects.lst    -lecere -o obj/test

# ecp -cpp gcc -module test -g -fPIC -Wall -D_DEBUG -c test.ec -o obj/test.sym
# ecc -cpp gcc -module test -g -fPIC -Wall -D_DEBUG -c test.ec -o obj/test.c -symbols obj/
# gcc -g -fPIC -Wall -D_DEBUG -c obj/test.c -o obj/test.o
# ecs -console   @obj/symbols.lst -symbols obj/debug.linux -o obj/test.main.ec
# ecp -cpp gcc -module test -g -fPIC -Wall -D_DEBUG -c obj/test.main.ec -o obj/test.main.sym -symbols obj/
# ecc -cpp gcc -module test -g -fPIC -Wall -D_DEBUG -c obj/test.main.ec -o obj/test.main.c -symbols obj/
# gcc -g -fPIC -Wall -D_DEBUG -c obj/test.main.c -o obj/test.main.o
# gcc    @obj/objects.lst    -lecere -o obj/test

