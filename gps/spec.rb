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
end
