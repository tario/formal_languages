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
end
