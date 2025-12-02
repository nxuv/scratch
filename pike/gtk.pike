#!/usr/bin/env pike

#define ECHO(X) write(X + "\n")

void writeln(string fmt, mixed ... args) {
    fmt += "\n";
    write(fmt, @args);
}

// https://git.lysator.liu.se/pikelang/pike/-/blob/v7.8.316/src/post_modules/GTK/examples/simple_menu.pike

#if !constant(GTK.setup_gtk)

int main() {
    werror("Failed to find GTK module\n");
    return 1;
}

#else // has SDL

// == using namespace SDL;
// import GTK.MenuFactory;

// What is the difference between -> and . .....?

int main() {
    test_gtk();
    // -1 means do not exit immediately
    return -1;
}

void test_gtk() {
    GTK.setup_gtk();
    // GTK.AboutDialog w = GTK.AboutDialog();
    // w.set_program_name("GTK Test");
    // w.signal_connect("destroy", lambda() { exit(0); });
    // w.set_title("GTK Test Window");
    // w.set_comments("Testing testing");
    // array(string) authors = ({"nxuv", "ye"});
    // w.set_authors(authors);
    // w.show_now();

    GTK.Window window = GTK.Window(GTK.WINDOW_TOPLEVEL);

    window->signal_connect("destroy", lambda() {exit(0);});

    GTK.Hbox box = GTK.Hbox(0, 0);
    window->add(box);

    GTK.Entry edit = GTK.Entry();
    GTK.Button button = GTK.Button("suup");

    button->signal_connect("clicked", lambda() {write("hiiii\n");});
    edit->signal_connect("key_release_event",
        lambda(object a, object b, object c, object d, object e) {
            writeln("%O %O %O %O %O", a, b, c, d, e);
            writeln("%s", edit->get_text());
        }
    );

    box->add(edit);
    box->add(button);

    window->show_all();
}

#endif

