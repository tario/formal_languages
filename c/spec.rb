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

  it "should read simple variable declaration of two variables" do 
    lisp.evaluate("(declaracion '(int A B))").should be == [[:A, nil], [:B, nil]];
  end

  it "should read simple variable declaration with value" do 
    lisp.evaluate("(declaracion '(int A = 5))").should be == [[:A, 5]];
  end
end