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

end
