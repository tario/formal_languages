require "dslisprb"

describe DsLisp, "C" do
  def lisp
    dslisp = DsLisp.new
    code = "(block " + File.open("c.lsp").read.gsub("\n"," ") + " )"
    dslisp.evaluate(code)
    dslisp
  end

  it "should run basic if" do 
    lisp.evaluate("(run '(
      (main (
        (if (1) (
          (printf 2)
        ))
        )
      )
    ))").should be == [2];
  end

  it "should run basic if" do 
    lisp.evaluate("(run '(
      (main (
        (if (0) (
          (printf 2)
        ))
        )
      )
    ))").should be == [];
  end


  it "should run basic if and run a command after that" do 
    lisp.evaluate("(run '(
      (main (
        (if (1) (
          (printf 2)
        ))

        (printf 3)
        )
      )
    ))").should be == [2,3];
  end

  it "should run basic if and run a command after that" do 
    lisp.evaluate("(run '(
      (main (
        (if (0) (
          (printf 2)
        ))

        (printf 3)
        )
      )
    ))").should be == [3];
  end


  it "should run basic if with else and run a command after that" do 
    lisp.evaluate("(run '(
      (main (
        (if (1) (
          (printf 2)
        ) else (
          (printf 22)
        ))

        (printf 3)
        )
      )
    ))").should be == [2, 3];
  end

  it "should run basic if with else and run a command after that" do 
    lisp.evaluate("(run '(
      (main (
        (if (0) (
          (printf 2)
        ) else (
          (printf 22)
        ))

        (printf 3)
        )
      )
    ))").should be == [22,3];
  end


  it "should run basic while" do 
    lisp.evaluate("(run '(
      (int a = 3)
      (main (
        (while (a) (
          (printf a)
          (a --)
        ))
        )
      )
    ))").should be == [3,2,1];
  end
end
