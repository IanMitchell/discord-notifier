module Discord
  module Backports
    unless Hash.instance_methods(false).include?(:compact)
      refine Hash do
        def compact
          select { |_, value| !value.nil? }
        end
      end
    end
  end
end
