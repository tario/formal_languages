require "dslisprb"

describe DsLisp, "N queens" do
  def lisp
    dslisp = DsLisp.new
    code = File.open("n_queens.lsp").gsub("\n"," ")
    dslisp.evaluate(code)
    dslisp
  end

  def is_valid_h(board)
    board.each do |line|
      if line.inject(&:+) > 1
        return false
      end
    end
    true
  end

  def is_valid_d(board)
    if board.size == 0
      true
    else

      (0..board.size-1).each do |m|
        return false if (0..board.size-1-m).map{|n| board[n][n+m] }.inject(&:+) > 1
      end

      is_valid_d(board[1..-1])
    end
  end

  def is_valid_board(board)
    is_valid_h(board) and is_valid_h(board.transpose) and is_valid_d(board) and is_valid_d(board.map(&:reverse))
  end

  def self.queen_line_test(n,m)
    it "reina_en_linea should return lines with queens with line length #{n} in position #{m}" do
      array = [0]*n
      array[m-1] = 1
      lisp.evaluate("(reina_en_linea #{n} #{m})").should be == array
    end
  end

  (2..4).each do |n|
    (1..n).each do |m|
      queen_line_test(n,m)
    end
  end

  it "(reinas 1) should return a board of 1x1 with the queen" do
    lisp.evaluate("(reinas 1)").should be == [[1]]
  end

  it "(reinas 2) should return nil because the problem has no solution" do
    lisp.evaluate("(reinas 2)").should be == nil
  end

  it "(reinas 3) should return nil because the problem has no solution" do
    lisp.evaluate("(reinas 3)").should be == nil
  end

  def self.test_reinas(n)
    it "(reinas #{n} should return a valid board with n queens)" do
      result = lisp.evaluate("(reinas #{n})")
      n_queens = result.map{|x| x.count{|y| y==1}}.inject(&:+)
      n_queens.should be == n
      is_valid_board(result).should be true
    end
  end

  test_reinas(4)
end
