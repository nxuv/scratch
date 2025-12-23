# eC (Ecere)

## Installation

For some reason required to comment out and delete SSLSocket related files [even though that](https://ec-lang.org/install/linux/),
> OpenSSL (Disabled by default, ENABLE_SSL=y to include SSLSocket)

IDE thankfully was installed as ecere-ide instead of ide as mentioned on their website...

## Usage

### Binaries

- ecere-ide
    Actual IDE but I don't care at all.
- ear
    Archiving tool, seems to be used to inject files into binary
- ecc
    eC Compiler, apparently generates C code
- ecp
    eC Precompiler, generates list of symbols
- ecs
    eC Symbol loader generator, not sure what it does
- epj2make
    IDE crap to Makefile converter
- bgen
    Generates C bindings from eC
- documentor
    Generates docs

### Compiling

The actual focus for me is `ecc` binary, flags are as follows:

|flag          |args             |description                                                        |
|:-            |:-               |:-                                                                 |
|-t            |target-platform  | win32, linux or apple                                             |
|-cpp          |c-preprocessor   | which c preprocessor to use, default gcc                          |
|-defaultns    |default-namespace| assume everything under flag's namespace                          |
|-strictns     |-                | force require to use full qualified names for symbols             |
|-memguard     |-                | some smart stuff, not sure                                        |
|-nolinenumbers|-                | do not output eC line numbers in C output                         |
|..?           |-                | one of -I<includedir> -i<lib?> -D<define> -m32                    |
|-c            |input            | apparently input files?                                           |
|-o            |output           | typical -o flag, wants .c extension                               |
|-symbols      |ir-dir           | requires dir with .sym output from ecp and outputs .imp and .bowl |

### The hell begins

Considering I have no knowledge of what to do or expect, let's try compiling,

```bash
ecc -c hello.ec -o hello.c
```

Well, that's wierd, it wants `hello.sym`? Ok, fine,

```bash
ecs -c hello.ec -o hello.sym
ecc -c hello.ec -o hello.c
```

Oh, now we got whole host of `hello.*` files, we get ec, sym, imp, c. Let's continue.

```bash
gcc -o hello hello.c
```

OH NO, ok, so we get linking errors, fine, sure, let's see, what if,

```bash
gcc -o hello hello.c -lecere
```

And how it looks together,

```make
build/hello.sym: hello.ec
	ecp -c $< -o $@

build/hello.ec: hello.ec
	ecs -c $< -o $@ -symbols build -console

build/hello.c: build/hello.ec build/hello.sym
	ecc -c $< -o $@ -symbols build

build/hello.o: build/hello.c
	gcc -c -o $@ $<

bin/hello: build/hello.o
	gcc build/hello.o -o $@ -lecere
```

Still linking errors but different symbols this time, mhm, ok, nothing I do solves it so let's open ***IDE***, ugh... Creating empty project and running make on it gives this (truncated args for clarity),

```bash
ecp -fPIC -c form1.ec -o form1.sym
ecc -fPIC -c form1.ec -o form1.c -symbols .
gcc -fPIC -c form1.c  -o form1.o
ecs -console @symbols.lst -symbols -o test.main.ec

ecp -fPIC -c test.main.ec -o test.main.sym -symbols .
ecc -fPIC -c test.main.ec -o test.main.c   -symbols .
gcc -fPIC -c test.main.c  -o test.main.o
gcc @objects.lst -lecere -o test
```

Ok, let's try,

```bash
ecp -c hello.ec -o hello.sym
ecc -c hello.ec -o hello.c   -symbols .
gcc -c hello.c  -o hello.o
gcc hello.o -lecere -o hello
```

Ah, I am certainly missing something, maybe `-fPIC`? No, that doesn't seem to be it... But it compiled fine with [generated vomit of a makefile](https://github.com/ecere/eC/blob/main/ecc/Makefile), strange... Let's try going through IDE again but now with single-file console app.

It seems to be calling,
- ecp on test.ec with output of test.sym
- ecc on test.ec with output of test.c
- gcc on test.c  with output of test.o
- ecs on ..? is it just a symbols directory? with output of test.main.ec
- ecp on new test.main.ec? with output of test.main.sym
- ecc on test.main.ec with output of test.main.c
- gcc on test.main.c with output of test.main.o
- gcc on test.main.o and test.o with output of executable

... why...? Ok, fine, fine, let's try.

Ok, now it seems to be only complaining about undefined reference to main and print...

Cool, so after figuring the IMPORTANT `hello.imp`, I'm left with

```make
CFLAGS := -fPIC -Wall -Wextra -Werror -Wno-unused-parameter
ECARGS := -symbols build $(CFLAGS)

build/hello.sym: hello.ec
	ecp -c $< -o $@ $(ECARGS)

build/hello.c: hello.ec build/hello.sym
	ecc -c $< -o $@ $(ECARGS)

build/hello.o: build/hello.c
	gcc -c $< -o $@ $(CFLAGS)

build/hello.imp: build/hello.c

build/a.hello.ec: build/hello.sym build/hello.imp
	ecs -c $^ -o $@ $(ECARGS)

build/a.hello.sym: build/a.hello.ec
	ecp -c $< -o $@ $(ECARGS)

build/a.hello.c: build/a.hello.ec build/a.hello.sym
	ecc -c $< -o $@ $(ECARGS)

build/a.hello.o: build/a.hello.c
	gcc -c $< -o $@ $(CFLAGS)

bin/hello: build/a.hello.o build/hello.o
	gcc $^ -o $@ -lecere
```

which for some reason doesn't print anything. Pain.

### Pain continues

It was `ecs -c $^`, it should be `ecs $^`.

So, now it compiles and I even can create normal C hello world, however as soon as I (while removing dep on a.hello.o) add eC features (class decl) it falls apart.

If to use compilation stuff for normal eC files (process stuff twice and use two objects) and declare main function it goes to both hello.c and hello.main.c, does it do that for all funcitons? It doesn't. It seems that it generates it's own main that tries to call child of `ecere::com::Application`.

```c
  _class = __ecereNameSpace__ecere__com__eSystem_FindClass(
      __currentModule, "ecere::com::Application");
  exitCode = ((struct __ecereNameSpace__ecere__com__Application *)((
                  (char *)((struct __ecereNameSpace__ecere__com__Instance *)
                               __currentModule) +
                  sizeof(struct __ecereNameSpace__ecere__com__Module) +
                  sizeof(struct __ecereNameSpace__ecere__com__Instance))))
                 ->exitCode;
```

Which boils down to my inability to create proper main function. Needs investigating on how can I circumvent that.

Damn, it's hard to find anything on eC on github because of some eAsYcRyPt, bullshit! I think they got github syntax highlight off of easycrypt being there, what a joke.

### Pain end

Ok, so, everything depends on how you operate `ecs` and trick is to use `-dynamiclib`, it's idiotic, it's awful, but!

```bash
ecp -c hello.ec  -o o/hello.sym
ecc -c hello.ec  -o o/hello.c -symbols o/
gcc -c o/hello.c -o o/hello.o

ecs o/hello.sym o/hello.imp -o o/hello.entry.ec -symbols o/ -dynamiclib

ecp -c o/hello.entry.ec -o o/hello.entry.sym -symbols o/
ecc -c o/hello.entry.ec -o o/hello.entry.c   -symbols o/
gcc -c o/hello.entry.c  -o o/hello.entry.o

gcc o/hello.o o/hello.entry.o -o b/hello -lecere
```

What is happening here then? Whole thing can be divided into four parts:
1. preprocessing/compiling implementation
2. generating entrypoint
3. preprocessing/compiling entrypoint
4. compiling final executable

When you actually get down to it - it makes some sense but honestly you'd be better using Vala or something like it.

Ok, correction, as soon as you import any eC std it fails miserably! Do not do that at all.

## Actually using it to write C-like applications

Welp, I'm unable to include SDL both 2 and 3, so bye bye eC. You were pain to even compile.
