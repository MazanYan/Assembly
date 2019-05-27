#include <iostream>
#include "longop.h"

using namespace std;


int main() {
    unsigned int a[2] = {0x0, 0x00000001};
    unsigned int b[2] = {0, 0x00000001};
    unsigned int c[4];
    
    //subLongop(c, b, a, 2);
    //for (int i = 0; i < 2; i++) 
    //	cout << c[i];
    
    addLongop(c, b, a, 2);
    for (int i = 0; i < 3; i++) 
    	cout << c[i];
    
    cout << endl;

    fill_n(c, 3, 0);
    subLongop(c, b, a, 2);

    for (int i = 0; i < 3; i++) 
    	cout << c[i];

    mulN_x_N(c, b, a, 2);
    cout << c[0];
    //for (int i = 0; i < 4; i++) 
    //	cout << c[i];
    return 0;
}
