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
end
