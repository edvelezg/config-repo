// $Id$
// John Hurst (jbhurst@attglobal.net)
// 2007-05-23
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

#pragma option(strict, on)
#include "slick.sh"

static int q_pos[];
static boolean q_col[];
static boolean q_diag1[];
static boolean q_diag2[];

/**
 * Initialize board to given size.
 * @param size The size of the new board.
 */
void wrox_queens_init(int size) {
  q_pos._makeempty();
  q_col._makeempty();
  q_diag1._makeempty();
  q_diag2._makeempty();
  int i;
  for (i = 0; i < size; i++) {
    q_pos[i] = -1;
    q_col[i] = false;
  }
  for (i = 0; i < 2 * size + 1; i++) {
    q_diag1[i] = false;
    q_diag2[i] = false;
  }
}

/**
 * Returns the board size.
 *
 * @return int The board size.
 */
int wrox_queens_size() {
  return q_pos._length();
}

/**
 * Returns the col the queen is in for the given row.
 * @param row The row.
 *
 * @return int The col the queen is in.
 */
int wrox_queens_col(int row) {
  return q_pos[row];
}

/**
 * Places a queen in the given row and column.
 * @param row The row.
 * @param col The column.
 */
void wrox_queens_place(int row, int col) {
  q_pos[row] = col;
  q_col[col] = true;
  int size = wrox_queens_size();
  q_diag1[col - row + size] = true;
  q_diag2[col + row] = true;
}

/**
 * Remove the queen placed in the given row, return the column
 * it was in.
 * @param row The row.
 *
 * @return int The column the queen was removed from.
 */
int wrox_queens_unplace(int row) {
  int col = q_pos[row];
  q_pos[row] = -1;
  q_col[col] = false;
  int size = wrox_queens_size();
  q_diag1[col - row + size] = false;
  q_diag2[col + row] = false;
  return col;
}

/**
 * Returns true if it's OK to place a queen at the given row and
 * column.
 * @param row The row.
 * @param col The column.
 *
 * @return boolean True if it's OK to place a queen at the row
 *         and column.
 */
boolean wrox_queens_ok(int row, int col) {
  int size = wrox_queens_size();
  return !(q_col[col] || q_diag1[col - row + size] || q_diag2[col + row]);
}

/**
 * Returns true if successful at solving board.
 *
 * @return boolean
 */
boolean wrox_queens_solve() {
  int row = 0;
  int col = 0;
  int size = wrox_queens_size();
  while (row >= 0 && row < size) {
    while (col < size && !wrox_queens_ok(row, col)) {
      col++;
    }
    if (col < size) {
      wrox_queens_place(row, col);
      row++;
      col = 0;
    }
    else {
      row--;
      if (row >= 0) {
        col = wrox_queens_unplace(row) + 1;
      }
    }
  }
  return row == size;
}

/**
 * Print out board into current buffer.
 */
void wrox_queens_print() {
  int size = wrox_queens_size();
  int i;
  for (i = 0; i < size; i++) {
    insert_line(wrox_rightstr("*", wrox_queens_col(i) + 1));
  }
}

/**
 * Solve N-Queens problem of the given size, output solution to
 * current buffer.
 * @param size Size of problem to solve.
 */
_command void wrox_queens(int size=4) name_info(','VSARG2_REQUIRES_EDITORCTL) {
  wrox_queens_init(size);
  int start_time = (int) _time("B");
  if (wrox_queens_solve()) {
    int end_time = (int) _time("B");
    wrox_queens_print();
    int elapsed_seconds = (end_time - start_time) / 1000;
    message("Board size "size" solved, took "elapsed_seconds" seconds.");
  }
  else {
    message("Board size "size" not solved.");
  }
}

/**
 * Test wrox_queens_size().
 *
 * @return int
 */
_command int wrox_try_queens_size() name_info(',') {
  wrox_queens_init(1);
  wrox_assert_equals(1, wrox_queens_size());
  wrox_queens_init(4);
  wrox_assert_equals(4, wrox_queens_size());
  wrox_queens_init(20);
  wrox_assert_equals(20, wrox_queens_size());
  return 0;
}

/**
 * Test wrox_queens_place().
 *
 * @return int
 */
_command int wrox_try_queens_place() name_info(',') {
  wrox_queens_init(4);
  wrox_assert_equals(-1, wrox_queens_col(0));
  wrox_assert_equals(-1, wrox_queens_col(1));
  wrox_assert_equals(-1, wrox_queens_col(2));
  wrox_assert_equals(-1, wrox_queens_col(3));
  wrox_queens_place(0, 1);
  wrox_queens_place(1, 3);
  wrox_queens_place(2, 0);
  wrox_queens_place(3, 2);
  wrox_assert_equals(1, wrox_queens_col(0));
  wrox_assert_equals(3, wrox_queens_col(1));
  wrox_assert_equals(0, wrox_queens_col(2));
  wrox_assert_equals(2, wrox_queens_col(3));
  return 0;
}

/**
 * Test wrox_queens_unplace().
 *
 * @return int
 */
_command int wrox_try_queens_unplace() name_info(',') {
  wrox_queens_init(4);
  wrox_queens_place(0, 1);
  wrox_assert_false(wrox_queens_ok(1, 1));
  wrox_assert_false(wrox_queens_ok(0, 1));
  wrox_assert_false(wrox_queens_ok(2, 3));
  wrox_assert_equals(1, wrox_queens_unplace(0));
  _assert(wrox_queens_ok(1, 1));
  _assert(wrox_queens_ok(0, 1));
  _assert(wrox_queens_ok(2, 3));
  wrox_queens_place(1, 3);
  wrox_queens_place(2, 0);
  wrox_queens_place(3, 2);
  wrox_assert_equals(3, wrox_queens_unplace(1));
  wrox_assert_equals(-1, wrox_queens_col(1));
  wrox_assert_equals(2, wrox_queens_unplace(3));
  wrox_assert_equals(-1, wrox_queens_col(3));
  return 0;
}

/**
 * Test wrox_queens_ok().
 *
 * @return int
 */
_command int wrox_try_queens_ok() name_info(',') {
  wrox_queens_init(4);

  _assert( wrox_queens_ok(0, 0)); _assert( wrox_queens_ok(0, 1)); _assert( wrox_queens_ok(0, 2)); _assert( wrox_queens_ok(0, 3));
  _assert( wrox_queens_ok(1, 0)); _assert( wrox_queens_ok(1, 1)); _assert( wrox_queens_ok(1, 2)); _assert( wrox_queens_ok(1, 3));
  _assert( wrox_queens_ok(2, 0)); _assert( wrox_queens_ok(2, 1)); _assert( wrox_queens_ok(2, 2)); _assert( wrox_queens_ok(2, 3));
  _assert( wrox_queens_ok(3, 0)); _assert( wrox_queens_ok(3, 1)); _assert( wrox_queens_ok(3, 2)); _assert( wrox_queens_ok(3, 3));
  wrox_queens_place(0, 1);
  _assert(!wrox_queens_ok(1, 0)); _assert(!wrox_queens_ok(1, 1)); _assert(!wrox_queens_ok(1, 2)); _assert( wrox_queens_ok(1, 3));
  _assert( wrox_queens_ok(2, 0)); _assert(!wrox_queens_ok(2, 1)); _assert( wrox_queens_ok(2, 2)); _assert(!wrox_queens_ok(2, 3));
  _assert( wrox_queens_ok(3, 0)); _assert(!wrox_queens_ok(3, 1)); _assert( wrox_queens_ok(3, 2)); _assert( wrox_queens_ok(3, 3));
  wrox_queens_place(1, 3);
  _assert( wrox_queens_ok(2, 0)); _assert(!wrox_queens_ok(2, 1)); _assert(!wrox_queens_ok(2, 2)); _assert(!wrox_queens_ok(2, 3));
  _assert( wrox_queens_ok(3, 0)); _assert(!wrox_queens_ok(3, 1)); _assert( wrox_queens_ok(3, 2)); _assert(!wrox_queens_ok(3, 3));
  wrox_queens_place(2, 0);
  _assert(!wrox_queens_ok(3, 0)); _assert(!wrox_queens_ok(3, 1)); _assert( wrox_queens_ok(3, 2)); _assert(!wrox_queens_ok(3, 3));
  return 0;
}

/**
 * Test wrox_queens_solve() fail.
 *
 * @return int
 */
_command int wrox_try_queens_solve_false() name_info(',') {
  wrox_queens_init(3);
  wrox_assert_false(wrox_queens_solve());
  return 0;
}

/**
 * Test wrox_queens_solve() success.
 *
 * @return int
 */
_command int wrox_try_queens_solve_true() name_info(',') {
  wrox_queens_init(4);
  _assert(wrox_queens_solve());
  wrox_assert_equals(1, wrox_queens_col(0));
  wrox_assert_equals(3, wrox_queens_col(1));
  wrox_assert_equals(0, wrox_queens_col(2));
  wrox_assert_equals(2, wrox_queens_col(3));
  return 0;
}

