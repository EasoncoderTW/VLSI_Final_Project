#include <iostream>
#include <fstream>
#include <string>

using namespace std;

int main(){
    string line;

    ofstream mem_image_file;
    mem_image_file.open("./Mem.hex");

    ifstream inst_file;
    inst_file.open("./m_code.hex");

    ifstream data_file;
    data_file.open("./data.hex");

    mem_image_file << "@00000000" << endl;
    while(getline(inst_file, line))
    {
        mem_image_file << line << endl; 
    }
    mem_image_file << "@00008000" << endl;
    while(getline(data_file, line))
    {
        mem_image_file << line << endl; 
    }

    inst_file.close();
    data_file.close();
    mem_image_file.close();

    return 0;
}