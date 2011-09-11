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

public class Board {
  private int size;
  private int[] pos;
  private boolean[] col;
  private boolean[] diag1;
  private boolean[] diag2;

  public Board(int size) {
    this.size = size;
    this.pos = new int[size];
    for (int i = 0; i < size; i++) {
      pos[i] = -1;
    }
    this.col = new boolean[size];
    this.diag1 = new boolean[2 * size + 1];
    this.diag2 = new boolean[2 * size + 1];
  }

  public int getSize() {
    return size;
  }

  public void place(int row, int col) {
    pos[row] = col;
    this.col[col] = true;
    diag1[col - row + size] = true;
    diag2[col + row] = true;
  }

  public int unplace(int row) {
    int col = pos[row];
    pos[row] = -1;
    this.col[col] = false;
    diag1[col - row + size] = false;
    diag2[col + row] = false;
    return col;
  }

  public boolean isOk(int row, int col) {
    return !(this.col[col] || diag1[col - row + size] || diag2[col + row]);
  }

  public boolean solve() {
    int row = 0;
    int col = 0;
    while (row >= 0 && row < size) {
      while (col < size && !isOk(row, col)) {
        col++;
      }
      if (col < size) {
        place(row, col);
        row++;
        col = 0;
      }
      else {
        row--;
        if (row >= 0) {
          col = unplace(row) + 1;
        }
      }
    }
    return row == size;
  }

  public int getCol(int row) {
    return pos[row];
  }
}

