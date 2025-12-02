#!/usr/bin/env pike

#define ECHO(X) write(X + "\n")

// https://github.com/Frigolit/misc/blob/master/system/x11grab-ssh
// https://github.com/Frigolit/misc/blob/master/graphics/2d-light-normals.pike
// https://github.com/Sonamaker1/PikeExperiments/blob/master/SDLtest.pike
// https://github.com/Rosuav/pike-alsa/blob/master/README.md
// https://pike.lysator.liu.se/generated/manual/modref/ex/predef_3A_3A/SDL.html#SDL
// https://lazyfoo.net/tutorials/SDL/01_hello_SDL/index2.php
// https://www.parallelrealities.co.uk/tutorials/sdl1/
// https://lazyfoo.net/SDL_tutorials/lesson01/index2.php
// https://github.com/libsdl-org/SDL-1.2/tree/main/docs

// #include <something.h>
// inherit "something";
// TODO: figure out what it means
// seems inherit is relative path to import
// #include also acts like inherit? but preprocessor?
// #include can also do C headers? (at least defines)

#if !constant(SDL.init)

int main() {
    werror("Failed to find SDL module\n");
    return 1;
}

#else // has SDL
// == using namespace SDL;
import SDL;

int main() {
    ECHO("hiiiii");
    test_sdl();
    return -1;
}

void test_sdl() {
    SDL.init(SDL.INIT_VIDEO);
    atexit(SDL.quit);
    SDL.Surface surface = SDL.set_video_mode(640, 480, 32, SDL.SWSURFACE);
    SDL.flip(surface);
    SDL.set_caption("SDL Test", "");

    SDL.Event e = SDL.Event();

    while (true) {
        while (e->get()) {
            if (e->type == SDL.QUIT) exit(0);
            // if (e->type == SDL.KEYDOWN) write("%O\n", e->keysym.sym);
            if (e->type == SDL.KEYDOWN && e->keysym.sym == 113) exit(0);
        }
    }
}

#endif

