#include "stdio.h"


// import "ecere";

class Test {
    void say_hi() {
        printf("hello\n");
    }
}

int test_func() {
    return 0;
}

void demo();

int main() {
    printf("hiiiiiii\n");
    Test test {};
    test.say_hi();
    test_func();
    return 0;
}

// from here on it's going to be stuff from their website

class SampleClass {
   // MemberClass m { };
   int a;

   a = 123;

   virtual void vMethod() {
      PrintLn("vMethod default");
   };

   byte * data;

   SampleClass() {
      data = new byte[100];
   }

   ~SampleClass() {
      delete data;
   }
}

SampleClass object {
   void vMethod()    {
      PrintLn("object's vMethod");
   }
};

// A RUNTIME CLASS (even though you never import it)
// compiler screams of redefinition
// https://dggal.org/docs/html/ecereCOM/ecere/com/Classes/Link.html
// class LinkList : struct {
//    LinkList prev, next;
// }

struct Point {
   int x, y;
}; // Semicolon required for struct

double length(Point p) {
   return sqrt(p.x * p.x + p.y + p.y);
}
// class Pen {
//    Color color;
//    public property Color color
//    {
//       get { return color; }
//       set { color = value; }
//    }
// }
// Declare Distance units to use doubles
class Distance : double;
// Meters as default (no conversion needed)
class Meters : Distance {
   property Distance {}
};

class Centimeters : Distance {
   // Conversion to Meter (100cm / m)
   property Meters
   {
      set { return value * 100; }
      get { return this / 100; }
   }
};
class Feet : Distance {
   // Conversion to Meter (~3.28 feet / m)
   property Meters
   {
      set { return value * 3.28083f; }
      get { return this / 3.28083f; }
   }
};
enum LineStyle {
   none, solid, dashed, dotted
};

enum FillStyle {
   none, solid, hatch, stipple
};

enum ExtFillStyle : FillStyle {
   bitmap, gradient
};
void demo() {
   FillStyle fs = solid;
   LineStyle ls = none;
   int efs = ExtFillStyle::gradient;
   Meters a;
   a = Feet { 12 } + Centimeters { 3 };

   // Pen pen { };
   // pen.color = red;

   Point * points = new Point[100];

   Point b { 3, 4 };
   double l = length(b); // passed by address
   l = length({ 6, 8 });
   delete points;

   // runtime class (i'd prefer it not to be)
   Link al { }; // On the heap
   Link bl { };
   al.next = bl; // Still accessed with '.'
   bl.prev = al;

   Class c = object._class;
   incref object;
   // Call object's own implementation
   object.vMethod();
}

// import "ecere";
//
// class HelloApp : Application {
//    public static void Main() {
//       // PrintLn("Hello, World!!\n");
//        Test t {};
//        t.say_hi();
//    }
// }
