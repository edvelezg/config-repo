// $Id$
// Copyright 2007 John Hurst
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

import junit.framework.TestCase;

public class BoardTest extends TestCase {

  public void testCreate() {
    Board b1 = new Board(1);
    Board b2 = new Board(2);
    Board b20 = new Board(20);
    assertTrue(true);
  }

  public void testSize() {
    Board b1 = new Board(1);
    assertEquals(1, b1.getSize());
    Board b4 = new Board(4);
    assertEquals(4, b4.getSize());
    Board b20 = new Board(20);
    assertEquals(20, b20.getSize());
  }

  public void testPlace() {
    Board b = new Board(4);
    assertEquals(-1, b.getCol(0));
    assertEquals(-1, b.getCol(1));
    assertEquals(-1, b.getCol(2));
    assertEquals(-1, b.getCol(3));
    b.place(0, 1);
    b.place(1, 3);
    b.place(2, 0);
    b.place(3, 2);
    assertEquals(1, b.getCol(0));
    assertEquals(3, b.getCol(1));
    assertEquals(0, b.getCol(2));
    assertEquals(2, b.getCol(3));
  }

  public void testUnplace() {
    Board b = new Board(4);
    b.place(0, 1);
    assertFalse(b.isOk(1, 1));
    assertFalse(b.isOk(0, 1));
    assertFalse(b.isOk(2, 3));
    b.unplace(0);
    assertTrue(b.isOk(1, 1));
    assertTrue(b.isOk(0, 1));
    assertTrue(b.isOk(2, 3));
    b.place(1, 3);
    b.place(2, 0);
    b.place(3, 2);
    assertEquals(3, b.unplace(1));
    assertEquals(-1, b.getCol(1));
    assertEquals(2, b.unplace(3));
    assertEquals(-1, b.getCol(3));
  }

  public void testIsOk() {
    Board b = new Board(4);
    assertTrue( b.isOk(0, 0)); assertTrue( b.isOk(0, 1)); assertTrue( b.isOk(0, 2)); assertTrue( b.isOk(0, 3));
    assertTrue( b.isOk(1, 0)); assertTrue( b.isOk(1, 1)); assertTrue( b.isOk(1, 2)); assertTrue( b.isOk(1, 3));
    assertTrue( b.isOk(2, 0)); assertTrue( b.isOk(2, 1)); assertTrue( b.isOk(2, 2)); assertTrue( b.isOk(2, 3));
    assertTrue( b.isOk(3, 0)); assertTrue( b.isOk(3, 1)); assertTrue( b.isOk(3, 2)); assertTrue( b.isOk(3, 3));
    b.place(0, 1);
    assertTrue(!b.isOk(1, 0)); assertTrue(!b.isOk(1, 1)); assertTrue(!b.isOk(1, 2)); assertTrue( b.isOk(1, 3));
    assertTrue( b.isOk(2, 0)); assertTrue(!b.isOk(2, 1)); assertTrue( b.isOk(2, 2)); assertTrue(!b.isOk(2, 3));
    assertTrue( b.isOk(3, 0)); assertTrue(!b.isOk(3, 1)); assertTrue( b.isOk(3, 2)); assertTrue( b.isOk(3, 3));
    b.place(1, 3);
    assertTrue( b.isOk(2, 0)); assertTrue(!b.isOk(2, 1)); assertTrue(!b.isOk(2, 2)); assertTrue(!b.isOk(2, 3));
    assertTrue( b.isOk(3, 0)); assertTrue(!b.isOk(3, 1)); assertTrue( b.isOk(3, 2)); assertTrue(!b.isOk(3, 3));
    b.place(2, 0);
    assertTrue(!b.isOk(3, 0)); assertTrue(!b.isOk(3, 1)); assertTrue( b.isOk(3, 2)); assertTrue(!b.isOk(3, 3));
  }

  public void testSolveFalse() {
    Board b = new Board(3);
    assertFalse(b.solve());
  }

  public void testSolveTrue() {
    Board b = new Board(4);
    assertTrue(b.solve());
    assertEquals(1, b.getCol(0));
    assertEquals(3, b.getCol(1));
    assertEquals(0, b.getCol(2));
    assertEquals(2, b.getCol(3));
  }
}
