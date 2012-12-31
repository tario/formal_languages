require "dslisprb"

describe DsLisp, "N queens" do
  def lisp
    dslisp = DsLisp.new
    code = File.open("n_queens.lsp").read.gsub("\n"," ")
    dslisp.evaluate(code)
    dslisp
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
end
