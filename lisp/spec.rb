require "dslisprb"

describe DsLisp, "LISP" do
  def lisp
    dslisp = DsLisp.new
    code = File.open("lisp.lsp").gsub("\n"," ")
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

  test_expression("(if T 1)")
  test_expression("(if nil 1 2)")

  test_expression("(+ 1 2)")
  test_expression("(+ (+ 1 2) 3)")

  test_expression("(let ((a 5)) a)")
  test_expression("(let ((a 6)) a)")

  test_expression("(let ((a 6)) (if T a))")
  test_expression("(let ((a '(1 2 3))) (car a))")

end
