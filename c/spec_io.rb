require "dslisprb"

describe DsLisp, "C" do
  def lisp
    dslisp = DsLisp.new
    code = "(block " + File.open("c.lsp").read.gsub("\n"," ") + " )"
    dslisp.evaluate(code)
    dslisp
  end

  it "should run empty main" do 
    lisp.evaluate("(run '(
      (main (
        (printf 5)
        )
      )
    ))").should be == [5];
  end

  it "should run empty main" do 
    lisp.evaluate("(run '(
      (main (
        (printf 6)
        )
      )
    ))").should be == [6];
  end

  it "should run two printf" do 
    lisp.evaluate("(run '(
      (main (
        (printf 7)
        (printf 8)
        )
      )
    ))").should be == [7,8];
  end

  it "should read declared variables with value" do 
    lisp.evaluate("(run '(
      (int a = 10)
      (main (
          (printf a)
        )
      )
    ))").should be == [10]
  end

  it "should read declared variables with value" do 
    lisp.evaluate("(run '(
      (int a = 11)
      (main (
          (printf a)
        )
      )
    ))").should be == [11]
  end

  it "should allow input of values" do 
    lisp.evaluate("(run '(
      (int a)
      (main (
          (scanf a)
          (printf a)
        )
      )
    ) '(1))").should be == [1]
  end

  it "should allow input of values" do 
    lisp.evaluate("(run '(
      (int a)
      (main (
          (scanf a)
          (printf a)
        )
      )
    ) '(2))").should be == [2]
  end
end
