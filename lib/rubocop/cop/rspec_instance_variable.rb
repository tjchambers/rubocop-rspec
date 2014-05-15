# encoding: utf-8

module Rubocop
  module Cop
    # When you have to assign a variable instead of using an instance variable,
    # use let.
    #
    # @example
    #   # bad
    #   describe MyClass do
    #     before { @foo = [] }
    #     it { expect(@foo).to be_emtpy }
    #   end
    #
    #   # good
    #   describe MyClass do
    #     let(:foo) { [] }
    #     it { expect(foo).to be_emtpy }
    #   end
    class RSpecInstanceVariable < Cop
      MESSAGE = 'Use `let` instead of an instance variable'

      def on_block(node)
        method, _args, _body = *node
        _receiver, method_name, _object = *method
        @in_describe = true if method_name == :describe
      end

      def on_ivar(node)
        # only report instance variable inside a describe block, so that this
        # is limited to the specs
        add_offense(node, :expression, MESSAGE) if @in_describe
      end
    end
  end
end
