require "dslisprb"

describe DsLisp, "C" do
  def lisp
    dslisp = DsLisp.new
    code = "(block " + File.open("c.lsp").read.gsub("\n"," ") + " )"
    dslisp.evaluate(code)
    dslisp
  end

  it "should run basic increment" do 
    lisp.evaluate("(run '(
      (int x = 10)
      (main (
        (x ++)
        (printf x)
        )
      )
    ))").should be == [11];
  end

  it "should run basic decrement" do 
    lisp.evaluate("(run '(
      (int x = 10)
      (main (
        (x --)
        (printf x)
        )
      )
    ))").should be == [9];
  end

  it "should run ht comparison" do 
    lisp.evaluate("(run '(
      (int x)
      (main (
        (x = 5 > 4)
        (printf x)
        )
      )
    ))").should be == [1];
  end

  it "should run ht comparison" do 
    lisp.evaluate("(run '(
      (int x)
      (main (
        (x = 4 > 4)
        (printf x)
        )
      )
    ))").should be == [0];
  end

  it "should run lt comparison" do 
    lisp.evaluate("(run '(
      (int x)
      (main (
        (x = 3 < 4)
        (printf x)
        )
      )
    ))").should be == [1];
  end

  it "should run lt comparison" do 
    lisp.evaluate("(run '(
      (int x)
      (main (
        (x = 4 < 4)
        (printf x)
        )
      )
    ))").should be == [0];
  end

  it "should run == comparison" do 
    lisp.evaluate("(run '(
      (int x)
      (main (
        (x = 3 == 4)
        (printf x)
        )
      )
    ))").should be == [0];
  end

  it "should run == comparison" do 
    lisp.evaluate("(run '(
      (int x)
      (main (
        (x = 4 == 4)
        (printf x)
        )
      )
    ))").should be == [1];
  end


  def self.test_expression(expr, expected_result)
    it "should execute '#{expr}' and should return #{expected_result}" do 
      lisp.evaluate("(run '(
        (int x)
        (main (
          (x = #{expr})
          (printf x)
          )
        )
      ))").should be == [expected_result];
    end
  end

  test_expression("1 + 1", 2)
  test_expression("1 - 1", 0)
  test_expression("2 * 2", 4)
  test_expression("10 / 5", 2)

  test_expression("10 * 4 + 5", 45)
  test_expression("5 + 10 * 4", 45)
  test_expression("5 - 2 - 3", 0)
  test_expression("5 - 2 + 3", 6)
  test_expression("5 + 3 - 2", 6)

  test_expression("5 * (3 + 7)", 50)

  it "should execute expression with variable" do 
    lisp.evaluate("(run '(
      (int y x = 10)
      (main (
        (y = x + 1)
        (printf y)
        )
      )
    ))").should be == [11];
  end

end
