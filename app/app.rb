# frozen_string_literal: true

# The entry point of the web app
class App
  def call(_env)
    [204, {}, []]
  end
end
