require "dslisprb"

describe DsLisp, "C" do
  def lisp
    dslisp = DsLisp.new
    code = "(block " + File.open("c.lsp").read.gsub("\n"," ") + " )"
    dslisp.evaluate(code)
    dslisp
  end

  it "should assign single integer" do 
    lisp.evaluate("(run '(
      (int x = 10)
      (main (
        (x = 20)
        (printf x)
        )
      )
    ))").should be == [20];
  end
end
