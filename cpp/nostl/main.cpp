// #include "std/io.h"
#include <stdio.h>
#include <unistd.h>

#include <SDL3/SDL.h>

#include "ncpp.h"

class Window {
    SDL_Window *ptr;

    public:

    Window(const char *title, int w, int h, SDL_WindowFlags flags) {
        this->ptr = SDL_CreateWindow(title, w, h, flags);
    }

    ~Window() {
        SDL_DestroyWindow(this->ptr);
    }
};

i32 main(void) {
    printf("Hello from botched C\n");

    SDL_Init(SDL_INIT_VIDEO);

    Window *win = new Window("SDL3 Image",640, 480, 0);

    sleep(1);

    delete win;

    SDL_Quit();
    return 0;
}

