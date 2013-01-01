require "dslisprb"

describe DsLisp, "N queens" do
  def lisp
    dslisp = DsLisp.new
    code = File.open("lisp.lsp").read.gsub("\n"," ")
    dslisp.evaluate(code)
    dslisp
  end

  def self.test_expression(expr)
    it "should execute #{expr}" do 
      lisp.evaluate("(lisp '#{expr})").should be == lisp.evaluate(expr);
    end
  end

  test_expression("(car '(1 2 3))")
  test_expression("(car '(4 5 6))")
  test_expression("(car '(7 8 9))")

  test_expression("(cdr '(1 2 3))")
end
