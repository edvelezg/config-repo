// $Id: queens.cpp 1466 2007-08-28 10:49:25Z jhurst $
// John Hurst (jbhurst@attglobal.net)
// 2007-03-26
//
// Copyright 2007 Wiley Publishing Inc, Indianapolis, Indiana, USA.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

#include <ctime>
#include <iostream>
#include <string>
#include "board.h"
#include <cstdlib>

int main(int argc, char *argv[]) {
    if (argc < 2) {
        std::cerr << "I need a number." << std::endl;
        exit(-1);
    }
    int size = atoi(argv[1]);
    Board b(size);
    time_t start = time(0);
    if (b.solve()) {
        time_t elapsed = time(0) - start;
        for (int i = 0; i < size; i++) {
            std::cout << std::string(b.col(i), ' ') << "*" << std::endl;
        }
        std::cout << elapsed << " seconds." << std::endl;
    }
    return (0);
}

