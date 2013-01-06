require "dslisprb"

describe DsLisp, "C" do
  def lisp
    dslisp = DsLisp.new
    code = "(block " + File.open("c.lsp").read.gsub("\n"," ") + " )"
    dslisp.evaluate(code)
    dslisp
  end

  it "should read simple variable declaration" do 
    lisp.evaluate("(declaracion '(int A))").should be == [[:A, nil]];
  end
end
