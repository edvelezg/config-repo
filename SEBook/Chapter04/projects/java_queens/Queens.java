// $Id$
// John Hurst (jbhurst@attglobal.net)
// 2007-03-27
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

import java.util.Date;

public class Queens {
  public static void main(String[] args) {
    if (args.length == 0) {
      System.err.println("I need a number.");
      System.exit(-1);
    }
    int size = Integer.parseInt(args[0]);
    Board b = new Board(size);
    long start = new Date().getTime();
    if (b.solve()) {
      long elapsed = new Date().getTime() - start;
      for (int i = 0; i < size; i++) {
        int col = b.getCol(i);
        for (int j = 0; j < col; j++) {
          System.out.print(" ");
        }
        System.out.println("*");
      }
      System.out.println("" + elapsed/1000 + " seconds.");
    }
  }
}

