// $Id$
// John Hurst (jbhurst@attglobal.net)
// 2007-03-25
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

#include <vector>

class Board {
public:
  Board(int size);
  int size();
  void place(int row, int col);
  int unplace(int row);
  bool is_ok(int row, int col);
  bool solve();
  int col(int row);

private:
  int size_;
  std::vector<int> pos_;
  std::vector<bool> col_;
  std::vector<bool> diag1_;
  std::vector<bool> diag2_;
};
