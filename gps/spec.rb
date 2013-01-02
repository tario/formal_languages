require "dslisprb"

describe DsLisp, "GPS" do
  def lisp
    dslisp = DsLisp.new
    code = File.open("gps.lsp").read.gsub("\n"," ")
    dslisp.evaluate(code)
    dslisp
  end

  it "should solve single path" do
    lisp.evaluate("(camino_minimo '(1 2) '((1 2)) 1 2)").should be == [1, 2]
  end

  it "should solve alternate single path (1 3)" do
    lisp.evaluate("(camino_minimo '(1 3) '((1 3)) 1 3)").should be == [1, 3]
  end

  it "should solve two step path (1 2 3)" do
    lisp.evaluate("(camino_minimo '(1 2 3) '((1 2) (2 3)) 1 3)").should be == [1, 2, 3]
  end

end
