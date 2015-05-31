# $Id$
# John Hurst (jbhurst@attglobal.net)
# 2007-03-27
#
# Copyright 2007 Wiley Publishing Inc, Indianapolis, Indiana, USA.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

class Board

  def initialize(size)
    @pos = Array.new(size, nil)
    @col = Array.new(size, false)
    @diag1 = Array.new(2*size, false)
    @diag2 = Array.new(2*size, false)
  end

  def size
    @pos.size
  end

  def col(row)
    @pos[row]
  end

  def place!(row, col)
    @pos[row] = col
    @col[col] = true
    @diag1[col-row+size] = true
    @diag2[col+row] = true
  end

  def unplace!(row)
    col = @pos[row]
    @pos[row] = nil
    @col[col] = false
    @diag1[col-row+size] = false
    @diag2[col+row] = true
    col
  end

  def ok?(row, col)
    return false if @col[col]
    return false if @diag1[col-row+size]
    return false if @diag2[col+row]
    true
  end

  def solve!
    row = 0
    col = 0
    while row >= 0 and row < size
      while col < size and !ok?(row, col)
        col += 1
      end
      if col < size
        place!(row, col)
        row += 1
        col = 0
      else
        row -= 1
        if row >= 0
          col = unplace!(row) + 1
        end
      end
    end
    return row == size
  end

  def printout
    @pos.each {|p| puts " " * p + "X"}
  end

end # class Board

